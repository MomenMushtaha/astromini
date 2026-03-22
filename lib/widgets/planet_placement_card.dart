import 'package:flutter/material.dart';
import '../models/planet_position.dart';
import '../theme/app_theme.dart';

class PlanetPlacementCard extends StatelessWidget {
  final PlanetPosition position;

  const PlanetPlacementCard({super.key, required this.position});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withAlpha(10)),
      ),
      child: Row(
        children: [
          Text(
            position.body.symbol,
            style: TextStyle(
              fontSize: 22,
              color: position.isRetrograde
                  ? const Color(0xFFEF5350)
                  : AppTheme.accentGold,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      position.body.displayName,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    if (position.isRetrograde) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF5350).withAlpha(30),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'R',
                          style:
                              TextStyle(color: Color(0xFFEF5350), fontSize: 10),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  position.zodiacPosition.formatted,
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.accentPurple.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'House ${position.house}',
              style: const TextStyle(
                color: AppTheme.accentPurple,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
