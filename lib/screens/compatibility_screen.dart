import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/birth_data.dart';
import '../providers/birth_chart_provider.dart';
import '../providers/compatibility_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/location_picker.dart';
import '../widgets/synastry_wheel_painter.dart';
import '../widgets/score_meter.dart';

class CompatibilityScreen extends StatefulWidget {
  const CompatibilityScreen({super.key});

  @override
  State<CompatibilityScreen> createState() => _CompatibilityScreenState();
}

class _CompatibilityScreenState extends State<CompatibilityScreen> {
  DateTime? _partnerDate;
  TimeOfDay? _partnerTime;
  CityData? _partnerCity;
  final _partnerNameController = TextEditingController();

  @override
  void dispose() {
    _partnerNameController.dispose();
    super.dispose();
  }

  void _calculate() {
    final userChart = context.read<BirthChartProvider>().chart;
    if (userChart == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Generate your birth chart first')),
      );
      return;
    }
    if (_partnerDate == null ||
        _partnerTime == null ||
        _partnerCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill in all partner details')),
      );
      return;
    }

    final partnerData = BirthData(
      name: _partnerNameController.text.isNotEmpty
          ? _partnerNameController.text
          : null,
      birthDate: _partnerDate!,
      birthHour: _partnerTime!.hour,
      birthMinute: _partnerTime!.minute,
      latitude: _partnerCity!.latitude,
      longitude: _partnerCity!.longitude,
      locationName: _partnerCity!.name,
      utcOffset: _partnerCity!.utcOffset,
    );

    context
        .read<CompatibilityProvider>()
        .calculateCompatibility(userChart, partnerData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compatibility'),
        actions: [
          Consumer<CompatibilityProvider>(
            builder: (ctx, prov, _) {
              if (prov.result == null) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.refresh,
                    color: AppTheme.textSecondary),
                onPressed: () => prov.clearResult(),
                tooltip: 'New comparison',
              );
            },
          ),
        ],
      ),
      body: Consumer<CompatibilityProvider>(
        builder: (ctx, provider, _) {
          if (provider.isCalculating) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                      color: AppTheme.accentPurple),
                  SizedBox(height: 16),
                  Text('Comparing cosmic blueprints...',
                      style:
                          TextStyle(color: AppTheme.textSecondary)),
                ],
              ),
            );
          }

          if (provider.result != null) {
            return _buildResult(provider);
          }

          return _buildPartnerForm();
        },
      ),
    );
  }

  Widget _buildPartnerForm() {
    final hasUserChart = context.watch<BirthChartProvider>().hasChart;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('\u{1F496}', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 8),
          Text('Compatibility Scanner',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(
            hasUserChart
                ? 'Enter your partner\'s birth details to compare charts.'
                : 'Generate your birth chart first, then come back to check compatibility.',
            style: const TextStyle(color: AppTheme.textSecondary),
          ),
          if (!hasUserChart) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.accentPurple.withAlpha(15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppTheme.accentPurple.withAlpha(40)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline,
                      color: AppTheme.accentPurple, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Go to the Chart tab and generate your birth chart first.',
                      style: TextStyle(
                          color: AppTheme.textSecondary, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (hasUserChart) ...[
            const SizedBox(height: 24),
            TextField(
              controller: _partnerNameController,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Partner\'s name (optional)',
                prefixIcon: Icon(Icons.person_outline,
                    color: AppTheme.textSecondary),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime(1995, 6, 15),
                  firstDate: DateTime(1920),
                  lastDate: DateTime.now(),
                );
                if (date != null) setState(() => _partnerDate = date);
              },
              child: _buildField(
                icon: Icons.calendar_today,
                label: _partnerDate != null
                    ? '${_partnerDate!.month}/${_partnerDate!.day}/${_partnerDate!.year}'
                    : 'Select birth date',
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: const TimeOfDay(hour: 12, minute: 0),
                );
                if (time != null) setState(() => _partnerTime = time);
              },
              child: _buildField(
                icon: Icons.access_time,
                label: _partnerTime != null
                    ? _partnerTime!.format(context)
                    : 'Select birth time',
              ),
            ),
            const SizedBox(height: 16),
            Text('Birth Location',
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            if (_partnerCity != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.accentPurple.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppTheme.accentPurple.withAlpha(60)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: AppTheme.accentPurple),
                    const SizedBox(width: 8),
                    Text(_partnerCity!.name,
                        style: const TextStyle(
                            color: AppTheme.textPrimary)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () =>
                          setState(() => _partnerCity = null),
                      child: const Icon(Icons.close,
                          color: AppTheme.textSecondary, size: 18),
                    ),
                  ],
                ),
              )
            else
              LocationPicker(
                onCitySelected: (city) =>
                    setState(() => _partnerCity = city),
              ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _calculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Compare Charts',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildField(
      {required IconData icon, required String label}) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.textSecondary, size: 20),
          const SizedBox(width: 12),
          Text(label,
              style: TextStyle(
                color: label.startsWith('Select')
                    ? AppTheme.textSecondary
                    : AppTheme.textPrimary,
              )),
        ],
      ),
    );
  }

  Widget _buildResult(CompatibilityProvider provider) {
    final result = provider.result!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Names
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(result.chart1.birthData.name ?? 'You',
                  style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('\u{1F496}',
                    style: TextStyle(fontSize: 20)),
              ),
              Text(result.chart2.birthData.name ?? 'Partner',
                  style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 20),

          // Overall score
          ScoreMeter(
            label: 'Overall',
            score: result.overallScore,
            size: 120,
          ),
          const SizedBox(height: 20),

          // Category scores
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ScoreMeter(
                  label: 'Emotional',
                  score: result.emotionalScore,
                  size: 70),
              ScoreMeter(
                  label: 'Passion',
                  score: result.passionScore,
                  size: 70),
              ScoreMeter(
                  label: 'Communication',
                  score: result.communicationScore,
                  size: 70),
              ScoreMeter(
                  label: 'Growth',
                  score: result.growthScore,
                  size: 70),
            ],
          ),
          const SizedBox(height: 24),

          // Synastry wheel
          if (provider.partnerChart != null)
            SizedBox(
              width: 280,
              height: 280,
              child: CustomPaint(
                painter: SynastryWheelPainter(
                  chart1: result.chart1,
                  chart2: result.chart2,
                ),
                size: const Size(280, 280),
              ),
            ),
          const SizedBox(height: 20),

          // AI Analysis
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text('\u{1F52E}',
                        style: TextStyle(fontSize: 18)),
                    SizedBox(width: 8),
                    Text('Cosmic Analysis',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        )),
                  ],
                ),
                const SizedBox(height: 8),
                Text(result.aiAnalysis,
                    style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                        height: 1.5)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Strengths & Challenges
          if (result.strengths.isNotEmpty) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Strengths',
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            const SizedBox(height: 8),
            ...result.strengths.map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('\u2705 ',
                          style: TextStyle(fontSize: 12)),
                      Expanded(
                        child: Text(s,
                            style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 13)),
                      ),
                    ],
                  ),
                )),
          ],
          if (result.challenges.isNotEmpty) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Growth Areas',
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            const SizedBox(height: 8),
            ...result.challenges.map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('\u{1F4A1} ',
                          style: TextStyle(fontSize: 12)),
                      Expanded(
                        child: Text(c,
                            style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 13)),
                      ),
                    ],
                  ),
                )),
          ],

          // Synastry aspects
          if (result.synastryAspects.isNotEmpty) ...[
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  'Synastry Aspects (${result.synastryAspects.length})',
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            const SizedBox(height: 8),
            ...result.synastryAspects.take(12).map((a) => Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.cardDark,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: a.type.color.withAlpha(40)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: a.type.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(a.planet1.symbol,
                          style: const TextStyle(
                              fontSize: 16,
                              color: AppTheme.textPrimary)),
                      const SizedBox(width: 6),
                      Text(a.type.displayName,
                          style: TextStyle(
                            color: a.type.color,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          )),
                      const SizedBox(width: 6),
                      Text(a.planet2.symbol,
                          style: const TextStyle(
                              fontSize: 16,
                              color: AppTheme.textPrimary)),
                      const Spacer(),
                      Text(
                          'orb ${a.orb.toStringAsFixed(1)}\u00B0',
                          style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 11)),
                    ],
                  ),
                )),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
