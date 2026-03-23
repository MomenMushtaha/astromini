# astromini — Design Patterns

A comprehensive catalog of every design pattern used in the astromini codebase, with file locations and code evidence.

---

## Architectural Pattern

### 1. MVVM (Model-View-ViewModel)

The core architectural pattern across the entire app.

| Layer | Role | Files |
|-------|------|-------|
| **Model** | Pure data containers | `lib/models/*.dart` |
| **ViewModel** | State + business logic | `lib/providers/*.dart` |
| **View** | UI rendering | `lib/screens/*.dart`, `lib/widgets/*.dart` |

**How it works:** Models hold data (e.g. `BirthChart`, `PersonalityProfile`). Providers act as ViewModels — they own state, call services, and notify the UI. Screens bind to providers via `Consumer<T>` and `context.read/watch`.

```dart
// ViewModel (lib/providers/birth_chart_provider.dart)
class BirthChartProvider extends ChangeNotifier {
  BirthChart? _chart;
  bool _isCalculating = false;

  Future<void> calculateChart(BirthData data) async {
    _isCalculating = true;
    notifyListeners();
    _chart = AstroEngine.calculateChart(data);
    _isCalculating = false;
    notifyListeners();
  }
}

// View (lib/screens/birth_chart_screen.dart)
Consumer<BirthChartProvider>(
  builder: (ctx, provider, _) {
    if (provider.isCalculating) return CircularProgressIndicator();
    if (provider.hasChart) return _buildChartView(provider);
    return _buildInputForm();
  },
)
```

**Justification:** Separates UI from logic. Providers can be tested independently. Screens stay declarative.

---

## Structural Patterns

### 2. Facade

**Location:** `lib/services/astro/astro_engine.dart`

Hides the complexity of 5 astronomical calculation modules behind two simple static methods.

```dart
class AstroEngine {
  AstroEngine._();

  static BirthChart calculateChart(BirthData birthData) {
    // Internally orchestrates:
    final jd = JulianDate.fromDateTime(utc);        // Module 1
    final t = JulianDate.toJulianCentury(jd);        // Module 2
    final asc = HouseSystem.ascendant(lst, lat, obl); // Module 3
    final raw = PlanetaryPositions.allPositions(t);   // Module 4
    final aspects = AspectCalculator.calculateAspects(planets); // Module 5
    // ... 17 steps total
    return BirthChart(...);
  }

  static Map<CelestialBody, PlanetPosition> currentPositions() {
    // Same modules, different output
  }
}

// Client code — one line:
_chart = AstroEngine.calculateChart(data);
```

**Justification:** Clients (providers, screens) don't need to know about Julian dates, VSOP87 formulas, house systems, or aspect orbs. One method does everything.

---

### 3. Composite

**Location:** All widgets and screens

Flutter's widget tree is fundamentally Composite — complex UIs are built from small, reusable widget components.

```dart
// lib/screens/birth_chart_screen.dart — composes from:
ChartWheel(chart: chart, size: 300),           // lib/widgets/chart_wheel.dart
PlanetPlacementCard(position: p),               // lib/widgets/planet_placement_card.dart
AspectListTile(aspect: a),                      // lib/widgets/aspect_list_tile.dart

// lib/screens/compatibility_screen.dart — composes from:
ScoreMeter(label: 'Overall', score: result.overallScore),  // lib/widgets/score_meter.dart
SynastryWheelPainter(chart1: c1, chart2: c2),              // lib/widgets/synastry_wheel_painter.dart

// lib/screens/social_feed_screen.dart — composes from:
SignFilterChips(selectedSign: sign, onSignSelected: fn),    // lib/widgets/sign_filter_chips.dart
SocialPostCard(post: post, onReact: fn),                    // lib/widgets/social_post_card.dart
```

**Justification:** Each widget handles one responsibility. Screens compose them into complex layouts. Widgets are reusable across screens.

---

### 4. Proxy (Proxy Provider)

**Location:** `lib/main.dart`

`ChangeNotifierProxyProvider2` acts as a proxy that mediates between `ChatProvider` and its dependencies, injecting chart/profile context automatically.

```dart
ChangeNotifierProxyProvider2<BirthChartProvider, UserProfileProvider, ChatProvider>(
  create: (_) => ChatProvider(),
  update: (_, chartProv, profileProv, chatProv) {
    chatProv!.updateContext(chartProv.chart, profileProv.profile);
    return chatProv;
  },
),
```

**Justification:** ChatProvider doesn't directly depend on BirthChartProvider or UserProfileProvider. The proxy handles injection, so when a chart is generated, the AI chat automatically becomes personalized without tight coupling.

---

### 5. Decorator

**Location:** `lib/theme/app_theme.dart`, all widgets

Widgets are decorated with visual styling (gradients, borders, shapes) without modifying their core functionality.

```dart
// lib/widgets/zodiac_card.dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(colors: [sign.color.withAlpha(60), sign.color.withAlpha(20)]),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: sign.color.withAlpha(80)),
  ),
  child: Column(/* pure content */),
)

// lib/theme/app_theme.dart — decorates the entire app
ThemeData(
  textTheme: GoogleFonts.poppinsTextTheme(...),  // Decorates typography
  cardTheme: CardThemeData(shape: RoundedRectangleBorder(...)),
  inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: cardDark),
)
```

**Justification:** Separates visual presentation from content structure. Theme changes propagate app-wide without touching individual widgets.

---

### 6. Data Transfer Object (DTO) / Value Object

**Location:** All model classes in `lib/models/`

Models are immutable data containers with `const` constructors — they carry data between layers without containing business logic.

```dart
// lib/models/birth_chart.dart
class BirthChart {
  final Map<CelestialBody, PlanetPosition> planets;
  final List<double> houseCusps;
  final double ascendant;
  final double midheaven;
  final List<Aspect> aspects;

  const BirthChart({required this.birthData, required this.planets, ...});

  // Only computed properties, no side effects
  ZodiacPosition get sunSign => planets[CelestialBody.sun]!.zodiacPosition;
  Map<String, int> get elementBalance { ... }
}

// lib/models/planet_position.dart
class ZodiacPosition {
  final String sign;
  final int degree;
  final int minute;

  const ZodiacPosition({required this.sign, required this.degree, required this.minute});

  String get formatted => '$degree\u00B0$minute\' $sign';
}
```

**Justification:** Immutable models prevent accidental state corruption. Data flows in one direction: services create models, providers hold them, views display them.

---

## Behavioral Patterns

### 7. Observer (Provider + ChangeNotifier)

**Location:** All 7 providers in `lib/providers/`

Every provider extends `ChangeNotifier` and calls `notifyListeners()` to trigger widget rebuilds — the classic Observer/Pub-Sub pattern.

```dart
// lib/providers/social_feed_provider.dart
class SocialFeedProvider extends ChangeNotifier {
  void toggleReaction(String postId) {
    final post = _allPosts.firstWhere((p) => p.id == postId);
    post.hasReacted = !post.hasReacted;
    post.reactions += post.hasReacted ? 1 : -1;
    notifyListeners();  // All subscribed widgets rebuild
  }
}

// lib/main.dart — registration
MultiProvider(providers: [
  ChangeNotifierProvider(create: (_) => HoroscopeProvider()),
  ChangeNotifierProvider(create: (_) => BirthChartProvider(storageService)),
  ChangeNotifierProvider(create: (_) => SkyMapProvider()),
  ChangeNotifierProvider(create: (_) => UserProfileProvider()),
  ChangeNotifierProvider(create: (_) => CompatibilityProvider()),
  ChangeNotifierProvider(create: (_) => SocialFeedProvider()),
  ChangeNotifierProxyProvider2<...>(create: (_) => ChatProvider(), ...),
])
```

| Provider | Observers (Screens) |
|----------|-------------------|
| `BirthChartProvider` | `BirthChartScreen`, `CompatibilityScreen` |
| `SkyMapProvider` | `SkyMapScreen` |
| `UserProfileProvider` | `ProfileScreen` |
| `CompatibilityProvider` | `CompatibilityScreen` |
| `SocialFeedProvider` | `SocialFeedScreen` |
| `ChatProvider` | `ChatScreen` |
| `HoroscopeProvider` | `HoroscopeScreen` |

**Justification:** Reactive UI — when data changes, only affected widgets rebuild. No manual UI refresh needed.

---

### 8. Strategy

**Location:** `lib/services/ai_chat_service.dart`

Different response generation strategies are selected at runtime based on user query keywords. The AI adapts its behavior based on whether a birth chart is available.

```dart
Future<String> generateResponse(String userMessage) async {
  final lower = userMessage.toLowerCase();

  // Chart-aware strategies (only when chart exists)
  if (_chart != null) {
    if (_matchesAny(lower, ['chart', 'planet', 'house'])) return _chartBasedResponse(lower);
    if (_matchesAny(lower, ['transit', 'current', 'sky']))  return _transitResponse();
    if (_matchesAny(lower, ['sun', 'moon', 'venus']))       return _aspectInterpretation(lower);
  }

  // Topic strategies (always available)
  if (_matchesAny(lower, ['love', 'relationship'])) {
    return _chart != null ? _personalLoveResponse() : _loveResponse();
  }
  if (_matchesAny(lower, ['career', 'job', 'work'])) {
    return _chart != null ? _personalCareerResponse() : _careerResponse();
  }
  if (_matchesAny(lower, ['compatible', 'compatibility'])) return _compatibilityResponse(lower);
  if (_matchesAny(lower, ['health', 'wellness']))          return _healthResponse();
  if (_matchesAny(lower, ['today', 'daily', 'horoscope'])) {
    return _chart != null ? _personalDailyResponse() : _dailyResponse();
  }
  if (_matchesAny(lower, ['personality', 'profile']))      return _personalityResponse();

  return _generalResponse();
}
```

**Strategies:**

| Strategy | Trigger Keywords | Chart Required |
|----------|-----------------|----------------|
| `_chartBasedResponse` | chart, planet, house, aspect | Yes |
| `_transitResponse` | transit, current, sky, retrograde | Yes |
| `_aspectInterpretation` | sun, moon, venus, mars, etc. | Yes |
| `_personalLoveResponse` | love, relationship, partner | Yes |
| `_personalCareerResponse` | career, job, work, money | Yes |
| `_personalDailyResponse` | today, daily, horoscope | Yes |
| `_personalityResponse` | personality, profile, who am i | Yes |
| `_loveResponse` | love, relationship, partner | No |
| `_careerResponse` | career, job, work | No |
| `_compatibilityResponse` | compatible, compatibility | No |
| `_healthResponse` | health, wellness, energy | No |
| `_dailyResponse` | today, daily, horoscope | No |
| `_signResponse` | any zodiac sign name | No |
| `_generalResponse` | fallback | No |

**Justification:** New response strategies can be added without modifying existing ones (Open/Closed Principle). Chart-aware responses coexist alongside generic ones.

---

### 9. Template Method

**Location:** `lib/services/astro/astro_engine.dart`, `lib/widgets/*_painter.dart`

#### AstroEngine — Fixed calculation algorithm

`calculateChart()` follows a fixed 17-step sequence that cannot be reordered:

```
Step 1:  Convert birth datetime to UTC
Step 2:  Calculate Julian Date
Step 3:  Calculate Julian Century
Step 4:  Calculate obliquity of ecliptic
Step 5:  Calculate Ascendant
Step 6:  Calculate Midheaven
Step 7:  Calculate 12 house cusps
Step 8:  Calculate all planetary positions for birth time
Step 9:  Calculate positions for next day (for retrograde detection)
Step 10: Build PlanetPosition objects with zodiac positions
Step 11: Determine retrograde status for each planet
Step 12: Assign planets to houses
Step 13: Calculate aspects between all planet pairs
Step 14: Assemble BirthChart object
```

#### CustomPainter subclasses — Shared rendering template

All three chart painters follow the same structure:

```
ChartWheelPainter:     draw outer ring → draw house lines → draw aspect lines → draw planets
SkyWheelPainter:       draw outer ring → draw natal overlay → draw current planets → draw ticks
SynastryWheelPainter:  draw outer ring → draw chart 1 planets → draw chart 2 planets → draw cross-aspects
```

**Justification:** The algorithm steps are interdependent — you can't calculate houses before Julian dates. The template guarantees correctness.

---

### 10. State

**Location:** All providers manage state transitions

Providers maintain explicit state flags that drive UI rendering:

```dart
// lib/providers/birth_chart_provider.dart
class BirthChartProvider extends ChangeNotifier {
  bool _isCalculating = false;  // States: IDLE, CALCULATING
  BirthChart? _chart;           // States: null (no chart), non-null (has chart)

  // State transitions:
  // IDLE → calculateChart() → CALCULATING → calculation done → HAS_CHART
  // HAS_CHART → clearChart() → IDLE
}

// lib/screens/birth_chart_screen.dart — renders based on state
Consumer<BirthChartProvider>(
  builder: (ctx, provider, _) {
    if (provider.isCalculating) return _loadingView();    // State: CALCULATING
    if (provider.hasChart)      return _buildChartView();  // State: HAS_CHART
    return _buildInputForm();                              // State: IDLE
  },
)
```

| Provider | States | Transitions |
|----------|--------|-------------|
| `BirthChartProvider` | idle, calculating, hasChart | calculate → clear |
| `CompatibilityProvider` | idle, calculating, hasResult | calculate → clear |
| `UserProfileProvider` | idle, generating, hasProfile | generate → clear |
| `SkyMapProvider` | empty, tracking | startTracking → stopTracking |
| `SocialFeedProvider` | loading, loaded + filtering | load → filter → toggle |
| `ChatProvider` | idle, typing | send → response received |
| `HoroscopeProvider` | idle, loading, cached | fetch → cache hit |

**Justification:** Explicit state flags eliminate ambiguity. The UI always knows exactly what to render.

---

## Creational Patterns

### 11. Factory

**Location:** `lib/models/birth_data.dart`, `lib/services/astro/aspects.dart`

Factory methods encapsulate object creation from raw data:

```dart
// lib/models/birth_data.dart — named factory constructor
factory BirthData.fromJson(Map<String, dynamic> json) => BirthData(
  name: json['name'] as String?,
  birthDate: DateTime.parse(json['birthDate'] as String),
  birthHour: json['birthHour'] as int,
  birthMinute: json['birthMinute'] as int,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  locationName: json['locationName'] as String,
  utcOffset: (json['utcOffset'] as num).toDouble(),
);

// lib/services/astro/aspects.dart — factory method creating Aspect instances
static List<Aspect> calculateAspects(Map<CelestialBody, PlanetPosition> planets) {
  final aspects = <Aspect>[];
  // ... iterates all planet pairs, creates Aspect when angles match
  aspects.add(Aspect(planet1: bodies[i], planet2: bodies[j], type: type, ...));
  return aspects;
}
```

**Justification:** Encapsulates creation logic. `fromJson` handles type casting and parsing. `calculateAspects` encapsulates the combinatorial logic of checking all planet pairs.

---

### 12. Singleton (via DI and Static Classes)

**Location:** Services and storage

Services are either instantiated once via dependency injection or implemented as static utility classes:

```dart
// DI Singleton — lib/main.dart
final prefs = await SharedPreferences.getInstance();  // App-wide singleton
final storageService = StorageService(prefs);          // Single instance, injected

// Static Singleton — lib/services/compatibility_service.dart
class CompatibilityService {
  CompatibilityService._();  // Private constructor prevents instantiation
  static CompatibilityResult calculate(BirthChart c1, BirthChart c2) { ... }
}

// Static Singleton — lib/services/personality_service.dart
class PersonalityService {
  PersonalityService._();  // Private constructor
  static PersonalityProfile generate(BirthChart chart) { ... }
}

// Static Singleton — lib/services/astro/astro_engine.dart
class AstroEngine {
  AstroEngine._();  // Private constructor
  static BirthChart calculateChart(BirthData data) { ... }
  static Map<CelestialBody, PlanetPosition> currentPositions() { ... }
}
```

**Justification:** Stateless services don't need multiple instances. Private constructors + static methods make the intent clear.

---

### 13. Caching

**Location:** `lib/providers/horoscope_provider.dart`

In-memory cache prevents redundant horoscope calculations:

```dart
class HoroscopeProvider extends ChangeNotifier {
  final Map<String, Horoscope> _cache = {};

  Future<Horoscope> fetchHoroscope(String signName) async {
    if (_cache.containsKey(signName)) {
      return _cache[signName]!;  // Cache hit — instant return
    }

    _isLoading = true;
    notifyListeners();

    final horoscope = _service.getHoroscope(signName);
    _cache[signName] = horoscope;  // Store for next time

    _isLoading = false;
    notifyListeners();
    return horoscope;
  }
}
```

**Justification:** Users frequently switch between zodiac signs. Caching makes repeat views instantaneous.

---

### 14. Lazy Initialization

**Location:** `lib/main.dart`, `lib/providers/sky_map_provider.dart`

Resources are created only when first needed:

```dart
// lib/main.dart — SharedPreferences loaded once at startup
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(AstroMiniApp(storageService: StorageService(prefs)));
}

// lib/providers/sky_map_provider.dart — tracking starts only when screen is viewed
void startTracking() {
  _refresh();
  _refreshTimer = Timer.periodic(const Duration(seconds: 60), (_) => _refresh());
}
```

**Justification:** Don't calculate planetary positions until the user opens the Sky Map tab. Don't load SharedPreferences until app start.

---

## Summary

| # | Pattern | Type | Primary Location | Complexity |
|---|---------|------|-----------------|------------|
| 1 | **MVVM** | Architectural | Models / Providers / Screens | High |
| 2 | **Facade** | Structural | `astro_engine.dart` | Medium |
| 3 | **Composite** | Structural | All widgets and screens | High |
| 4 | **Proxy** | Structural | `main.dart` (ProxyProvider2) | Medium |
| 5 | **Decorator** | Structural | Theme, widget styling | Low |
| 6 | **DTO / Value Object** | Structural | All `lib/models/` | Low |
| 7 | **Observer** | Behavioral | All `lib/providers/` (ChangeNotifier) | High |
| 8 | **Strategy** | Behavioral | `ai_chat_service.dart` | Medium |
| 9 | **Template Method** | Behavioral | `astro_engine.dart`, `*_painter.dart` | Medium |
| 10 | **State** | Behavioral | All providers (state flags) | Medium |
| 11 | **Factory** | Creational | `birth_data.dart`, `aspects.dart` | Low |
| 12 | **Singleton** | Creational | Services (static + DI) | Low |
| 13 | **Caching** | Creational | `horoscope_provider.dart` | Low |
| 14 | **Lazy Initialization** | Creational | `main.dart`, `sky_map_provider.dart` | Low |

| 15 | **Stream-Based Auth** | Behavioral | `auth_provider.dart` (Firebase stream) | Medium |

**Total: 15 design patterns** across 59 Dart files.

---

### 15. Stream-Based Authentication (Observer via Stream)

**Location:** `lib/providers/auth_provider.dart`

Firebase's `authStateChanges()` stream drives authentication state reactively:

```dart
class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();  // UI reacts to auth changes
    });
  }

  bool get isAuthenticated => _user != null;
}
```

Used in `MainShell` to gate access:
```dart
// lib/screens/main_shell.dart
final auth = context.watch<AuthProvider>();
if (!auth.isAuthenticated) return const SignUpScreen();
```

**Justification:** Firebase Auth provides a stream-based API. Subscribing in the constructor means any auth state change (sign in, sign out, token refresh) automatically propagates to the UI without manual polling.
