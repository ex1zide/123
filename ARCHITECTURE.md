# 🏛 LegalHelp KZ — Архитектурный Манифест

> **Версия:** 2.0 • **Стандарт:** «Золотой ноутбук» • **Дата:** Апрель 2026  
> **Стек:** Flutter 3.x • Riverpod • GoRouter • Firebase • Gemini AI

---

## Содержание

1. [Философия проекта](#1-философия-проекта)
2. [Слоистая архитектура](#2-слоистая-архитектура)
3. [Стек и инструменты](#3-стек-и-инструменты)
4. [Модуль ИИ и RAG](#4-модуль-ии-и-rag)
5. [Enterprise-безопасность](#5-enterprise-безопасность)
6. [Система монетизации](#6-система-монетизации)
7. [Дизайн-система UI/UX](#7-дизайн-система-uiux)
8. [Сборка и автоматизация](#8-сборка-и-автоматизация)
9. [Дерево файлов](#9-дерево-файлов)

---

## 1. Философия проекта

LegalHelp KZ — это B2B/B2C Enterprise-платформа для юридической помощи гражданам Казахстана. Каждая архитектурная единица подчинена трём принципам:

| Принцип | Реализация |
|---------|-----------|
| **Отказоустойчивость** | Каждый `AsyncValue` обрабатывает `data`, `error` и `loading`. Никаких «вечных скелетонов» |
| **Безопасность** | Firebase App Check, Firestore Rules, Anti-Screenshot Shield |
| **Премиальный UX** | Deep Black & Gold, Glassmorphism, 60 fps, билингвальность (RU/KK) |

---

## 2. Слоистая архитектура

```
┌─────────────────────────────────────────────────┐
│                 PRESENTATION                     │
│   Screens • Widgets • Controllers (Riverpod)     │
├─────────────────────────────────────────────────┤
│                 APPLICATION                      │
│   GoRouter • Locale Controller • App Startup     │
├─────────────────────────────────────────────────┤
│                   DOMAIN                         │
│   Models • Entities • Enums                      │
├─────────────────────────────────────────────────┤
│                    DATA                          │
│   Repositories • Providers • Firebase Services   │
└─────────────────────────────────────────────────┘
```

### Presentation Layer (`lib/src/presentation/`)
- **Screens** — полноэкранные виджеты (`dashboard_screen.dart`, `chat_screen.dart`)
- **Widgets** — переиспользуемые компоненты (`chat_bubble.dart`, `shimmer_placeholder.dart`)
- **Controllers** — Riverpod Notifiers, управляющие UI-состоянием (`chat_controller.dart`)

> **Правило:** Контроллеры НЕ содержат бизнес-логику. Они делегируют её в Data Layer и управляют `AsyncValue<T>`.

### Application Layer (`lib/src/data/providers/`)
- **App Startup** — инициализация Firebase, App Check, кэшей
- **Locale Controller** — реактивное переключение RU/KK через `SharedPreferences`
- **Subscription Controller** — управление тарифами и лимитами запросов

### Domain Layer (`lib/src/domain/`)
- Чистые Dart-модели без зависимостей от Flutter или Firebase
- `LawyerProfile`, `LegalArticle`, `ChatMessage`, `SubscriptionState`

### Data Layer (`lib/src/data/repositories/`)
- **ChatRepository** — RAG-pipeline к Gemini AI
- **KnowledgeRepository** — поиск статей законов РК в Firestore
- **AuthRepository** — Firebase Auth (email/password, Google)
- **MarketplaceController** — real-time Firestore stream юристов

---

## 3. Стек и инструменты

### State Management: Riverpod 2.x

Все провайдеры генерируются через `riverpod_annotation` + `build_runner`:

```dart
@riverpod
class ChatController extends _$ChatController {
  @override
  FutureOr<List<ChatMessage>> build() async { ... }
}
```

**Паттерн обработки состояний (обязателен для каждого экрана):**

```dart
body: switch (asyncState) {
  AsyncData(:final value) => _BodyWidget(data: value),
  AsyncError(:final error) => _ErrorWidget(error: error),
  _ => const CircularProgressIndicator(),
},
```

### Навигация: GoRouter 14.x

- `StatefulShellRoute` с `BottomNavigationBar` для 4 вкладок
- Вложенные маршруты: `/app/dashboard/advice/:id`, `/app/dashboard/scanner`
- Декларативная конфигурация в `app_router.dart`

```
/splash
/auth
/app
  ├── /dashboard (Home)
  │     ├── /scanner
  │     ├── /sos
  │     └── /advice/:id
  ├── /chat (AI Lawyer)
  ├── /marketplace (Lawyers)
  └── /profile
        ├── /settings
        ├── /subscription
        ├── /documents
        ├── /history
        └── /support
```

### Локализация: flutter_gen + ARB

- `app_ru.arb` — русский (270+ ключей)
- `app_kk.arb` — казахский (270+ ключей)
- Генерация: `flutter gen-l10n` → `lib/l10n/app_localizations.dart`
- Доступ: `AppLocalizations.of(context)!.keyName`

---

## 4. Модуль ИИ и RAG

### Архитектура RAG (Retrieval-Augmented Generation)

```
┌──────────┐     ┌──────────────────┐     ┌──────────────┐
│  User    │────→│ KnowledgeRepo    │────→│ Firestore    │
│  Question│     │ searchArticles() │     │ knowledge_   │
└──────────┘     └────────┬─────────┘     │ base         │
                          │               └──────────────┘
                          ▼
              ┌───────────────────────┐
              │ buildContextPrompt()  │
              │ (законы РК → текст)   │
              └───────────┬───────────┘
                          │
                          ▼
              ┌───────────────────────┐     ┌──────────┐
              │ ChatRepository        │────→│ Gemini   │
              │ getAiResponse()       │     │ 1.5 Flash│
              │ [context + question]  │     └──────────┘
              └───────────────────────┘
```

### Файлы

| Файл | Роль |
|------|------|
| `knowledge_repository.dart` | Поиск статей в Firestore по ключевым словам |
| `chat_repository.dart` | RAG-pipeline: поиск → контекст → Gemini → ответ |

### Системный промпт (Anti-Hallucination)

```
"Ты — корпоративный ИИ-юрист Республики Казахстан.
Отвечай строго на основе переданного контекста (законодательства).
КАТЕГОРИЧЕСКИ ЗАПРЕЩЕНО выдумывать статьи, нормы или факты.
Если ответа нет в законах — предложи консультацию живого юриста."
```

### Firestore Collection: `knowledge_base`

```json
{
  "title": "Статья 131. Право на телефонный звонок",
  "codeName": "УПК РК",
  "articleNumber": "Ст. 131",
  "content": "Задержанный имеет право на один звонок...",
  "keywords": ["задержание", "звонок", "адвокат", "упк"]
}
```

---

## 5. Enterprise-безопасность

### 5.1 Firebase App Check

Файл: `app_startup_provider.dart`

```dart
await FirebaseAppCheck.instance.activate(
  androidProvider: AndroidProvider.playIntegrity,  // Production
  appleProvider: AppleProvider.appAttest,           // Production
  webProvider: ReCaptchaEnterpriseProvider('KEY'),  // Web
);
```

Защищает все Firebase-сервисы от ботов и несанкционированных API-вызовов.

### 5.2 Firestore Security Rules

Файл: `firestore.rules`

| Коллекция | Правило |
|-----------|---------|
| `/users/{uid}` | Полный CRUD только для `request.auth.uid == uid` |
| `/knowledge_base` | Read-only для авторизованных пользователей |
| `/lawyers` | Read-only для авторизованных |
| `/**` (всё остальное) | **DENY** по умолчанию |

### 5.3 Anti-Screenshot Shield

Для мобильных платформ — пакет `flutter_windowmanager`:

```dart
// В initState() защищённого экрана:
FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);

// В dispose():
FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
```

Применяется на: `chat_screen.dart`, `scanner_screen.dart`.

---

## 6. Система монетизации

### Тарифные планы

| План | Лимит запросов | Цена |
|------|---------------|------|
| **Free** | 10 запросов | 0 ₸ |
| **Pro** | Безлимит | 4 990 ₸/мес |
| **Business** | Безлимит + API | 29 990 ₸/мес |

### Файлы

| Файл | Роль |
|------|------|
| `subscription_provider.dart` | Riverpod контроллер с `SharedPreferences` persistence |
| `subscription_screen.dart` | UI тарифов с Glassmorphism и PRO-бейджем |
| `paywall_sheet.dart` | Bottom Sheet при исчерпании лимита |

### Paywall Interceptor (chat_controller.dart)

```dart
Future<bool> sendMessage(String text) async {
  final subState = ref.read(subscriptionControllerProvider).value;

  // 1. Проверка лимита
  if (subState != null && subState.isLimitReached) {
    return false; // → UI показывает PaywallSheet
  }

  // 2. Списание запроса (только для Free)
  if (subState != null && !subState.isPaid) {
    await ref.read(subscriptionControllerProvider.notifier).consumeQuery();
  }

  // 3. Отправка в Gemini через RAG
  final aiText = await repo.getAiResponse(text);
  ...
}
```

---

## 7. Дизайн-система UI/UX

### Цветовая палитра

| Токен | Hex | Применение |
|-------|-----|-----------|
| **Deep Black** | `#0A0A0A` | Фон всех экранов |
| **Surface** | `#1A1A1A` | Карточки, bottom sheets |
| **Gold Primary** | `#D4A843` | Акценты, CTA-кнопки, иконки |
| **Gold Light** | `#F5D67B` | Hover-состояния |
| **Error** | `#CF6679` | Ошибки |

### Glassmorphism

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: gold.withValues(alpha: 0.2)),
      ),
    ),
  ),
)
```

> ⚠️ **Правило 60 fps:** Избегай `BackdropFilter` внутри `ListView.builder`. Используй его только для статичных карточек и bottom sheets.

### Производительность

| Паттерн | Где | Зачем |
|---------|-----|-------|
| `ListView.builder(reverse: true)` | Chat | Оптимизация layout для чата |
| `FittedBox` + `Expanded` | Dashboard | Предотвращение overflow |
| `const` конструкторы | Везде | Уменьшение rebuild |
| `AnimationController` | ChatBubble | Плавное появление (Fade+Slide) |

---

## 8. Сборка и автоматизация

### Скрипт `start.bat`

Запуск одной командой:

```bash
./start.bat
```

Выполняет 5 шагов последовательно:

1. `flutter clean` — очистка кэша
2. `flutter pub get` — загрузка зависимостей
3. `flutter gen-l10n` — генерация локализации
4. `dart run build_runner build -d` — Riverpod кодогенерация
5. `flutter run` — запуск приложения

При ошибке на любом шаге — скрипт останавливается и выводит диагностику.

### Быстрый перезапуск (без clean)

```bash
./rebuild.bat
```

---

## 9. Дерево файлов

```
lib/
├── l10n/
│   ├── app_ru.arb              # Русская локализация (270+ ключей)
│   ├── app_kk.arb              # Казахская локализация
│   └── app_localizations.dart  # Сгенерировано flutter gen-l10n
├── src/
│   ├── data/
│   │   ├── providers/
│   │   │   ├── app_startup_provider.dart    # Firebase + App Check init
│   │   │   └── subscription_provider.dart   # Тарифы и лимиты
│   │   └── repositories/
│   │       ├── auth_repository.dart         # Firebase Auth
│   │       ├── chat_repository.dart         # RAG → Gemini pipeline
│   │       └── knowledge_repository.dart    # Firestore knowledge base
│   ├── domain/
│   │   └── domain.dart                      # Модели и сущности
│   └── presentation/
│       ├── chat/
│       │   ├── chat_screen.dart             # AI Chat (reverse ListView)
│       │   ├── chat_controller.dart         # Paywall interceptor
│       │   └── widgets/
│       │       ├── chat_bubble.dart          # Animated message bubbles
│       │       └── paywall_sheet.dart        # Premium upsell
│       ├── dashboard/
│       │   ├── dashboard_screen.dart        # Home with AsyncError handling
│       │   ├── advice_detail_screen.dart    # Hero-animated detail
│       │   └── widgets/
│       │       └── quick_actions_grid.dart   # Adaptive action cards
│       ├── screens/
│       │   ├── marketplace/                 # Lawyer marketplace + filter
│       │   └── profile/
│       │       ├── settings_screen.dart      # DropdownButton language switch
│       │       └── subscription_screen.dart  # Paywall with PRO badge
│       └── routing/
│           └── app_router.dart              # GoRouter declarative config
├── firebase_options.dart
└── main.dart
```

---

> **«Золотой ноутбук»** — это не просто дизайн. Это инженерная философия,  
> где каждая строка кода служит пользователю, а каждый пиксель — бренду.

*— LegalHelp KZ Engineering Team, 2026*
