import 'package:flutter/material.dart';

/// A mixin that gives any StatefulWidget a gentle "breathing" animation —
/// a subtle scale pulse that loops forever, like a cosmic heartbeat.
///
/// HOW IT WORKS:
///   The mixin declares `on State<T>, TickerProvider` which means any class
///   using it MUST extend State AND implement TickerProvider. In practice,
///   that means you also mix in [SingleTickerProviderStateMixin].
///
/// USAGE:
///   class _MyWidgetState extends State\<MyWidget\>
///       with SingleTickerProviderStateMixin,  // provides TickerProvider
///            CosmicBreathingMixin {           // injects the animation
///
///     @override
///     void initState() {
///       super.initState();
///       initBreathing();        // one call — mixin sets up everything
///     }
///
///     @override
///     void dispose() {
///       disposeBreathing();     // one call — mixin cleans up
///       super.dispose();
///     }
///
///     @override
///     Widget build(BuildContext context) {
///       return AnimatedBuilder(
///         animation: breathAnimation,   // from the mixin
///         builder: (context, child) {
///           return Transform.scale(
///             scale: breathScale,        // from the mixin (0.97 → 1.03)
///             child: child,
///           );
///         },
///         child: Text('I am breathing!'),
///       );
///     }
///   }
///
/// WITHOUT THIS MIXIN, every widget that wants a pulse would need to:
///   1. Mix in SingleTickerProviderStateMixin
///   2. Declare a late AnimationController
///   3. Declare a late Animation\<double\>
///   4. In initState: create the controller, create a Tween, wrap in CurvedAnimation, call repeat()
///   5. In dispose: call controller.dispose()
///   6. Expose a getter for the current value
///
/// The mixin bundles steps 2-6 into two calls: initBreathing() + disposeBreathing().
mixin CosmicBreathingMixin<T extends StatefulWidget> on State<T>, TickerProvider {
  // ── Private state managed entirely by the mixin ──
  late AnimationController _breathController;
  late Animation<double> _breathAnimation;

  // ── Public API that consuming widgets use ──

  /// The current scale factor — oscillates smoothly between 0.97 and 1.03.
  double get breathScale => _breathAnimation.value;

  /// The raw Animation object — pass this to AnimatedBuilder so Flutter
  /// only rebuilds the animated subtree (not the entire widget).
  Animation<double> get breathAnimation => _breathAnimation;

  /// Call this in initState() to start the breathing loop.
  /// [period] controls how fast the breath cycles (default: 3 seconds).
  void initBreathing({Duration period = const Duration(seconds: 3)}) {
    _breathController = AnimationController(
      vsync: this, // `this` works because the class is a TickerProvider
      duration: period,
    );

    _breathAnimation = Tween<double>(
      begin: 0.97, // slightly smaller
      end: 1.03,   // slightly larger
    ).animate(
      CurvedAnimation(
        parent: _breathController,
        curve: Curves.easeInOut, // smooth in-and-out
      ),
    );

    _breathController.repeat(reverse: true); // loop forever: grow → shrink → grow
  }

  /// Call this in dispose() to clean up the animation resources.
  void disposeBreathing() {
    _breathController.dispose();
  }
}
