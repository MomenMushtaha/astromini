# astromini - Architecture & Design Patterns Document

## Overview

astromini is a Flutter astrology application featuring daily horoscopes for all 12 zodiac signs
and an AI-powered Astrology & Horoscope chat agent. Users can browse zodiac signs, read
personalized daily horoscopes, and chat with an AI astrologer for guidance.

---

## Design Patterns Used

### 1. Provider Pattern (State Management)

**Pattern:** Observer / Publish-Subscribe via `ChangeNotifier` + `Provider`

**Where:** `ChatProvider`, `HoroscopeProvider`

**Justification:**
- Flutter's recommended approach for medium-complexity apps. It avoids the boilerplate of
  BLoC for an app of this size while still cleanly separating UI from business logic.
- `ChangeNotifier` acts as the Subject; widgets rebuild via `Consumer`/`context.watch`
  when state changes.
- Scales well — if the app grows, providers can be composed or replaced with Riverpod
  without rewriting widgets.

---

### 2. Repository Pattern (Data Access)

**Pattern:** Repository

**Where:** `HoroscopeService`, `AIChatService`

**Justification:**
- Abstracts data sources (API calls, local generation) behind a clean interface.
- The UI layer never knows whether horoscope data comes from an API, local computation,
  or cache. This makes it trivial to swap in a real API later.
- Keeps providers thin — they delegate data-fetching to services and focus on state.

---

### 3. Model-View-ViewModel (MVVM)

**Pattern:** MVVM

**Where:** Models (`ZodiacSign`, `ChatMessage`, `Horoscope`) → Providers (ViewModels) → Screens (Views)

**Justification:**
- Clean separation of concerns: Models hold data, Providers hold logic + state, Screens
  render UI and react to state changes.
- Flutter's widget tree naturally maps to the View layer; Provider bridges the gap to
  ViewModel semantics.
- Testable — providers can be unit-tested without widget trees.

---

### 4. Singleton Pattern

**Pattern:** Singleton

**Where:** `AIChatService`, `HoroscopeService` (instantiated once via Provider at the root)

**Justification:**
- Services are stateless utilities — no need for multiple instances.
- Provided once at the widget tree root and shared via dependency injection (Provider).
- Avoids global mutable state while still ensuring a single instance.

---

### 5. Strategy Pattern (AI Response Generation)

**Pattern:** Strategy

**Where:** `AIChatService._generateResponse()` with topic-specific response strategies

**Justification:**
- The AI agent selects different response strategies based on the user's query topic
  (compatibility, daily reading, personality traits, career guidance).
- New topics can be added by extending the strategy map without modifying existing logic.
- Open/Closed Principle — open for extension, closed for modification.

---

### 6. Composite Pattern (Widget Composition)

**Pattern:** Composite

**Where:** All screen widgets compose smaller widget building blocks (`ZodiacCard`,
`ChatBubble`, `HoroscopeHeader`)

**Justification:**
- Flutter's core paradigm — complex UIs are composed from simple, reusable widgets.
- Each widget has a single responsibility and can be tested or styled independently.
- Promotes reuse across screens (e.g., `ZodiacCard` used in both home grid and chat).

---

## Project Structure

```
lib/
├── main.dart                  # App entry point, provider setup, routing
├── models/
│   ├── zodiac_sign.dart       # Zodiac sign data model with traits & dates
│   ├── chat_message.dart      # Chat message model (user/ai sender)
│   └── horoscope.dart         # Daily horoscope data model
├── providers/
│   ├── chat_provider.dart     # Chat state management (ChangeNotifier)
│   └── horoscope_provider.dart# Horoscope state management
├── screens/
│   ├── home_screen.dart       # Zodiac grid + navigation
│   ├── horoscope_screen.dart  # Daily horoscope detail view
│   └── chat_screen.dart       # AI astrologer chat interface
├── services/
│   ├── ai_chat_service.dart   # AI response generation (Strategy pattern)
│   └── horoscope_service.dart # Horoscope data provider (Repository pattern)
├── theme/
│   └── app_theme.dart         # Dark cosmic theme definition
└── widgets/
    ├── zodiac_card.dart       # Zodiac sign card widget
    └── chat_bubble.dart       # Chat message bubble widget
```

## Tech Stack

| Layer           | Technology              |
|-----------------|------------------------|
| Framework       | Flutter 3.41            |
| State Mgmt     | Provider + ChangeNotifier |
| Navigation      | Navigator 2.0 (MaterialPageRoute) |
| Theming         | Material 3 (dark cosmic theme) |
| AI Chat         | Built-in response engine (swappable for API) |
| Animations      | Implicit animations + AnimatedList |

## Future Extensibility

- **Real AI API:** Replace `AIChatService` with an HTTP client calling OpenAI/Claude API.
- **Push Notifications:** Add daily horoscope reminders via Firebase Messaging.
- **User Profiles:** Store birth chart data for personalized readings.
- **Riverpod Migration:** Drop-in replacement for Provider if complexity grows.
