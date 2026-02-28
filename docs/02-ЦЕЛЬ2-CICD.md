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
