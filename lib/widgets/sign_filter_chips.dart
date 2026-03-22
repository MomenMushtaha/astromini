import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/astro/zodiac_util.dart';

class SignFilterChips extends StatelessWidget {
  final String? selectedSign;
  final void Function(String? sign) onSignSelected;

  const SignFilterChips({
    super.key,
    required this.selectedSign,
    required this.onSignSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: FilterChip(
              label: const Text('All'),
              selected: selectedSign == null,
              selectedColor: AppTheme.accentPurple.withAlpha(60),
              backgroundColor: AppTheme.cardDark,
              labelStyle: TextStyle(
                color: selectedSign == null
                    ? AppTheme.accentPurple
                    : AppTheme.textSecondary,
                fontSize: 12,
              ),
              side: BorderSide(
                color: selectedSign == null
                    ? AppTheme.accentPurple.withAlpha(80)
                    : Colors.transparent,
              ),
              onSelected: (_) => onSignSelected(null),
            ),
          ),
          ...List.generate(12, (i) {
            final sign = ZodiacUtil.signNames[i];
            final isSelected = selectedSign == sign;
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: FilterChip(
                label: Text('${ZodiacUtil.signSymbols[i]} $sign'),
                selected: isSelected,
                selectedColor: AppTheme.accentPurple.withAlpha(60),
                backgroundColor: AppTheme.cardDark,
                labelStyle: TextStyle(
                  color: isSelected
                      ? AppTheme.accentPurple
                      : AppTheme.textSecondary,
                  fontSize: 12,
                ),
                side: BorderSide(
                  color: isSelected
                      ? AppTheme.accentPurple.withAlpha(80)
                      : Colors.transparent,
                ),
                onSelected: (_) =>
                    onSignSelected(isSelected ? null : sign),
              ),
            );
          }),
        ],
      ),
    );
  }
}
