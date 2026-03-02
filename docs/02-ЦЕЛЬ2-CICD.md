# Цель 2: Настройка CI/CD с GitHub Actions

## Теория

### Что такое CI/CD

**CI (Continuous Integration)** — автоматическая проверка кода при каждом коммите/PR:
форматирование, анализ, тесты. Ловит ошибки **до** попадания в main.

**CD (Continuous Delivery)** — автоматическая сборка артефактов (APK, AAB, IPA),
готовых к деплою. Разработчику не нужно вручную собирать релиз.

### GitHub Actions — основные концепции

```
Workflow (.yml файл)
  │
  ├── Trigger (on: push, pull_request)
  │
  ├── Job 1: quality (runs-on: ubuntu-latest)
  │     ├── Step 1: checkout
  │     ├── Step 2: setup flutter
  │     ├── Step 3: format check
  │     ├── Step 4: analyze
  │     └── Step 5: test
  │
  ├── Job 2: build-android (needs: quality)
  │     └── ...
  │
  └── Job 3: build-ios (needs: quality)
        └── ...
```

- **Workflow** — весь pipeline, описанный в YAML
- **Job** — группа шагов, выполняемых на одном runner'е
- **Step** — отдельная команда или action
- **Runner** — виртуальная машина (Ubuntu / macOS) от GitHub
- **Trigger** — событие, запускающее workflow (push, PR, schedule)

---

## Практика — наш workflow

**Файл:** `.github/workflows/flutter-ci.yaml`

### Триггеры

```yaml
on:
  push:
    branches: [ main ]
    paths-ignore:
      - '**.md'
      - 'docs/**'
      - '.gitignore'
  pull_request:
    branches: [ main ]
    paths-ignore:
      - '**.md'
      - 'docs/**'
      - '.gitignore'
```

#### Почему `paths-ignore`

Если я обновил только `README.md` или `docs/` — нет смысла запускать lint, тесты, сборку.
Экономим минуты раннера (у приватных репо лимит — 2000 мин/месяц).

#### Альтернатива — `paths` (whitelist)

```yaml
# Запускать ТОЛЬКО если изменились .dart или .yaml файлы
on:
  push:
    paths:
      - 'lib/**'
      - 'test/**'
      - 'pubspec.yaml'
```

Но это рискованно — можно пропустить изменения в `android/`, `ios/`, `.github/`.
`paths-ignore` безопаснее — запускается по умолчанию, исключаем только очевидное.

---

### Concurrency — отмена дублирующих pipeline

```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true
```

#### Почему

Если я запушил 3 коммита подряд за 1 минуту:
- **Без concurrency:** запустятся 3 pipeline-а → 3× расход ресурсов
- **С concurrency:** запустится только последний, предыдущие два отменятся

`group` = workflow name + branch → каждая ветка имеет свою группу.

---

### Job 1: Quality

```yaml
quality:
  name: Quality
  runs-on: ubuntu-latest
  timeout-minutes: 25
```

#### Step: Check formatting

```yaml
- name: Check formatting
  run: |
    find lib test -name '*.dart' \
      ! -name '*.g.dart' \
      ! -name '*.freezed.dart' \
      ! -path '*/generated/*' \
      | xargs dart format --set-exit-if-changed
```

##### Почему исключаем `*.g.dart` и `*.freezed.dart`

Это сгенерированные файлы (build_runner). Их форматирование зависит от генератора,
а не от разработчика. Проверять их бессмысленно — они перезаписываются при каждом
`build_runner build`.

##### Альтернатива — `dart format .`

```bash
# ❌ Проверит ВСЁ, включая generated файлы
dart format --set-exit-if-changed .
```

Будет падать на сгенерированных файлах.

#### Step: Static analysis

```yaml
- name: Run analyzer
  run: flutter analyze --fatal-infos
```

##### Почему `--fatal-infos`

Без флага `flutter analyze` предупреждает, но exit code = 0 (pipeline не падает).
`--fatal-infos` — exit code = 1 даже на info-уровне. Строгая дисциплина кода.

Уровни серьёзности:
- `info` — подсказки (unused import, missing return type)
- `warning` — потенциальные баги
- `error` — ошибки компиляции

#### Step: Tests with coverage

```yaml
- name: Run tests with coverage
  run: flutter test --coverage

- name: Upload coverage report
  uses: actions/upload-artifact@v4
  with:
    name: coverage-report-${{ github.sha }}
    path: coverage/lcov.info
    retention-days: 7
```

##### Почему `--coverage`

Генерирует `lcov.info` — файл с информацией о покрытии каждой строки кода.
Загружаем как artifact — можно скачать и проанализировать.

#### Step: SonarCloud

```yaml
- name: SonarCloud Scan
  uses: SonarSource/sonarcloud-github-action@v3
  env:
    SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
```

SonarCloud анализирует code quality: code smells, duplications, complexity, security hotspots.
`SONAR_TOKEN` хранится в GitHub Secrets — не в коде.

---

### Job 2: Build Android

```yaml
build-android:
  name: Build Android
  needs: quality          # ← запустится ТОЛЬКО после прохождения quality
  runs-on: ubuntu-latest
  timeout-minutes: 40
```

#### Почему `needs: quality`

Нет смысла собирать APK, если код не прошёл lint/test. Экономим ~40 минут раннера.

#### Steps

```yaml
- name: Setup Java
  uses: actions/setup-java@v4
  with:
    distribution: 'zulu'
    java-version: '17'

- name: Build APK
  run: flutter build apk --release

- name: Build AAB
  run: flutter build appbundle --release
```

##### Почему JDK 17 (Zulu)

Android Gradle Plugin (AGP) 8.x требует минимум JDK 17.
Zulu — бесплатный OpenJDK от Azul, популярен в CI.

##### APK vs AAB

| Формат | Для чего |
|--------|----------|
| APK | Тестирование, прямая установка |
| AAB (App Bundle) | Публикация в Google Play — Google оптимизирует размер под устройство |

#### Upload artifacts

```yaml
- name: Upload APK
  uses: actions/upload-artifact@v4
  with:
    name: android-apk-${{ github.sha }}
    path: build/app/outputs/flutter-apk/app-release.apk
    retention-days: 14
```

Имя артефакта включает `${{ github.sha }}` — уникальный хеш коммита.
14 дней хранения — достаточно для тестирования, не засоряет storage.

---

### Job 3: Build iOS

```yaml
build-ios:
  name: Build iOS
  needs: quality
  runs-on: macos-latest    # ← ОБЯЗАТЕЛЬНО macOS для iOS
```

#### Почему macOS

Xcode и iOS SDK доступны **только на macOS**. GitHub предоставляет macOS runners,
но они дороже (10× от Linux) — поэтому iOS билд запускаем только после quality.

```yaml
- name: Build iOS (no codesign)
  run: flutter build ios --release --no-codesign
```

#### Почему `--no-codesign`

Code signing требует сертификаты Apple Developer Program ($99/год).
Для CI/ИПР достаточно собрать без подписи — убедиться что компилируется.
Для реального проекта нужно добавить signing через Fastlane + GitHub Secrets.

---

### Параллельность jobs

```
quality ──┬──→ build-android
          │
          └──→ build-ios
```

`build-android` и `build-ios` запускаются **параллельно** (оба `needs: quality`).
Вместо последовательных ~80 минут получаем ~40 минут.

---

### Кэширование

```yaml
- name: Setup Flutter
  uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.38.9'
    channel: 'stable'
    cache: true            # ← кэширует Flutter SDK и pub cache
```

#### Под капотом

`cache: true` использует `actions/cache` для сохранения `~/.pub-cache` между запусками.

| Без кэша | С кэшем |
|-----------|---------|
| `flutter pub get` ~30с | `flutter pub get` ~3с |
| Скачивает все пакеты | Берёт из кэша |

---

## Альтернативы GitHub Actions

| Решение | Плюсы | Минусы |
|---------|-------|--------|
| **GitHub Actions** (наш выбор) | Бесплатно для публичных репо, нативная интеграция, macOS runners | Лимит минут для приватных |
| **Codemagic** | Заточен под Flutter, GUI | Платный для команд |
| **Bitrise** | GUI workflow builder | Медленнее, сложнее debug |
| **CircleCI** | Мощный, Docker support | Нет macOS для бесплатных |
| **Fastlane** | Code signing, deploy | Нужен Ruby, дополняет, не заменяет CI |

---

## Secrets Management

```yaml
env:
  SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
```

GitHub Secrets — зашифрованные переменные окружения:
- Не видны в логах (маскируются `***`)
- Не доступны в fork PR (безопасность)
- Управляются через Settings → Secrets → Actions

Для реального проекта здесь хранились бы:
- `SIGNING_KEY` — keystore для Android
- `APPLE_CERTIFICATE` — p12 для iOS signing
- `FIREBASE_TOKEN` — для Firebase App Distribution

---

## Критерии приёмки — чеклист

- [x] Рабочий workflow с этапами lint, test и build
- [x] Все PR автоматически запускают проверки
- [x] Проект собирается через GitHub Actions на Android и iOS
- [x] CI использует кэширование зависимостей для ускорения
- [x] `paths-ignore` исключает ненужные триггеры
- [x] `concurrency` отменяет дублирующие pipeline-ы
