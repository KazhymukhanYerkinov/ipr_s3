# Цель 2: CI/CD с GitHub Actions

## Теория (что спросят)

### Что такое CI/CD?

- **CI (Continuous Integration)** — каждый push/PR автоматически проверяется: форматирование, анализ, тесты. Цель — ловить баги как можно раньше.
- **CD (Continuous Delivery)** — после успешного CI, автоматически собираются артефакты (APK, AAB, IPA) и могут деплоиться.

### GitHub Actions — основные понятия

| Понятие | Что это |
|---------|---------|
| **Workflow** | Один YAML-файл в `.github/workflows/`. Описывает весь pipeline |
| **Trigger** | Событие запуска: `on: push`, `on: pull_request` |
| **Job** | Набор шагов, выполняется на одном runner |
| **Step** | Одна команда или action |
| **Runner** | Виртуальная машина (ubuntu-latest, macos-latest) |
| **Action** | Готовый переиспользуемый блок (actions/checkout, flutter-action) |
| **Artifact** | Файл-результат сборки (APK, coverage report) |
| **Secret** | Зашифрованные переменные (токены, ключи) |

### Кэширование

GitHub Actions может кэшировать зависимости между запусками:
- `flutter-action` с `cache: true` кэширует Flutter SDK
- `actions/cache` может кэшировать pub-cache

Без кэша: каждый раз скачивает Flutter (~1.5 GB) + все пакеты.
С кэшом: берёт из кэша, экономит 3-5 минут.

---

## Что реализовано в проекте

### Файл: `.github/workflows/flutter-ci.yaml`

Pipeline состоит из **3 jobs**:

```
quality  ──→  build-android
         └──→  build-ios
```

`build-android` и `build-ios` запускаются **параллельно**, но только после успешного `quality`.

### Job 1: Quality (Качество кода)

```yaml
quality:
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v4           # Клонирует репозиторий
    - name: Setup Flutter                  # Устанавливает Flutter SDK
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.38.9'
        cache: true                        # Кэширование SDK
    - run: flutter pub get                 # Зависимости
    - name: Check formatting               # dart format --set-exit-if-changed
    - name: Run analyzer                   # flutter analyze --fatal-infos
    - name: Run tests with coverage        # flutter test --coverage
    - name: Upload coverage report         # Артефакт с покрытием
    - name: SonarCloud Scan                # Анализ качества
```

**Как объяснить каждый шаг**:

1. **Check formatting** — проверяет что код отформатирован по стандартам Dart. Исключает сгенерированные файлы (*.g.dart, *.freezed.dart). Если есть неформатированный файл → pipeline падает.

2. **Run analyzer** — `flutter analyze --fatal-infos` — статический анализ. Ловит типизацию, unused imports, потенциальные null errors. `--fatal-infos` означает что даже info-уровень ломает pipeline.

3. **Tests with coverage** — запускает все тесты и генерирует lcov.info (отчёт покрытия).

4. **SonarCloud Scan** — облачный анализ качества кода (подробнее ниже).

---

### SonarCloud — детально

#### Что это?

**SonarCloud** — облачный сервис статического анализа кода от компании Sonar. Анализирует код на:
- **Bugs** — реальные ошибки (null pointer, logic errors)
- **Vulnerabilities** — уязвимости безопасности (hardcoded passwords, SQL injection)
- **Code Smells** — "плохой запах" кода (слишком сложные функции, дублирование, мёртвый код)
- **Coverage** — процент покрытия тестами
- **Duplications** — процент дублированного кода

#### Зачем, если уже есть flutter analyze?

| | `flutter analyze` | SonarCloud |
|---|---|---|
| Что проверяет | Dart/Flutter lint rules | Баги, уязвимости, code smells, дубликаты |
| Покрытие тестами | Нет | Да (читает lcov.info) |
| Dashboard | Нет (только CLI) | Веб-интерфейс с графиками и трендами |
| History | Нет | Да — показывает динамику качества |
| Quality Gate | Нет | Да — можно задать "не мержить если coverage < 80%" |
| Security | Базовые lint | Глубокий анализ уязвимостей (OWASP) |

**Как объяснить**: "`flutter analyze` — это линтер (стиль кода, типизация). SonarCloud — глубже: ищет реальные баги, уязвимости, считает покрытие тестами, отслеживает тренды. Это как рентген для кода."

#### Как настроено в проекте

**1. GitHub Actions шаг:**
```yaml
- name: SonarCloud Scan
  uses: SonarSource/sonarcloud-github-action@v3
  env:
    SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
```

- `SonarSource/sonarcloud-github-action@v3` — официальный action от SonarCloud
- `SONAR_TOKEN` — токен аутентификации, хранится в **GitHub Secrets** (не в коде!)

**2. Конфигурация — `sonar-project.properties`:**
```properties
# Идентификация проекта на SonarCloud
sonar.projectKey=KazhymukhanYerkinov_ipr_s3
sonar.organization=kazhymukhanyerkinov
sonar.host.url=https://sonarcloud.io

# Где исходный код и тесты
sonar.sources=lib
sonar.tests=test

# Путь к отчёту покрытия (lcov.info генерируется flutter test --coverage)
sonar.dart.coverage.reportPaths=coverage/lcov.info

# Исключаем из анализа: сгенерированный код, нативные платформы, билды
sonar.exclusions=**/*.g.dart,**/*.freezed.dart,**/*.mocks.dart,android/**,ios/**,web/**,linux/**,macos/**,windows/**,build/**,.dart_tool/**

sonar.sourceEncoding=UTF-8
```

**Разбор каждого параметра:**

| Параметр | Зачем |
|----------|-------|
| `sonar.projectKey` | Уникальный идентификатор проекта на SonarCloud |
| `sonar.organization` | Организация/аккаунт на SonarCloud |
| `sonar.sources=lib` | Анализировать только `lib/` (исходный код) |
| `sonar.tests=test` | Папка с тестами (не считается в метриках дублирования) |
| `sonar.dart.coverage.reportPaths` | Путь к lcov.info — SonarCloud читает этот файл и показывает покрытие |
| `sonar.exclusions` | Что НЕ анализировать: `.g.dart`, `.freezed.dart` — сгенерированный код |

#### Почему исключаем сгенерированные файлы?

Файлы `*.g.dart` (json_serializable, hive_generator) и `*.freezed.dart` (freezed) — **автоматически сгенерированы**. Анализировать их бессмысленно:
- Мы не пишем этот код — его генерирует build_runner
- Он часто "некрасивый" (длинные функции, дублирование) — это нормально для codegen
- Покрытие тестами генерированного кода не показательно

#### Как работает флоу

```
flutter test --coverage
        │
        ▼
   coverage/lcov.info  ◄── содержит данные: какие строки выполнялись в тестах
        │
        ▼
   SonarCloud Scan
        │
        ├── Читает lib/ (исходники)
        ├── Читает test/ (тесты)
        ├── Читает coverage/lcov.info (покрытие)
        ├── Исключает *.g.dart, *.freezed.dart
        │
        ▼
   SonarCloud Dashboard (sonarcloud.io)
        │
        ├── Bugs: 0
        ├── Vulnerabilities: 0
        ├── Code Smells: 12
        ├── Coverage: 45%
        ├── Duplications: 3.2%
        └── Quality Gate: Passed ✓
```

#### Quality Gate

**Quality Gate** — набор условий, при невыполнении которых код считается "не готов". Стандартные условия SonarCloud:

| Метрика | Порог |
|---------|-------|
| New bugs | 0 |
| New vulnerabilities | 0 |
| New code coverage | >= 80% |
| New duplicated lines | <= 3% |

Если Quality Gate не пройден — SonarCloud помечает PR как failed. Это можно показать как status check в GitHub.

#### Что такое SONAR_TOKEN?

```yaml
env:
  SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
```

- `SONAR_TOKEN` — токен аутентификации, позволяет GitHub Actions отправлять данные на SonarCloud
- Хранится в **GitHub Secrets** (Settings → Secrets → Actions)
- **Не виден** в логах, не попадает в код
- Это пример **secrets management** — один из критериев Цели 2

#### Почему fetch-depth: 0?

```yaml
- uses: actions/checkout@v4
  with:
    fetch-depth: 0  # SonarCloud нужна полная git-история
```

По умолчанию `actions/checkout` клонирует только **последний коммит** (shallow clone, depth=1). SonarCloud нужна **полная история** чтобы:
- Определить какие строки новые (new code vs old code)
- Сравнить текущий PR с целевой веткой
- Посчитать метрики "на новом коде" (Quality Gate применяется к новому коду)

#### Возможные вопросы по SonarCloud

**В**: Что такое SonarCloud и зачем он в CI?
**О**: SonarCloud — облачный сервис анализа качества кода. Находит баги, уязвимости, code smells. Считает покрытие тестами и дублирование. В отличие от flutter analyze (который проверяет только стиль), SonarCloud делает глубокий анализ: сложность функций, безопасность (OWASP), тренды качества. Dashboard с графиками показывает динамику — улучшается код или деградирует.

**В**: Чем SonarCloud отличается от SonarQube?
**О**: SonarQube — self-hosted (ставишь на свой сервер). SonarCloud — облачный (SaaS), бесплатный для open-source. Функционал одинаковый. Для ИПР-проекта SonarCloud удобнее — не нужно поднимать сервер.

**В**: Что такое Quality Gate?
**О**: Набор пороговых условий: 0 новых багов, 0 уязвимостей, покрытие >= 80%, дупликация <= 3%. Если хотя бы одно условие не выполнено — Quality Gate "красный". Можно настроить чтобы PR не мёрджился при непройденном Quality Gate.

**В**: Зачем исключать *.g.dart и *.freezed.dart?
**О**: Это сгенерированный код (build_runner). Мы его не пишем и не контролируем. Анализировать его бессмысленно — он всегда "некрасивый" и не покрыт тестами. Включение его исказит реальные метрики.

**В**: Что такое SONAR_TOKEN и почему он в secrets?
**О**: Токен аутентификации для SonarCloud API. Хранится в GitHub Secrets — зашифрован, не виден в логах, недоступен в форках. Это пример secrets management из CI/CD best practices.

**В**: Зачем fetch-depth: 0?
**О**: SonarCloud анализирует "новый код" (new code period) — код добавленный в текущем PR. Для этого ему нужна полная git-история чтобы сравнить с базовой веткой. Shallow clone (depth=1) не содержит истории — SonarCloud не сможет определить что нового.

---

### Job 2: Build Android

```yaml
build-android:
  needs: quality    # Ждёт успешного quality
  runs-on: ubuntu-latest
  steps:
    - Setup Flutter + Java 17
    - flutter build apk --release      # Релизный APK
    - flutter build appbundle --release # AAB для Google Play
    - Upload APK artifact               # Хранится 14 дней
    - Upload AAB artifact
```

**Зачем два формата?**
- **APK** — можно установить напрямую на устройство
- **AAB (App Bundle)** — для публикации в Google Play (оптимизирован по размеру)

### Job 3: Build iOS

```yaml
build-ios:
  needs: quality
  runs-on: macos-latest        # iOS собирается только на macOS
  steps:
    - Setup Flutter
    - flutter build ios --release --no-codesign  # Без подписи
    - Upload iOS build artifact
```

**`--no-codesign`** — собираем без подписи, потому что для подписи нужен Apple Developer сертификат (платный). Для ИПР достаточно показать что сборка проходит.

### Важные детали

**Concurrency** — отменяет предыдущий pipeline если пришёл новый push:
```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true
```

**paths-ignore** — не запускает pipeline при изменении .md файлов:
```yaml
paths-ignore:
  - '**.md'
  - 'docs/**'
```

---

## Возможные вопросы на ассесменте

**В**: Что происходит когда ты делаешь PR в main?
**О**: Автоматически запускается workflow: сначала quality (format, analyze, test), потом параллельно build-android и build-ios. Если quality упал — билды не запускаются. Результат виден в PR как status check.

**В**: Зачем нужно кэширование?
**О**: Flutter SDK занимает ~1.5 GB. Без кэша каждый CI запуск скачивает его заново — это 3-5 минут. С `cache: true` SDK берётся из кэша GitHub, экономим время и трафик.

**В**: Что такое artifact?
**О**: Файл-результат сборки. В нашем случае — APK, AAB и iOS build. Хранится на GitHub 14 дней. Можно скачать и протестировать.

**В**: Зачем `--fatal-infos` в analyze?
**О**: Это строгий режим — даже info-уровень предупреждений ломает pipeline. Заставляет поддерживать чистый код. Без этого только errors и warnings ломают билд.

**В**: Почему build-ios запускается на macos-latest, а не ubuntu?
**О**: iOS-сборка требует Xcode, который работает только на macOS. Android можно собирать на Linux.

**В**: Что такое concurrency и cancel-in-progress?
**О**: Если я запушил коммит и pipeline запустился, а потом быстро запушил ещё один коммит — cancel-in-progress отменит первый (устаревший) pipeline и запустит только второй. Экономит ресурсы.
