import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CityData {
  final String name;
  final double latitude;
  final double longitude;
  final double utcOffset;

  const CityData(this.name, this.latitude, this.longitude, this.utcOffset);
}

const majorCities = [
  CityData('New York', 40.7128, -74.0060, -5),
  CityData('Los Angeles', 34.0522, -118.2437, -8),
  CityData('Chicago', 41.8781, -87.6298, -6),
  CityData('London', 51.5074, -0.1278, 0),
  CityData('Paris', 48.8566, 2.3522, 1),
  CityData('Berlin', 52.5200, 13.4050, 1),
  CityData('Rome', 41.9028, 12.4964, 1),
  CityData('Madrid', 40.4168, -3.7038, 1),
  CityData('Moscow', 55.7558, 37.6173, 3),
  CityData('Dubai', 25.2048, 55.2708, 4),
  CityData('Mumbai', 19.0760, 72.8777, 5.5),
  CityData('Delhi', 28.7041, 77.1025, 5.5),
  CityData('Bangkok', 13.7563, 100.5018, 7),
  CityData('Singapore', 1.3521, 103.8198, 8),
  CityData('Hong Kong', 22.3193, 114.1694, 8),
  CityData('Beijing', 39.9042, 116.4074, 8),
  CityData('Shanghai', 31.2304, 121.4737, 8),
  CityData('Tokyo', 35.6762, 139.6503, 9),
  CityData('Seoul', 37.5665, 126.9780, 9),
  CityData('Sydney', -33.8688, 151.2093, 10),
  CityData('Melbourne', -37.8136, 144.9631, 10),
  CityData('Cairo', 30.0444, 31.2357, 2),
  CityData('Istanbul', 41.0082, 28.9784, 3),
  CityData('Toronto', 43.6532, -79.3832, -5),
  CityData('Mexico City', 19.4326, -99.1332, -6),
  CityData('S\u00e3o Paulo', -23.5505, -46.6333, -3),
  CityData('Buenos Aires', -34.6037, -58.3816, -3),
  CityData('Johannesburg', -26.2041, 28.0473, 2),
  CityData('Lagos', 6.5244, 3.3792, 1),
  CityData('Nairobi', -1.2921, 36.8219, 3),
  CityData('Amsterdam', 52.3676, 4.9041, 1),
  CityData('Stockholm', 59.3293, 18.0686, 1),
  CityData('Lisbon', 38.7223, -9.1393, 0),
  CityData('Athens', 37.9838, 23.7275, 2),
  CityData('Warsaw', 52.2297, 21.0122, 1),
  CityData('Vienna', 48.2082, 16.3738, 1),
  CityData('Zurich', 47.3769, 8.5417, 1),
  CityData('Riyadh', 24.7136, 46.6753, 3),
  CityData('Tehran', 35.6892, 51.3890, 3.5),
  CityData('Jakarta', -6.2088, 106.8456, 7),
  CityData('Manila', 14.5995, 120.9842, 8),
  CityData('Kuala Lumpur', 3.1390, 101.6869, 8),
  CityData('Taipei', 25.0330, 121.5654, 8),
  CityData('Osaka', 34.6937, 135.5023, 9),
  CityData('Auckland', -36.8485, 174.7633, 12),
  CityData('Lima', -12.0464, -77.0428, -5),
  CityData('Bogot\u00e1', 4.7110, -74.0721, -5),
  CityData('Vancouver', 49.2827, -123.1207, -8),
  CityData('Denver', 39.7392, -104.9903, -7),
  CityData('Miami', 25.7617, -80.1918, -5),
];

class LocationPicker extends StatefulWidget {
  final void Function(CityData city) onCitySelected;

  const LocationPicker({super.key, required this.onCitySelected});

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  String _search = '';

  List<CityData> get _filtered {
    if (_search.isEmpty) return majorCities;
    final q = _search.toLowerCase();
    return majorCities.where((c) => c.name.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          style: const TextStyle(color: AppTheme.textPrimary),
          decoration: const InputDecoration(
            hintText: 'Search city...',
            prefixIcon: Icon(Icons.search, color: AppTheme.textSecondary),
          ),
          onChanged: (v) => setState(() => _search = v),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: _filtered.length,
            itemBuilder: (ctx, i) {
              final city = _filtered[i];
              return ListTile(
                dense: true,
                title: Text(city.name,
                    style: const TextStyle(color: AppTheme.textPrimary)),
                subtitle: Text(
                  'UTC${city.utcOffset >= 0 ? "+" : ""}${city.utcOffset}',
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 12),
                ),
                trailing: Text(
                  '${city.latitude.toStringAsFixed(1)}\u00B0, ${city.longitude.toStringAsFixed(1)}\u00B0',
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 11),
                ),
                onTap: () => widget.onCitySelected(city),
              );
            },
          ),
        ),
      ],
    );
  }
}
