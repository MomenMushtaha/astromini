import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/zodiac_sign.dart';
import '../models/horoscope.dart';
import '../providers/horoscope_provider.dart';
import '../theme/app_theme.dart';

class HoroscopeScreen extends StatefulWidget {
  final ZodiacSign sign;

  const HoroscopeScreen({super.key, required this.sign});

  @override
  State<HoroscopeScreen> createState() => _HoroscopeScreenState();
}

class _HoroscopeScreenState extends State<HoroscopeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<HoroscopeProvider>().fetchHoroscope(widget.sign.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.sign.symbol} ${widget.sign.name}'),
      ),
      body: Consumer<HoroscopeProvider>(
        builder: (context, provider, _) {
          final horoscope = provider.getHoroscope(widget.sign.name);

          if (horoscope == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppTheme.accentPurple),
                  SizedBox(height: 16),
                  Text(
                    'Reading the stars...',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSignHeader(),
                const SizedBox(height: 20),
                _buildQuickStats(horoscope),
                if (horoscope.moonPhaseToday != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.cardDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppTheme.accentGold.withAlpha(40)),
                    ),
                    child: Row(
                      children: [
                        Text(horoscope.moonPhaseToday!.split(' ').first,
                            style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 10),
                        Text(
                          horoscope.moonPhaseToday!
                              .split(' ')
                              .skip(1)
                              .join(' '),
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (horoscope.keyTransits != null &&
                    horoscope.keyTransits!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.cardDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: const Color(0xFF42A5F5).withAlpha(40)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Key Transits Today',
                          style: TextStyle(
                            color: Color(0xFF42A5F5),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        ...horoscope.keyTransits!.map((t) => Padding(
                              padding: const EdgeInsets.only(bottom: 3),
                              child: Row(
                                children: [
                                  const Text('\u2022 ',
                                      style: TextStyle(
                                          color: Color(0xFF42A5F5))),
                                  Expanded(
                                    child: Text(t,
                                        style: const TextStyle(
                                          color: AppTheme.textSecondary,
                                          fontSize: 12,
                                        )),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
                // Void of Course Moon warning
                if (horoscope.voidOfCourseMoonWarning != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7043).withAlpha(15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: const Color(0xFFFF7043).withAlpha(60)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('\u26A0\uFE0F',
                            style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Void of Course Moon',
                                style: TextStyle(
                                  color: Color(0xFFFF7043),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                horoscope.voidOfCourseMoonWarning!,
                                style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 20),
                _buildReadingCard(
                  '\u{1F31E} Daily Reading',
                  horoscope.dailyReading,
                  AppTheme.accentGold,
                ),
                const SizedBox(height: 12),
                _buildReadingCard(
                  '\u{1F496} Love & Relationships',
                  horoscope.loveReading,
                  const Color(0xFFE91E63),
                ),
                const SizedBox(height: 12),
                _buildReadingCard(
                  '\u{1F4BC} Career & Finance',
                  horoscope.careerReading,
                  AppTheme.accentPurple,
                ),
                const SizedBox(height: 12),
                _buildReadingCard(
                  '\u{1F331} Health & Wellness',
                  horoscope.healthReading,
                  const Color(0xFF4CAF50),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSignHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.sign.color.withAlpha(60),
            AppTheme.cardDark,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.sign.color.withAlpha(80),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            widget.sign.symbol,
            style: const TextStyle(fontSize: 56),
          ),
          const SizedBox(height: 8),
          Text(
            widget.sign.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.sign.dateRange,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTag(widget.sign.element, widget.sign.icon),
              const SizedBox(width: 12),
              _buildTag(widget.sign.rulingPlanet, Icons.public),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.sign.description,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(height: 1.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.accentGold),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(Horoscope horoscope) {
    return Row(
      children: [
        Expanded(
            child: _buildStatCard(
                'Mood', horoscope.mood, Icons.mood, AppTheme.accentGold)),
        const SizedBox(width: 8),
        Expanded(
            child: _buildStatCard('Lucky #', horoscope.luckyNumber,
                Icons.tag, AppTheme.accentPurple)),
        const SizedBox(width: 8),
        Expanded(
            child: _buildStatCard('Color', horoscope.luckyColor,
                Icons.palette, widget.sign.color)),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildReadingCard(String title, String reading, Color accentColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            reading,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textPrimary,
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }
}
