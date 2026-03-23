import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../mixins/cosmic_breathing_mixin.dart';
import '../providers/birth_chart_provider.dart';
import '../theme/app_theme.dart';

/// A card that displays a daily astrology tip with a breathing pulse animation.
///
/// THIS WIDGET DEMONSTRATES TWO CONCEPTS:
///
///   1. MIXIN — CosmicBreathingMixin injects pulse animation behavior
///   2. didChangeDependencies — reads the user's sign from the Provider
///      (an InheritedWidget), and automatically re-runs whenever the
///      provider's data changes
class DailyTipCard extends StatefulWidget {
  const DailyTipCard({super.key});

  @override
  State<DailyTipCard> createState() => _DailyTipCardState();
}

// ╔═══════════════════════════════════════════════════════════════════╗
// ║  TWO CONCEPTS IN ONE CLASS:                                      ║
// ║                                                                   ║
// ║  1. MIXIN (CosmicBreathingMixin) → provides pulse animation       ║
// ║  2. didChangeDependencies        → reads Provider data safely     ║
// ╚═══════════════════════════════════════════════════════════════════╝
class _DailyTipCardState extends State<DailyTipCard>
    with SingleTickerProviderStateMixin, CosmicBreathingMixin {

  // Local state — this gets populated by didChangeDependencies,
  // NOT by initState (because context isn't safe to use in initState).
  String? _userSign;

  // ─────────────────────────────────────────────────────────────────
  // LIFECYCLE METHOD #1: initState
  //
  // Called ONCE when the widget is first inserted into the tree.
  // At this point, `context` exists but InheritedWidgets (like
  // Provider) are NOT yet wired up. That's why we can set up the
  // animation here (no context needed), but we CANNOT read the
  // Provider here.
  //
  // If you tried `context.watch<BirthChartProvider>()` here,
  // it would either throw or give stale data.
  // ─────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    initBreathing(period: const Duration(seconds: 4)); // mixin — no context needed
    debugPrint('[DailyTipCard] initState called (animation started)');
  }

  // ─────────────────────────────────────────────────────────────────
  // LIFECYCLE METHOD #2: didChangeDependencies  ← THE STAR OF THE SHOW
  //
  // Called in TWO situations:
  //
  //   A) Immediately AFTER initState(), on first build.
  //      This is your earliest safe moment to use context to read
  //      InheritedWidgets (Provider, Theme, MediaQuery, etc.)
  //
  //   B) Every time an InheritedWidget this widget depends on changes.
  //      Because we call `context.read<BirthChartProvider>()` below,
  //      Flutter knows we depend on BirthChartProvider. Whenever
  //      BirthChartProvider calls notifyListeners() (e.g., after the
  //      user generates a birth chart), this method fires again.
  //
  // REAL-WORLD SCENARIO:
  //   1. App launches → no birth chart yet → _userSign = null
  //      → card shows "Daily Cosmic Tip" with a generic tip
  //   2. User goes to Birth Chart screen, enters their birth data
  //   3. BirthChartProvider.calculateChart() runs → notifyListeners()
  //   4. didChangeDependencies fires HERE → _userSign = "Scorpio"
  //      → card now shows "Daily Tip for Scorpio" with a personal tip
  //
  // WHY NOT JUST USE build()?
  //   You could read the provider in build() too. But didChangeDependencies
  //   is for when you need to do WORK in response to a dependency change
  //   (start an animation, load data, compute something expensive) —
  //   not just return a widget tree. It separates "react to change" from
  //   "render UI".
  // ─────────────────────────────────────────────────────────────────
  @override
  void didChangeDependencies() {
    super.didChangeDependencies(); // always call super first

    // Read the provider — this creates the "dependency" link.
    // Flutter now tracks that this widget depends on BirthChartProvider.
    final chartProvider = context.watch<BirthChartProvider>();

    // Extract the user's sun sign (or null if no chart exists yet)
    final newSign = chartProvider.hasChart
        ? chartProvider.chart!.sunSign.sign
        : null;

    // Only update state if the sign actually changed
    // (avoids unnecessary rebuilds)
    if (newSign != _userSign) {
      debugPrint(
        '[DailyTipCard] didChangeDependencies: sign changed from '
        '"$_userSign" → "$newSign"',
      );
      setState(() {
        _userSign = newSign;
      });
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // LIFECYCLE METHOD #3: dispose
  // ─────────────────────────────────────────────────────────────────
  @override
  void dispose() {
    disposeBreathing(); // mixin cleanup
    debugPrint('[DailyTipCard] dispose called (animation stopped)');
    super.dispose();
  }

  /// Pick a tip based on the day of the year so it changes daily.
  String get _todayTip {
    final signTips = <String, List<String>>{
      'Aries': [
        'Mars fuels your courage today. Take that bold step.',
        'Your fire burns bright — channel it into a creative project.',
      ],
      'Taurus': [
        'Venus blesses your senses. Savor something beautiful today.',
        'Slow and steady wins today. Trust your natural rhythm.',
      ],
      'Gemini': [
        'Mercury sharpens your wit. Your words carry extra power.',
        'Curiosity leads to a breakthrough. Follow the questions.',
      ],
      'Cancer': [
        'The Moon wraps you in intuition. Trust your gut feeling.',
        'Your nurturing energy is magnetic today. Share it freely.',
      ],
      'Leo': [
        'The Sun spotlights you today. Step into your full radiance.',
        'Generosity returns to you tenfold. Lead with your heart.',
      ],
      'Virgo': [
        'Mercury rewards your precision. Details matter today.',
        'Your analytical mind sees what others miss. Speak up.',
      ],
      'Libra': [
        'Venus harmonizes your relationships. Seek balance in all things.',
        'Beauty inspires you today. Surround yourself with art.',
      ],
      'Scorpio': [
        'Pluto deepens your insight. Hidden truths surface now.',
        'Your intensity is a gift today. Focus it like a laser.',
      ],
      'Sagittarius': [
        'Jupiter expands your horizons. Say yes to adventure.',
        'Optimism is your superpower today. Share it generously.',
      ],
      'Capricorn': [
        'Saturn rewards your discipline. Stay the course.',
        'Ambition meets opportunity today. Build something lasting.',
      ],
      'Aquarius': [
        'Uranus sparks innovation. Your unconventional idea is the right one.',
        'Community matters today. Connect with your people.',
      ],
      'Pisces': [
        'Neptune amplifies your intuition. Dreams hold answers tonight.',
        'Your compassion is healing others. Don\'t forget to heal yourself.',
      ],
    };

    final genericTips = [
      'The stars align for introspection. Journal your thoughts tonight.',
      'A planetary shift encourages new beginnings. What will you start?',
      'Cosmic energy favors communication today. Reach out to someone.',
      'The celestial tides are turning. Embrace the change ahead.',
      'Stardust settles on creative pursuits. Make something today.',
      'The universe rewards patience. What you planted is about to bloom.',
      'Celestial harmonics favor collaboration. Two minds beat one.',
    ];

    final dayOfYear = DateTime.now().difference(
      DateTime(DateTime.now().year, 1, 1),
    ).inDays;

    // If we know the user's sign, pick a sign-specific tip
    if (_userSign != null && signTips.containsKey(_userSign)) {
      final tips = signTips[_userSign]!;
      return tips[dayOfYear % tips.length];
    }

    // Otherwise, pick a generic tip
    return genericTips[dayOfYear % genericTips.length];
  }

  @override
  Widget build(BuildContext context) {
    // AnimatedBuilder listens to breathAnimation (from the mixin)
    // and rebuilds ONLY this subtree on each animation tick.
    return AnimatedBuilder(
      animation: breathAnimation, // ← from CosmicBreathingMixin
      builder: (context, child) {
        return Transform.scale(
          scale: breathScale, // ← from CosmicBreathingMixin (0.97 ↔ 1.03)
          child: child,
        );
      },
      // The child is built ONCE and reused on every animation frame.
      // Only the Transform.scale wrapper rebuilds — efficient!
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF1A1040),
              Color(0xFF2A1B5E),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.accentGold.withAlpha(50),
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accentPurple.withAlpha(20),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Glowing star icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppTheme.accentGold.withAlpha(60),
                    AppTheme.accentPurple.withAlpha(40),
                  ],
                ),
              ),
              child: const Center(
                child: Text('\u2728', style: TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _userSign != null
                        ? 'Daily Tip for $_userSign'
                        : 'Daily Cosmic Tip',
                    style: const TextStyle(
                      color: AppTheme.accentGold,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _todayTip,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
