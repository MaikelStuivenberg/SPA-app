# AGENTS.md

Instructions for AI coding agents working on **spa_app** — the School of Performing Arts camp app (Flutter, Android & iOS).

For general Flutter architecture, layout, localization, JSON serialization, and Firebase setup, use the skills in `.agents/skills/` (see [Skills](#skills)). This file covers **project-specific** layout, audience, experience goals, commands, and boundaries.

## Project overview

| | |
|---|---|
| Package | `spa_app` |
| Flutter SDK | `>=3.1.0 <4.0.0` (CI uses **3.38.7** stable) |
| State | **flutter_bloc** (Cubit) + **get_it** for DI |
| Routing | **go_router** with auth redirects and `AppShell` |
| Backend | Firebase (Auth, Firestore, Storage, Remote Config, Crashlytics, Messaging) |
| External APIs | WeatherAPI, Flickr (keys via `--dart-define`) |
| Lint | `very_good_analysis` (`analysis_options.yaml`) |

Entry flow: `lib/main.dart` → `bootstrap()` → `App`.

## Audience & experience

This app supports **School of Performing Arts (SPA)** — a Salvation Army camp. It is not a generic productivity tool; it should feel like part of the camp itself.

### Who uses it

| | |
|---|---|
| Age range | **9–30** (participants, volunteers, leaders) |
| Design target | **~15** — old enough for independence, still youthful and energetic |
| Context | On-site at camp — quick glances, outdoor use, shared excitement |

When in doubt, optimize for a **15-year-old at camp**: clear, upbeat, and easy to use without feeling childish to older teens and leaders.

### Tone & feel

- **Experience over utility** — screens should feel alive and camp-specific, not like admin software.
- **Fun is a requirement** — delight, personality, and energy belong in copy, visuals, and micro-interactions where they fit.
- **Warm and inclusive** — friendly, encouraging language; avoid corporate or clinical wording.
- **Performing arts energy** — celebrate creativity, schedules, tasks, photos, and shared moments; lean into the camp vibe already in the app.

### UI guidance for agents

- Prefer **short, scannable copy** and clear primary actions — users may be walking between activities.
- Use **visual hierarchy and spacing** so key info (next program, tasks, weather) stays obvious at a glance.
- Keep flows **simple and forgiving** — younger users and first-time app users should not get lost.
- Do **not** make the app feel like school homework, enterprise software, or a banking app.
- Respect Salvation Army context: wholesome, community-oriented, and appropriate for mixed ages — no edgy or exclusive humor.

Existing theme, widgets, and localization (`lib/l10n/`) set the baseline; extend that voice rather than resetting it.

### Encouraged delight (examples)

These patterns fit the camp vibe — use them where they reward meaningful moments, not on every interaction.

| Moment | Example |
|---|---|
| **Success / completion** | Confetti when a task is marked done, registration succeeds, or a milestone is reached |
| **Progress feedback** | Animated checkmarks, progress bars filling smoothly, subtle scale/bounce on completion |
| **Loading** | Playful loaders (e.g. `SpinKit` — already used on splash and home) instead of plain spinners |
| **Personal touch** | Warm greetings (“Hey {name}”), handwritten-style copy on welcome/onboarding screens |
| **Anticipation** | Countdown widgets building excitement toward the next program or camp event |
| **Identity & photos** | `Hero` transitions on profile avatars; polished photo grids that feel like a shared camp album |
| **Atmosphere** | Decorative performing-arts / camp iconography (theater, music) on auth and empty states |
| **Copy** | Short, upbeat messages — “Nice work!”, “You’re all set!”, “See you at the next session!” |
| **Micro-motion** | `AnimatedContainer`, `AnimatedSwitcher`, or light fade/slide transitions between states |

**Use celebration sparingly** — confetti and big animations belong on real wins (task done, sign-up complete), not routine navigation. Keep celebrations skippable or brief so users are not blocked between activities.

## Commands

Run from the repository root.

```bash
# Install dependencies
flutter pub get

# Analyze (must pass before finishing a task)
flutter analyze

# Run all tests
flutter test

# Run a single test file
flutter test test/user_mapper_test.dart

# Regenerate localization
flutter gen-l10n

# Run app (dev defaults for API keys are in Environment)
flutter run

# Run with production API keys
flutter run \
  --dart-define=WEATHER_API_KEY=... \
  --dart-define=FLICKR_API_KEY=... \
  --dart-define=FLICKR_USER_ID=...
```

Release builds use Fastlane under `android/` and `ios/`; GitHub Actions workflow: `.github/workflows/android-release.yml`.

## Architecture

Layered layout — do not bypass layers or call Firebase/plugins directly from UI except where already established in bootstrap.

```
lib/
├── app/              # App widget, bootstrap (Firebase init)
├── core/             # DI, router, theme, config, shared utils
├── domain/           # Repository interfaces, use cases, entities
│   └── entities/     # Domain models (Photo, Weather, …)
├── data/             # Services, repository impls, mappers, DTOs
│   └── models/       # API/parsing DTOs with fromJson → toEntity()
├── ui/
│   ├── core/widgets/ # Shared widgets (AppShell, scaffolds, cards)
│   └── features/     # Feature screens, cubits, feature models
├── l10n/             # ARB files + generated localizations
└── firebase_options.dart
```

### Theming

Brand colors live in `lib/core/theme/app_palette.dart` (SPA navy, cyan, Leger des Heils red). Use `Theme.of(context).colorScheme` for Material roles and `context.appColors` (`theme_extensions.dart`) for semantic accents (`ruleAccents`, `favorite`, `scrim`, etc.). Do not use `Colors.blue`, raw hex, or deprecated `AppColors` in UI code.

### Adding or changing a feature

1. **Domain** — add or extend a repository interface in `lib/domain/repositories/`.
2. **Data** — implement in `lib/data/repositories/*_impl.dart`; wrap external APIs in `lib/data/services/`.
3. **Register** — wire dependencies in `lib/core/di/injection.dart`.
4. **UI** — cubit under `lib/ui/features/<feature>/cubit/`, pages under `pages/`.
5. **Routes** — add path to `lib/core/router/route_paths.dart` and route in `lib/core/router/app_router.dart`.

Use constructor injection for cubits; resolve shared singletons via `getIt` only at composition boundaries (e.g. `App`, router guards).

### Patterns to follow

**Good — cubit depends on repository interface:**

```dart
class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit({required WeatherRepository weatherRepository})
      : _weatherRepository = weatherRepository,
        super(const WeatherState.initial());

  final WeatherRepository _weatherRepository;
}
```

**Avoid — Firebase or GetIt inside cubit logic:**

```dart
// Don't: FirebaseFirestore.instance in a cubit
// Don't: getIt<UserRepository>() inside cubit methods
```

**Good — navigation:**

```dart
context.go(RoutePaths.home);
context.push(RoutePaths.taskDetails, extra: task);
```

**Avoid — legacy Navigator API:**

```dart
Navigator.pushNamed(context, '/home'); // removed from this project
```

### Remote Config & secrets

- Read feature flags through `RemoteConfigService` (GetIt), not `FirebaseRemoteConfig.instance` in UI.
- Keys live in `lib/core/config/remote_config_keys.dart`.
- API keys: `lib/core/config/environment.dart` via `--dart-define`. Do not add new hardcoded production secrets.

## Skills

Read the relevant skill **before** implementing in that area:

| Topic | Skill path |
|---|---|
| Layered architecture / MVVM | `.agents/skills/flutter-apply-architecture-best-practices/` |
| Responsive layout | `.agents/skills/flutter-build-responsive-layout/` |
| Layout bugs | `.agents/skills/flutter-fix-layout-issues/` |
| JSON / freezed / codegen | `.agents/skills/flutter-implement-json-serialization/` |
| Localization | `.agents/skills/flutter-setup-localization/` |
| Firebase Auth | `.agents/skills/firebase-auth-basics/` |
| Firestore | `.agents/skills/firebase-firestore/` |
| Remote Config | `.agents/skills/firebase-remote-config-basics/` |
| Crashlytics | `.agents/skills/firebase-crashlytics/` |

Installed skills are tracked in `skills-lock.json`.

## Testing

- **Unit tests:** cubits (use `bloc_test` + `mocktail`), mappers, pure domain logic.
- **Widget tests:** minimal smoke tests; mock repositories/cubits as needed.
- Tests live in `test/` at repo root.

After code changes, run `flutter analyze` and `flutter test` before marking work complete.

## Boundaries

### Always

- Put new feature UI under `lib/ui/features/`, not `lib/features/` (legacy duplicate tree — do not extend).
- Register new services/repos/cubits in `injection.dart`.
- Use `RoutePaths` constants for paths.
- Match existing naming and import style (`package:spa_app/...`).

### Ask first

- Changing Firestore schema or security rules.
- Modifying Fastlane lanes, signing, or CI secrets.
- Large migrations (e.g. moving all of `lib/shared/models/` to domain entities).

### Never

- Commit `.env`, keystore files, `google-services.json` / `GoogleService-Account*.json`, or SSH keys.
- Call `FirebaseAuth.instance` / `FirebaseFirestore.instance` from cubits — use `AuthService` / repositories.
- Introduce Riverpod or another DI/state stack alongside GetIt + Bloc without an explicit request.
- Delete tests or skip CI checks to make a build pass.
- Modify generated files by hand (`*.g.dart`, `app_localizations*.dart`) — run codegen instead.
- Add **freezed** / codegen to domain models unless explicitly requested — use plain Dart classes.

## Git & PRs

- Do not create commits or open PRs unless the user asks.
- Recent commit style is short and descriptive (e.g. `flutter upgrade`, `bugfix`); prefer clear messages for substantive changes.

## Known follow-ups (intentional debt)

- Remove duplicate `lib/features/` tree once fully unused.
- Move `UserData` from `ui/features/user/models/` to `domain/entities/` when convenient.

---

*Last reviewed: June 2026. Update this file when architecture or CI conventions change.*
