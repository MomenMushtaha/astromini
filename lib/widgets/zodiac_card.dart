import 'package:flutter/material.dart';
import '../models/zodiac_sign.dart';
import '../theme/app_theme.dart';

class ZodiacCard extends StatelessWidget {
  final ZodiacSign sign;
  final VoidCallback onTap;

  const ZodiacCard({super.key, required this.sign, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              sign.color.withAlpha(60),
              AppTheme.cardDark,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: sign.color.withAlpha(80),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              sign.symbol,
              style: const TextStyle(fontSize: 36),
            ),
            const SizedBox(height: 8),
            Text(
              sign.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              sign.dateRange,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                    fontSize: 10,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
