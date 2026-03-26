# astromini - Architecture & Design Patterns Document

## Overview

astromini is a Flutter astrology application featuring daily horoscopes for all 12 zodiac signs
and an AI-powered Astrology & Horoscope chat agent. Users can browse zodiac signs, read
personalized daily horoscopes, and chat with an AI astrologer for guidance.

---
## Functional Requirements

### FR-1: Authentication
- The user shall be able to sign up with email and password.
- The user shall be able to sign in with email and password.
- The user shall be able to sign in with Google (OAuth) on iOS and macOS.
- The user shall be able to continue as a guest without creating an account.
- The app shall persist authentication state across sessions via Firebase Auth.
- On unsigned macOS builds, the app shall gracefully fall back to guest mode when a keychain error occurs during Google Sign-In.

### FR-2: Home Screen & Zodiac Grid
- The app shall display all 12 zodiac signs in a scrollable grid.
- Each zodiac card shall show the sign's symbol, name, and date range.
- Tapping a zodiac card shall navigate to that sign's daily horoscope.
- When the user has a birth chart, the home header shall display a personalized profile card showing Sun, Moon, and Rising sign badges.
- The home screen shall display a Daily Tip card with a sign-specific cosmic tip.

### FR-3: Daily Horoscopes
- The app shall generate and display a daily horoscope for each zodiac sign.
- Each horoscope shall include a mood, lucky number, compatibility sign, and descriptive reading.
- Horoscope data shall be provided via `HoroscopeService` (repository pattern, swappable for a real API).

### FR-4: Birth Chart
- The user shall be able to enter their name, birth date, birth time, and birth location.
- The app shall compute a natal birth chart with Sun, Moon, Rising, Mercury, Venus, and Mars placements.
- The birth chart shall be displayed as an interactive chart wheel (`ChartWheel` widget).
- Individual planet placements shall be shown as detail cards with sign, degree, and interpretation.
- Aspect lines (conjunctions, oppositions, trines, squares, sextiles) shall be computed and listed.
- Birth data shall be persisted locally via `SharedPreferences` and restored on app launch.

### FR-5: Sky Map (Live Transits)
- The app shall display a live sky map showing current planetary positions.
- The sky map wheel shall rotate continuously with a slow animation.
- Transit alerts shall be generated based on the user's birth chart placements.
- Each alert shall describe how the current transit affects the user personally.

### FR-6: AI Astrologer Chat
- The user shall be able to chat with an AI astrologer in a conversational interface.
- The AI shall respond contextually based on the user's birth chart and personality profile (if available).
- The AI shall support topic-specific responses: compatibility, daily readings, personality traits, and career guidance.
- Chat messages shall be displayed in a scrollable list with distinct user/AI chat bubbles.
- The chat shall show a typing indicator while the AI generates a response.

### FR-7: Compatibility
- The user shall be able to enter a partner's birth details (name, date, time, location).
- The app shall compute a compatibility score between the user's chart and the partner's chart.
- A synastry wheel shall overlay both charts visually.
- A score meter shall display the overall compatibility percentage.

### FR-8: Social Feed
- The app shall display a feed of astrology-themed social posts.
- Posts shall be filterable by zodiac sign via filter chips.
- When the user has a birth chart, the feed shall auto-filter to the user's Sun sign on first load.
- Each post shall display the author, sign, content, and engagement metrics.

### FR-9: Personality Profile
- The app shall generate a personality profile based on the user's birth chart.
- The profile shall include strengths, weaknesses, and trait descriptions derived from planetary placements.

### FR-10: Daily Tip Card (Mixin Demo)
- The `DailyTipCard` shall display a sign-specific cosmic tip with a breathing pulse animation.
- The animation shall be provided via `CosmicBreathingMixin` (demonstrates Dart mixins with `TickerProvider`).
- The card shall read the user's sign from `BirthChartProvider` using `didChangeDependencies` (not `initState`), and update reactively when the sign changes.

---

## Non-Functional Requirements

### NFR-1: Platform Support
- The app shall run on macOS, iOS, and web (Flutter multi-platform).
- Platform-specific behaviors (e.g., keychain access on macOS, Google Sign-In availability on web) shall be handled gracefully with appropriate fallbacks and user-facing messages.

### NFR-2: Architecture & Maintainability
- The app shall follow MVVM architecture: Models hold data, Providers (ViewModels) hold logic and state, Screens (Views) render UI.
- State management shall use Provider + ChangeNotifier with reactive rebuilds via `context.watch`.
- Data access shall be abstracted behind service classes (Repository pattern), making it possible to swap local generation for real API calls without changing the UI layer.
- The codebase shall be organized into `models/`, `providers/`, `screens/`, `services/`, `widgets/`, `mixins/`, and `theme/` directories.

### NFR-3: Performance
- The home screen shall use `SliverGrid` for efficient rendering of the zodiac grid.
- Screen state shall be preserved across tab switches using `IndexedStack`.
- Animations shall use dedicated `AnimationController` instances with `SingleTickerProviderStateMixin` to avoid unnecessary rebuilds.
- The `DailyTipCard` shall use `AnimatedBuilder` to rebuild only the animated subtree.

### NFR-4: Persistence
- Birth chart data shall be persisted locally using `SharedPreferences` and auto-loaded on app startup.
- Firebase Auth shall persist user sessions so returning users do not need to re-authenticate.

### NFR-5: Security
- Passwords shall have a minimum length of 6 characters (enforced client-side and by Firebase).
- Firebase Auth errors (invalid credentials, duplicate email, weak password) shall be caught and displayed as user-friendly messages.
- Google Sign-In shall validate `PlatformException` errors and display actionable guidance (e.g., missing `CLIENT_ID`).
- The app shall not store raw credentials locally; authentication is delegated entirely to Firebase Auth.

### NFR-6: Error Handling & Resilience
- Firebase initialization failure shall not crash the app; the app shall continue with limited functionality.
- All authentication flows shall include loading states, error SnackBars, and `mounted` checks before updating UI.
- Google Sign-In on web shall be blocked with an informative message rather than crashing.
- Keychain errors on unsigned macOS builds shall be caught and fall back to guest mode.

### NFR-7: Theming & UI
- The app shall use a dark cosmic theme (Material 3) defined centrally in `AppTheme`.
- All screens shall share consistent typography, color tokens, and spacing.
- The bottom navigation bar shall provide access to 5 primary sections: Home, Chart, Sky, Chat, and Social.

### NFR-8: Offline Capability
- Horoscope generation, birth chart computation, AI chat responses, and compatibility scoring shall work offline using built-in local algorithms.
- The only features requiring network are Firebase authentication and Google Sign-In.

---

## Future Extensibility

- **Real AI API:** Replace `AIChatService` with an HTTP client calling OpenAI/Claude API.
- **Push Notifications:** Add daily horoscope reminders via Firebase Messaging.
- **Cloud Sync:** Sync birth chart data to Firestore for cross-device access.
- **Riverpod Migration:** Drop-in replacement for Provider if complexity grows.

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

