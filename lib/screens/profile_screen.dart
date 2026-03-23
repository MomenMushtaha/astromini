import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_profile_provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'sign_up_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personality Profile')),
      body: Consumer2<UserProfileProvider, AuthProvider>(
        builder: (ctx, provider, auth, _) {
          if (provider.isGenerating) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: AppTheme.accentPurple),
                  SizedBox(height: 16),
                  Text('Analyzing your cosmic blueprint...',
                      style: TextStyle(color: AppTheme.textSecondary)),
                ],
              ),
            );
          }

          if (!provider.hasProfile) {
            return const Center(
              child: Text('No profile generated yet.',
                  style: TextStyle(color: AppTheme.textSecondary)),
            );
          }

          final profile = provider.profile!;
          final chart = profile.chart;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Auth Prompt for Guest Users
                if (!auth.isAuthenticated)
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.accentPurple.withAlpha(40),
                          AppTheme.accentPurple.withAlpha(10),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.accentPurple.withAlpha(60)),
                    ),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Text('\u2728', style: TextStyle(fontSize: 20)),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Save your profile to your account to access it anywhere!',
                                style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignUpScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.accentPurple,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Sign Up to Save Profile'),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Header badges
                Center(
                  child: Wrap(
                    spacing: 10,
                    children: [
                      _badge(
                        '\u2600\uFE0F',
                        'Sun',
                        chart.sunSign.sign,
                        const Color(0xFFFFD54F),
                      ),
                      _badge(
                        '\u{1F319}',
                        'Moon',
                        chart.moonSign.sign,
                        const Color(0xFF90CAF9),
                      ),
                      _badge(
                        '\u2B06\uFE0F',
                        'Rising',
                        chart.risingSignName,
                        const Color(0xFFCE93D8),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Element balance
                Text('Element Balance',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                _buildElementBars(profile.elementBalance),
                const SizedBox(height: 24),

                // Sun sign analysis
                _sectionCard(
                  context,
                  icon: '\u2600\uFE0F',
                  title: 'Sun in ${chart.sunSign.sign}',
                  content: profile.sunSignAnalysis,
                ),
                const SizedBox(height: 12),

                // Moon sign analysis
                _sectionCard(
                  context,
                  icon: '\u{1F319}',
                  title: 'Moon in ${chart.moonSign.sign}',
                  content: profile.moonSignAnalysis,
                ),
                const SizedBox(height: 12),

                // Rising sign analysis
                _sectionCard(
                  context,
                  icon: '\u2B06\uFE0F',
                  title: '${chart.risingSignName} Rising',
                  content: profile.risingSignAnalysis,
                ),
                const SizedBox(height: 24),

                // Planetary influences
                Text('Planetary Influences',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...profile.planetaryInfluences.map((inf) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.cardDark,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(inf.planet.symbol,
                              style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${inf.planet.displayName} in ${inf.sign} (House ${inf.house})',
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(inf.interpretation,
                                    style: const TextStyle(
                                        color: AppTheme.textSecondary,
                                        fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 20),

                // Love style
                _sectionCard(
                  context,
                  icon: '\u{1F496}',
                  title: 'Love Style',
                  content: profile.loveStyle,
                ),
                const SizedBox(height: 12),

                // Career aptitude
                _sectionCard(
                  context,
                  icon: '\u{1F4BC}',
                  title: 'Career Aptitude',
                  content: profile.careerAptitude,
                ),
                const SizedBox(height: 24),

                // Strengths
                Text('Strengths',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: profile.strengths
                      .map((s) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF66BB6A).withAlpha(25),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color:
                                      const Color(0xFF66BB6A).withAlpha(60)),
                            ),
                            child: Text(s,
                                style: const TextStyle(
                                    color: Color(0xFF66BB6A), fontSize: 12)),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),

                // Challenges
                Text('Growth Areas',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: profile.challenges
                      .map((c) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF5350).withAlpha(25),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color:
                                      const Color(0xFFEF5350).withAlpha(60)),
                            ),
                            child: Text(c,
                                style: const TextStyle(
                                    color: Color(0xFFEF5350), fontSize: 12)),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 24),

                // Overall summary
                _sectionCard(
                  context,
                  icon: '\u2728',
                  title: 'Overall Summary',
                  content: profile.overallSummary,
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _badge(String emoji, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(color: color, fontSize: 10,
                  fontWeight: FontWeight.w500)),
          Text(value,
              style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildElementBars(Map<String, double> balance) {
    const elementColors = {
      'Fire': Color(0xFFEF5350),
      'Earth': Color(0xFF66BB6A),
      'Air': Color(0xFFFFEE58),
      'Water': Color(0xFF42A5F5),
    };

    final total = balance.values.fold(0.0, (a, b) => a + b);
    if (total == 0) return const SizedBox.shrink();

    return Column(
      children: balance.entries.map((entry) {
        final pct = entry.value / total;
        final color = elementColors[entry.key] ?? Colors.grey;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              SizedBox(
                  width: 50,
                  child: Text(entry.key,
                      style:
                          TextStyle(color: color, fontSize: 12))),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: pct,
                    backgroundColor: color.withAlpha(20),
                    valueColor: AlwaysStoppedAnimation(color),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text('${(pct * 100).round()}%',
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 11)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _sectionCard(BuildContext context,
      {required String icon, required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withAlpha(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  )),
            ],
          ),
          const SizedBox(height: 8),
          Text(content,
              style: const TextStyle(
                  color: AppTheme.textSecondary, fontSize: 13, height: 1.5)),
        ],
      ),
    );
  }
}
