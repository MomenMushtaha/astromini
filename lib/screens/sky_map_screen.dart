import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sky_map_provider.dart';
import '../providers/birth_chart_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/sky_wheel_painter.dart';
import '../widgets/transit_alert_card.dart';

class SkyMapScreen extends StatefulWidget {
  const SkyMapScreen({super.key});

  @override
  State<SkyMapScreen> createState() => _SkyMapScreenState();
}

class _SkyMapScreenState extends State<SkyMapScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 120),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SkyMapProvider>().startTracking();
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Sky Map')),
      body: Consumer<SkyMapProvider>(
        builder: (ctx, provider, _) {
          if (provider.currentPositions.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: AppTheme.accentPurple),
                  SizedBox(height: 16),
                  Text('Loading planetary positions...',
                      style: TextStyle(color: AppTheme.textSecondary)),
                ],
              ),
            );
          }

          final activeAlerts =
              provider.alerts.where((a) => a.isActive).toList();
          final upcomingAlerts =
              provider.alerts.where((a) => a.isUpcoming).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Current Planetary Positions',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 12),

                // Animated sky wheel
                AnimatedBuilder(
                  animation: _rotationController,
                  builder: (ctx, _) {
                    return SizedBox(
                      width: 300,
                      height: 300,
                      child: CustomPaint(
                        painter: SkyWheelPainter(
                          positions: provider.currentPositions,
                          rotation: _rotationController.value * 0.5,
                          natalChart:
                              context.read<BirthChartProvider>().chart,
                        ),
                        size: const Size(300, 300),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Planet positions list
                ...provider.currentPositions.entries.map((entry) {
                  final body = entry.key;
                  final pos = entry.value;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.cardDark,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Text(body.symbol,
                            style: TextStyle(
                              fontSize: 20,
                              color: pos.isRetrograde
                                  ? const Color(0xFFEF5350)
                                  : AppTheme.accentGold,
                            )),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(body.displayName,
                                      style: const TextStyle(
                                        color: AppTheme.textPrimary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      )),
                                  if (pos.isRetrograde) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEF5350)
                                            .withAlpha(30),
                                        borderRadius:
                                            BorderRadius.circular(4),
                                      ),
                                      child: const Text('Rx',
                                          style: TextStyle(
                                              color: Color(0xFFEF5350),
                                              fontSize: 10)),
                                    ),
                                  ],
                                ],
                              ),
                              Text(pos.zodiacPosition.formatted,
                                  style: const TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                        Text(
                          '${pos.eclipticLongitude.toStringAsFixed(1)}\u00B0',
                          style: const TextStyle(
                              color: AppTheme.textSecondary, fontSize: 11),
                        ),
                      ],
                    ),
                  );
                }),

                // Transit alerts
                if (activeAlerts.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Active Transits',
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: activeAlerts.length,
                      separatorBuilder: (c, i) => const SizedBox(width: 10),
                      itemBuilder: (ctx, i) =>
                          TransitAlertCard(alert: activeAlerts[i]),
                    ),
                  ),
                ],

                if (upcomingAlerts.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Upcoming Transits',
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: upcomingAlerts.length,
                      separatorBuilder: (c, i) => const SizedBox(width: 10),
                      itemBuilder: (ctx, i) =>
                          TransitAlertCard(alert: upcomingAlerts[i]),
                    ),
                  ),
                ],

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
