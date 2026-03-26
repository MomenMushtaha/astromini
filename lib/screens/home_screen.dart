import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/zodiac_sign.dart';
import '../providers/birth_chart_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/daily_tip_card.dart';
import '../widgets/zodiac_card.dart';
import 'horoscope_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final sign = ZodiacSign.all[index];
                    // THIS IS THE CHILD TO PARENT CALLBACK IMPLEMENTATION
                    return ZodiacCard(
                      sign: sign,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HoroscopeScreen(sign: sign),
                        ),
                      ),
                    );
                  },
                  childCount: ZodiacSign.all.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final chartProvider = context.watch<BirthChartProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('\u2728', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 10),
              Text(
                'AstrominiAI',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: [AppTheme.accentPurple, AppTheme.accentGold],
                        ).createShader(const Rect.fromLTWH(0, 0, 200, 40)),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Your personal astrology companion',
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          // Personalized profile card when chart exists
          if (chartProvider.hasChart) ...[
            const SizedBox(height: 16),
            _buildProfileCard(context, chartProvider),
          ],

          // Daily tip card — MIXIN + didChangeDependencies IN ACTION!
          // DailyTipCard uses CosmicBreathingMixin for pulse animation,
          // and didChangeDependencies to read the user's sign from Provider.
          // No parameter needed — the card reads BirthChartProvider itself!
          const SizedBox(height: 16),
          const DailyTipCard(),

          const SizedBox(height: 20),
          Text(
            'Zodiac Signs',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'Tap a sign to read today\'s horoscope',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, BirthChartProvider chartProvider) {
    final chart = chartProvider.chart!;
    final sunSign = chart.sunSign.sign;
    final moonSign = chart.moonSign.sign;
    final risingSign = chart.risingSignName;

    // Find the zodiac symbol for the sun sign
    final sunZodiac = ZodiacSign.all.firstWhere(
      (z) => z.name == sunSign,
      orElse: () => ZodiacSign.all.first,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentPurple.withAlpha(40),
            AppTheme.accentGold.withAlpha(20),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.accentPurple.withAlpha(60),
        ),
      ),
      child: Row(
        children: [
          Text(sunZodiac.symbol, style: const TextStyle(fontSize: 36)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Cosmic Profile',
                  style: TextStyle(
                    color: AppTheme.accentGold,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _buildBadge('\u2609 $sunSign'),
                    const SizedBox(width: 6),
                    _buildBadge('\u263D $moonSign'),
                    const SizedBox(width: 6),
                    _buildBadge('\u2191 $risingSign'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}