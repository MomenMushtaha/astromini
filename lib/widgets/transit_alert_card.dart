import 'package:flutter/material.dart';
import '../models/transit_alert.dart';
import '../theme/app_theme.dart';

class TransitAlertCard extends StatelessWidget {
  final TransitAlert alert;

  const TransitAlertCard({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(alert.type);
    final isActive = alert.isActive;

    return Container(
      width: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(isActive ? 80 : 40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(alert.planet.symbol,
                  style: TextStyle(fontSize: 18, color: color)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  alert.title,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            alert.description,
            style:
                const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isActive ? 'ACTIVE' : 'UPCOMING',
                  style: TextStyle(color: color, fontSize: 9,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const Spacer(),
              Text(
                '${alert.startDate.month}/${alert.startDate.day}',
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _typeColor(TransitType type) {
    switch (type) {
      case TransitType.retrograde:
        return const Color(0xFFEF5350);
      case TransitType.ingress:
        return const Color(0xFF66BB6A);
      case TransitType.eclipse:
        return const Color(0xFFFFEE58);
      case TransitType.conjunction:
        return AppTheme.accentPurple;
      case TransitType.aspect:
        return const Color(0xFF42A5F5);
    }
  }
}
