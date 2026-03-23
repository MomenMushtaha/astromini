# astromini — Complete Project Plan

## Overview

astromini is a Flutter astrology app styled with a dark cosmic theme ("astromini" — lowercase like "gemini"). It started as a basic zodiac horoscope reader with an AI chat agent and was expanded into a feature-rich astrology platform with six major features: birth chart generation, live planetary tracking, AI personality profiling, compatibility analysis, a data-driven AI analyst agent, and a social feed.

**Platform:** Flutter 3.41.5 / Dart 3.11.3, macOS (darwin-arm64)
**State management:** Provider + ChangeNotifier (MVVM)
**Theme:** Dark cosmic — deep purple `#0D0D2B`, gold `#FFD54F`, purple accent `#7C4DFF`, Poppins font
**AI:** Local keyword-matching service (no external API), upgraded to data-driven analyst referencing exact planetary positions
**Authentication:** Firebase Auth (email/password + Google Sign-In) with `AuthProvider` stream-based state
**Astronomy:** Pure Dart implementation — simplified VSOP87/Meeus formulas (~1-2 degree accuracy), no external packages
**Location:** 100+ preset cities, custom lat/lng/UTC coordinate input, GPS-based current location via Geolocator + Geocoding

---

## Design Patterns

| Pattern | Where | Justification |
|---------|-------|---------------|
| **MVVM** | Models → Providers → Screens | Separates data, business logic, and UI across all features |
| **Strategy** | `AIChatService` response routing | Different response strategies (chart-based, transit, love, career) selected by keyword matching |
| **Facade** | `AstroEngine` wrapping 5 calculation modules | Hides astronomical math (Julian dates, VSOP87, houses, aspects, zodiac) behind `calculateChart()` and `currentPositions()` |
| **Repository** | `SocialFeedService` (mock data behind interface) | Abstracts data source so a real backend (Firebase/REST) can replace mock data without touching UI/providers |
| **Factory** | `AstroEngine.calculateChart()` | Constructs complex `BirthChart` from raw date/time/location parameters |
| **Proxy Provider** | `ChangeNotifierProxyProvider2` for `ChatProvider` | Injects birth chart + personality profile into AI chat so responses become personalized automatically |
| **Template Method** | `CustomPainter` subclasses for chart wheels | Natal chart (`ChartWheelPainter`), sky map (`SkyWheelPainter`), and synastry (`SynastryWheelPainter`) share structure: draw ring → draw divisions → draw objects → draw aspect lines |
| **Composite** | Widget composition throughout | Complex screens built from focused, reusable widget components |
| **Stream-Based Auth** | `AuthProvider` subscribes to `authStateChanges()` | Reactive auth state — sign in/out automatically propagates to UI via `notifyListeners()` |

---

## Architecture

```
┌──────────────────────────────────────────────────────┐
│                    MainShell                          │
│  BottomNavigationBar + IndexedStack (5 tabs)         │
├──────────┬──────────┬──────────┬──────────┬──────────┤
│  Home    │  Chart   │  Sky Map │  Chat    │  Social  │
│          │          │          │          │          │
│ Zodiac   │ Birth    │ Live     │ AI       │ Cosmic   │
│ Grid +   │ Chart    │ Planetary│ Analyst  │ Feed +   │
│ Horoscope│ Generator│ Tracking │ Agent    │ Reactions │
└──────────┴──────────┴──────────┴──────────┴──────────┘
         │              │              │
         ▼              ▼              ▼
┌─────────────────────────────────────────────────────┐
│                   Providers                          │
│ AuthProvider  HoroscopeProvider  BirthChartProvider   │
│ SkyMapProvider  UserProfileProvider                  │
│ CompatibilityProvider  SocialFeedProvider            │
│ ChatProvider (ProxyProvider)                         │
└─────────────────────────────────────────────────────┘
         │              │              │
         ▼              ▼              ▼
┌─────────────────────────────────────────────────────┐
│                    Services                          │
│ AstroEngine (Facade)    AIChatService (Strategy)    │
│ PersonalityService      CompatibilityService        │
│ SocialFeedService       StorageService              │
│ HoroscopeService                                    │
└─────────────────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────────┐
│              Astro Calculation Engine                 │
│ JulianDate → PlanetaryPositions → HouseSystem       │
│ ZodiacUtil → AspectCalculator → TransitData          │
│ InterpretationData → SynastryData                   │
└─────────────────────────────────────────────────────┘
```

---

## Implementation Phases

### Phase 0: Infrastructure
**Goal:** Navigation shell, persistent storage, and the astronomical calculation engine that all features depend on.

**Navigation change:** Replace single-screen push/pop with `BottomNavigationBar` + `IndexedStack` in `MainShell`. 5 tabs: Home, Birth Chart, Sky Map, Chat, Social.

**New dependency:** `shared_preferences: ^2.3.0`

**Files created:**
- `lib/screens/main_shell.dart` — Bottom nav shell with IndexedStack
- `lib/services/storage_service.dart` — SharedPreferences wrapper (save/load/clear birth data)
- `lib/models/birth_data.dart` — Birth date/time/location model with JSON serialization, `birthDateTimeUtc` getter
- `lib/services/astro/astro_engine.dart` — Facade: `calculateChart(BirthData)` → `BirthChart`, `currentPositions()` for sky map
- `lib/services/astro/julian_date.dart` — DateTime → Julian Date/Century, GMST, LST, obliquity
- `lib/services/astro/planetary_positions.dart` — Simplified VSOP87/Meeus for 10 bodies (Sun through Pluto)
- `lib/services/astro/house_system.dart` — Equal House system (Ascendant, MC, 12 cusps)
- `lib/services/astro/aspects.dart` — Detect conjunction/sextile/square/trine/opposition with standard orbs
- `lib/services/astro/zodiac_util.dart` — Ecliptic longitude → zodiac sign + degree + minute

**Files modified:**
- `lib/main.dart` — Register all new providers, `SharedPreferences` init, `MainShell` as home
- `lib/screens/home_screen.dart` — Removed AI chat banner (chat is now a tab)
- `pubspec.yaml` — Added `shared_preferences: ^2.3.0`
- `macos/Runner/DebugProfile.entitlements` — Added `network.client` for Google Fonts
- `macos/Runner/Release.entitlements` — Added `network.client`

---

### Phase 1: Birth Chart Generator
**Goal:** Users enter birth date/time/location, get an interactive natal chart wheel with planets, houses, and aspects.

**Files created:**
- `lib/models/birth_chart.dart` — Chart model: planets map, houseCusps, ascendant, midheaven, aspects, elementBalance
- `lib/models/planet_position.dart` — `CelestialBody` enum (10 planets with symbols/names), `ZodiacPosition`, `PlanetPosition`
- `lib/models/aspect.dart` — `AspectType` enum (conjunction/sextile/square/trine/opposition with angle/maxOrb/color), `Aspect`
- `lib/providers/birth_chart_provider.dart` — Manages `BirthData`, `BirthChart`; `loadSavedBirthData()`, `calculateChart()`, `clearChart()`
- `lib/screens/birth_chart_screen.dart` — Two-state screen: input form (date/time/location pickers) or chart display (wheel + planet cards + aspects + Profile/Compatibility buttons)
- `lib/widgets/chart_wheel.dart` — StatelessWidget wrapping `CustomPaint` with `ChartWheelPainter`
- `lib/widgets/chart_wheel_painter.dart` — CustomPainter: outer zodiac ring (element-colored), house lines, planet glyphs at correct degrees, colored aspect lines (dashed for opposition)
- `lib/widgets/planet_placement_card.dart` — Card showing planet glyph, name, sign/degree, house number, retrograde badge
- `lib/widgets/aspect_list_tile.dart` — Color-coded aspect display with planet symbols and orb
- `lib/widgets/location_picker.dart` — 50 major world cities with lat/lng/utcOffset, searchable list

**Chart wheel rendering:**
1. Outer ring: 12 sign segments colored by element (Fire=red, Earth=green, Air=yellow, Water=blue), rotated so Ascendant is at 9 o'clock
2. House lines: 12 lines from center to inner ring at each cusp degree, with house numbers
3. Planet glyphs: Positioned on intermediate ring at correct ecliptic longitude (retrograde planets shown in red)
4. Aspect lines: Colored lines through center (blue=trine, green=sextile, gold=conjunction, red=square/opposition), dashed for oppositions

---

### Phase 2: Live Sky Map
**Goal:** Real-time planetary positions with animated transitions and transit alerts.

**Files created:**
- `lib/models/transit_alert.dart` — `TransitType` enum, `TransitAlert` with `isActive`/`isUpcoming` getters
- `lib/providers/sky_map_provider.dart` — `Timer.periodic(60s)` recalculates positions, checks transit data
- `lib/screens/sky_map_screen.dart` — Animated sky wheel (via `AnimationController`) + planet position list + horizontal transit alert scroll (active + upcoming)
- `lib/widgets/sky_wheel_painter.dart` — Simplified chart painter (no houses), animated rotation, optional natal chart overlay (faded glyphs)
- `lib/widgets/transit_alert_card.dart` — Compact card with planet symbol, title, description, active/upcoming badge, date
- `lib/services/astro/transit_data.dart` — Pre-computed major transits 2024-2027 (Mercury retrogrades, Venus/Mars ingresses, eclipses, conjunctions)

---

### Phase 3: AI Personality Profile
**Goal:** Deep personality reading from full birth chart with element balance, planetary influences, strengths/challenges.

**Files created:**
- `lib/models/personality_profile.dart` — `PlanetaryInfluence`, `PersonalityProfile` (sun/moon/rising analysis, elementBalance, strengths, challenges, loveStyle, careerAptitude)
- `lib/services/personality_service.dart` — `PersonalityService.generate(chart)` assembling profile from interpretation data, with signStrengths/signChallenges/venusStyle/marsStyle/sunCareer/saturnLesson maps
- `lib/services/astro/interpretation_data.dart` — Static maps: 12 sunSign, 12 moonSign, 12 risingSigns, 36 planetSign interpretations
- `lib/providers/user_profile_provider.dart` — `generateProfile(chart)`, `clearProfile()`
- `lib/screens/profile_screen.dart` — Sun/Moon/Rising badges, element balance progress bars, planetary influences list, love style, career aptitude, strengths (green chips), growth areas (red chips), overall summary

---

### Phase 4: Compatibility Scanner
**Goal:** Compare two birth charts with synastry visualization and AI-generated relationship insights.

**Files created:**
- `lib/models/compatibility_result.dart` — `SynastryAspect`, `CompatibilityResult` (5 scores: overall/emotional/communication/passion/growth, synastry aspects, analysis, strengths, challenges)
- `lib/services/compatibility_service.dart` — Cross-chart aspect calculation, weighted category scoring, strength/challenge identification
- `lib/services/astro/synastry_data.dart` — Static interpretation data for cross-chart aspects
- `lib/providers/compatibility_provider.dart` — `calculateCompatibility(userChart, partnerData)`, `clearResult()`
- `lib/screens/compatibility_screen.dart` — Partner birth data input form → score meters (overall large + 4 category) + synastry wheel + cosmic analysis + strengths/challenges + synastry aspect list
- `lib/widgets/synastry_wheel_painter.dart` — Two concentric planet rings (purple for user, gold for partner) with cross-chart aspect lines
- `lib/widgets/score_meter.dart` — Animated circular arc progress with color-coded score (green/yellow/orange/red)

---

### Phase 5: AI Agent Refactor — Data-Driven Analyst
**Goal:** Transform the AI chat from generic keyword responses to a precise, data-driven analyst that references exact planetary positions and degrees.

**Files modified:**
- `lib/services/ai_chat_service.dart` — Added `updateContext(chart, profile)`. New chart-aware strategies:
  - `_chartBasedResponse()` — Lists planetary placements with exact degrees, houses, retrograde status
  - `_transitResponse()` — References natal Sun/Moon positions against current transits
  - `_aspectInterpretation()` — Detailed planet analysis with aspects, ecliptic longitude, house meaning
  - `_personalLoveResponse()` — Venus/Mars/Moon analysis with sign-specific interpretations
  - `_personalCareerResponse()` — Sun/Saturn/Jupiter/Midheaven career reading
  - `_personalDailyResponse()` — Personalized forecast referencing exact chart data
  - `_personalityResponse()` — Profile summary or quick chart overview
  - Responses reference exact degrees: "Your Sun at 15°23' Leo in the 5th house..."
- `lib/providers/chat_provider.dart` — Added `updateContext(chart, profile)` method; welcome message changes dynamically when chart becomes available
- `lib/main.dart` — Wired `ChangeNotifierProxyProvider2<BirthChartProvider, UserProfileProvider, ChatProvider>` so chart data flows into chat automatically

---

### Phase 6: Zodiac Social Feed
**Goal:** Anonymous community feed filtered by zodiac sign with reactions.

**Files created:**
- `lib/models/social_post.dart` — `PostType` enum (reading/question/insight), `SocialComment`, `SocialPost` (with mutable reactions/hasReacted)
- `lib/services/social_feed_service.dart` — Mock data generator: 40 daily posts seeded by date, with alias generation and content templates
- `lib/providers/social_feed_provider.dart` — `loadPosts()`, `filterBySign()`, `toggleReaction()`, `createPost()`
- `lib/screens/social_feed_screen.dart` — Sign filter chips + post list + FAB for composing (bottom sheet with type selector and text input)
- `lib/widgets/social_post_card.dart` — Post card with zodiac avatar, alias, sign badge, time ago, type badge, content, like/comment counts
- `lib/widgets/sign_filter_chips.dart` — Horizontal scrollable `FilterChip` row (All + 12 zodiac signs with symbols)

---

## Complete File Manifest

### Models (11 files)
| File | Description |
|------|-------------|
| `lib/models/zodiac_sign.dart` | 12 zodiac signs with metadata (symbol, dateRange, element, rulingPlanet, traits, color, icon) |
| `lib/models/chat_message.dart` | ChatMessage with text, sender enum (user/ai), timestamp |
| `lib/models/horoscope.dart` | Daily reading with love/career/health readings, lucky number/color/mood |
| `lib/models/birth_data.dart` | Birth date/time/location model with JSON serialization, UTC conversion |
| `lib/models/birth_chart.dart` | Chart model: planets map, houseCusps, ascendant, midheaven, aspects, elementBalance |
| `lib/models/planet_position.dart` | CelestialBody enum (10 planets), ZodiacPosition, PlanetPosition |
| `lib/models/aspect.dart` | AspectType enum, Aspect model with orb and type |
| `lib/models/transit_alert.dart` | TransitType enum, TransitAlert with isActive/isUpcoming |
| `lib/models/personality_profile.dart` | PlanetaryInfluence, PersonalityProfile |
| `lib/models/compatibility_result.dart` | SynastryAspect, CompatibilityResult (5 score categories) |
| `lib/models/social_post.dart` | PostType enum, SocialComment, SocialPost |

### Services (12 files)
| File | Description |
|------|-------------|
| `lib/services/ai_chat_service.dart` | Data-driven analyst AI with chart-aware responses |
| `lib/services/horoscope_service.dart` | Seeded random daily readings per sign |
| `lib/services/storage_service.dart` | SharedPreferences wrapper for birth data |
| `lib/services/personality_service.dart` | Assembles PersonalityProfile from chart + interpretation data |
| `lib/services/compatibility_service.dart` | Cross-chart synastry calculation and scoring |
| `lib/services/social_feed_service.dart` | Mock data generator for social feed |
| `lib/services/astro/astro_engine.dart` | Facade wrapping all 5 calculation modules |
| `lib/services/astro/julian_date.dart` | DateTime → Julian Date/Century, GMST, LST, obliquity |
| `lib/services/astro/planetary_positions.dart` | Simplified VSOP87/Meeus for 10 celestial bodies |
| `lib/services/astro/house_system.dart` | Equal House system (Ascendant, MC, 12 cusps) |
| `lib/services/astro/aspects.dart` | Aspect detection with standard orbs |
| `lib/services/astro/zodiac_util.dart` | Ecliptic longitude → sign + degree + minute |

### Additional Service Data (3 files)
| File | Description |
|------|-------------|
| `lib/services/astro/transit_data.dart` | Pre-computed transits 2024-2027 |
| `lib/services/astro/interpretation_data.dart` | 72+ planet-sign and planet-house interpretations |
| `lib/services/astro/synastry_data.dart` | Cross-chart aspect interpretation data |

### Providers (8 files)
| File | Description |
|------|-------------|
| `lib/providers/auth_provider.dart` | Firebase Auth state, sign up/in/out, Google Sign-In |
| `lib/providers/chat_provider.dart` | Chat messages, typing state, chart context injection |
| `lib/providers/horoscope_provider.dart` | Daily horoscope cache per sign |
| `lib/providers/birth_chart_provider.dart` | Birth data, chart calculation, persistence |
| `lib/providers/sky_map_provider.dart` | Timer-based real-time position tracking |
| `lib/providers/user_profile_provider.dart` | Personality profile generation |
| `lib/providers/compatibility_provider.dart` | Partner chart comparison |
| `lib/providers/social_feed_provider.dart` | Post loading, filtering, reactions, creation |

### Screens (10 files)
| File | Description |
|------|-------------|
| `lib/screens/main_shell.dart` | Bottom nav shell with 5 tabs, auth gate |
| `lib/screens/sign_up_screen.dart` | Email/password + Google Sign-In auth screen |
| `lib/screens/home_screen.dart` | Zodiac grid with 3-column layout |
| `lib/screens/horoscope_screen.dart` | Detail view per zodiac sign |
| `lib/screens/chat_screen.dart` | Chat UI with typing indicator |
| `lib/screens/birth_chart_screen.dart` | Birth data input + chart visualization |
| `lib/screens/sky_map_screen.dart` | Animated sky wheel + transit alerts |
| `lib/screens/profile_screen.dart` | Personality profile with element balance + auth prompt |
| `lib/screens/compatibility_screen.dart` | Partner input + scores + synastry wheel |
| `lib/screens/social_feed_screen.dart` | Sign filter + post feed + compose |

### Widgets (14 files)
| File | Description |
|------|-------------|
| `lib/widgets/zodiac_card.dart` | Gradient card with zodiac symbol/name/dateRange |
| `lib/widgets/chat_bubble.dart` | User (right, purple) and AI (left, dark) bubbles |
| `lib/widgets/chart_wheel.dart` | StatelessWidget wrapping CustomPaint |
| `lib/widgets/chart_wheel_painter.dart` | Natal chart wheel CustomPainter |
| `lib/widgets/planet_placement_card.dart` | Planet glyph + sign + degree + house card |
| `lib/widgets/aspect_list_tile.dart` | Color-coded aspect display |
| `lib/widgets/location_picker.dart` | 100+ cities, custom coordinates, GPS current location |
| `lib/widgets/sky_wheel_painter.dart` | Animated sky wheel with natal overlay |
| `lib/widgets/transit_alert_card.dart` | Transit event card |
| `lib/widgets/synastry_wheel_painter.dart` | Two-ring synastry wheel |
| `lib/widgets/score_meter.dart` | Animated circular arc progress |
| `lib/widgets/social_post_card.dart` | Social post with reactions |
| `lib/widgets/sign_filter_chips.dart` | Zodiac sign filter chips |
| `lib/widgets/transit_alert_card.dart` | Transit alert compact card |

### Config / Other
| File | Description |
|------|-------------|
| `lib/main.dart` | Entry point, 8 providers (incl. ProxyProvider2), Firebase init, MainShell |
| `lib/firebase_options.dart` | Firebase configuration per platform |
| `lib/theme/app_theme.dart` | Dark cosmic theme, Poppins, color palette |
| `pubspec.yaml` | Dependencies: provider, google_fonts, intl, shared_preferences, geolocator, geocoding, firebase_core, firebase_auth, cloud_firestore, google_sign_in |
| `macos/Runner/DebugProfile.entitlements` | macOS sandbox + network permissions |
| `macos/Runner/Release.entitlements` | macOS sandbox + network permissions |

---

## File Count Summary

| Category | Files |
|----------|-------|
| Models | 11 |
| Services | 15 |
| Providers | 8 |
| Screens | 10 |
| Widgets | 14 |
| Config/Theme | 6 |
| **Total** | **64** |

---

## Dependencies

```yaml
dependencies:
  flutter: sdk
  cupertino_icons: ^1.0.8
  provider: ^6.1.2            # State management
  google_fonts: ^6.2.1        # Poppins typography
  intl: ^0.20.2               # Date/time formatting
  shared_preferences: ^2.3.0  # Birth data persistence
  geolocator: ^13.0.1         # GPS current location
  geocoding: ^3.0.0           # Reverse geocoding (coords → city name)
  google_sign_in: ^6.2.1      # Google Sign-In
  firebase_core: ^3.11.0      # Firebase platform init
  firebase_auth: ^5.5.0       # Email/password + Google auth
  cloud_firestore: ^5.6.3     # Cloud Firestore (future data sync)
```

---

## Theme Palette

| Token | Color | Usage |
|-------|-------|-------|
| `primaryDark` | `#0D0D2B` | Scaffold background |
| `surfaceDark` | `#1A1A3E` | Bottom nav, input fields |
| `cardDark` | `#252552` | Cards, list items |
| `accentPurple` | `#7C4DFF` | Primary accent, buttons, badges |
| `accentGold` | `#FFD54F` | Secondary accent, planet glyphs, nav selection |
| `textPrimary` | `#E8E8F0` | Headings, body text |
| `textSecondary` | `#A0A0C0` | Captions, hints, secondary info |

Element colors used in chart wheels:
- Fire: `#EF5350` (red)
- Earth: `#66BB6A` (green)
- Air: `#FFEE58` (yellow)
- Water: `#42A5F5` (blue)

---

## Astronomical Calculations

The app uses a pure Dart astronomical engine with no external packages:

1. **Julian Date** — Converts DateTime to Julian Date and Julian Century for astronomical formulas
2. **Planetary Positions** — Simplified VSOP87/Meeus formulas for Sun, Moon, Mercury, Venus, Mars, Jupiter, Saturn, Uranus, Neptune, Pluto (~1-2 degree accuracy)
3. **House System** — Equal House system (each house = 30 degrees from Ascendant)
4. **Zodiac Util** — Converts ecliptic longitude to zodiac sign + degree + minute
5. **Aspects** — Detects conjunction (0°), sextile (60°), square (90°), trine (120°), opposition (180°) with standard orbs

---

## Verification Results

- `flutter analyze` — 0 issues
- `flutter build macos --debug` — successful
- `flutter run -d macos` — launched and running
