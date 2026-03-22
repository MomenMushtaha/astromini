import 'package:flutter/material.dart';
import '../models/aspect.dart';
import '../theme/app_theme.dart';

class AspectListTile extends StatelessWidget {
  final Aspect aspect;

  const AspectListTile({super.key, required this.aspect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: aspect.type.color.withAlpha(40)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: aspect.type.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            aspect.planet1.symbol,
            style: const TextStyle(fontSize: 16, color: AppTheme.textPrimary),
          ),
          const SizedBox(width: 6),
          Text(
            aspect.type.displayName,
            style: TextStyle(
              color: aspect.type.color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            aspect.planet2.symbol,
            style: const TextStyle(fontSize: 16, color: AppTheme.textPrimary),
          ),
          const Spacer(),
          Text(
            'orb ${aspect.orb.toStringAsFixed(1)}\u00B0',
            style:
                const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
