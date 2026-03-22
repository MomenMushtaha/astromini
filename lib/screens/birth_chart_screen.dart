import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/birth_data.dart';
import '../providers/birth_chart_provider.dart';
import '../providers/user_profile_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/chart_wheel.dart';
import '../widgets/planet_placement_card.dart';
import '../widgets/aspect_list_tile.dart';
import '../widgets/location_picker.dart';
import 'profile_screen.dart';
import 'compatibility_screen.dart';

class BirthChartScreen extends StatefulWidget {
  const BirthChartScreen({super.key});

  @override
  State<BirthChartScreen> createState() => _BirthChartScreenState();
}

class _BirthChartScreenState extends State<BirthChartScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  CityData? _selectedCity;
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _generateChart() {
    if (_selectedDate == null || _selectedTime == null || _selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final data = BirthData(
      name: _nameController.text.isNotEmpty ? _nameController.text : null,
      birthDate: _selectedDate!,
      birthHour: _selectedTime!.hour,
      birthMinute: _selectedTime!.minute,
      latitude: _selectedCity!.latitude,
      longitude: _selectedCity!.longitude,
      locationName: _selectedCity!.name,
      utcOffset: _selectedCity!.utcOffset,
    );

    context.read<BirthChartProvider>().calculateChart(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Birth Chart'),
        actions: [
          Consumer<BirthChartProvider>(
            builder: (ctx, prov, _) {
              if (!prov.hasChart) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.refresh, color: AppTheme.textSecondary),
                onPressed: () => prov.clearChart(),
                tooltip: 'New chart',
              );
            },
          ),
        ],
      ),
      body: Consumer<BirthChartProvider>(
        builder: (ctx, provider, _) {
          if (provider.isCalculating) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: AppTheme.accentPurple),
                  SizedBox(height: 16),
                  Text('Calculating planetary positions...',
                      style: TextStyle(color: AppTheme.textSecondary)),
                ],
              ),
            );
          }

          if (provider.hasChart) {
            return _buildChartView(provider);
          }

          return _buildInputForm();
        },
      ),
    );
  }

  Widget _buildInputForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('\u2728',
              style: TextStyle(fontSize: 40)),
          const SizedBox(height: 8),
          Text('Generate Your Birth Chart',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          const Text(
            'Enter your birth details to calculate your natal chart with planetary positions, houses, and aspects.',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 24),

          // Name
          TextField(
            controller: _nameController,
            style: const TextStyle(color: AppTheme.textPrimary),
            decoration: const InputDecoration(
              hintText: 'Your name (optional)',
              prefixIcon: Icon(Icons.person_outline, color: AppTheme.textSecondary),
            ),
          ),
          const SizedBox(height: 16),

          // Date
          GestureDetector(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime(1995, 6, 15),
                firstDate: DateTime(1920),
                lastDate: DateTime.now(),
              );
              if (date != null) setState(() => _selectedDate = date);
            },
            child: _buildField(
              icon: Icons.calendar_today,
              label: _selectedDate != null
                  ? '${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}'
                  : 'Select birth date',
            ),
          ),
          const SizedBox(height: 16),

          // Time
          GestureDetector(
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: const TimeOfDay(hour: 12, minute: 0),
              );
              if (time != null) setState(() => _selectedTime = time);
            },
            child: _buildField(
              icon: Icons.access_time,
              label: _selectedTime != null
                  ? _selectedTime!.format(context)
                  : 'Select birth time',
            ),
          ),
          const SizedBox(height: 16),

          // Location
          Text('Birth Location',
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          if (_selectedCity != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.accentPurple.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.accentPurple.withAlpha(60)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: AppTheme.accentPurple),
                  const SizedBox(width: 8),
                  Text(_selectedCity!.name,
                      style: const TextStyle(color: AppTheme.textPrimary)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => setState(() => _selectedCity = null),
                    child: const Icon(Icons.close, color: AppTheme.textSecondary, size: 18),
                  ),
                ],
              ),
            )
          else
            LocationPicker(
              onCitySelected: (city) => setState(() => _selectedCity = city),
            ),

          const SizedBox(height: 32),

          // Generate button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _generateChart,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Generate Chart',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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

  Widget _buildChartView(BirthChartProvider provider) {
    final chart = provider.chart!;
    final planets = chart.planets.values.toList()
      ..sort((a, b) => a.body.index.compareTo(b.body.index));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (chart.birthData.name != null)
            Text(chart.birthData.name!,
                style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            'Sun: ${chart.sunSign.formatted}  \u2022  Moon: ${chart.moonSign.formatted}  \u2022  Rising: ${chart.risingSignName}',
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Chart wheel
          ChartWheel(chart: chart, size: 300),
          const SizedBox(height: 20),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: _actionButton(
                  icon: Icons.person,
                  label: 'Profile',
                  onTap: () {
                    context.read<UserProfileProvider>().generateProfile(chart);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ProfileScreen()));
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _actionButton(
                  icon: Icons.favorite,
                  label: 'Compatibility',
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CompatibilityScreen())),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Planets
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Planetary Positions',
                style: Theme.of(context).textTheme.titleMedium),
          ),
          const SizedBox(height: 8),
          ...planets
              .map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: PlanetPlacementCard(position: p),
                  )),
          const SizedBox(height: 16),

          // Aspects
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Aspects (${chart.aspects.length})',
                style: Theme.of(context).textTheme.titleMedium),
          ),
          const SizedBox(height: 8),
          ...chart.aspects.take(15).map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: AspectListTile(aspect: a),
              )),
        ],
      ),
    );
  }

  Widget _actionButton(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.accentPurple.withAlpha(60)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppTheme.accentPurple, size: 18),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(
                    color: AppTheme.textPrimary, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
