import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
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
  CityData('Houston', 29.7604, -95.3698, -6),
  CityData('Phoenix', 33.4484, -112.0740, -7),
  CityData('Philadelphia', 39.9526, -75.1652, -5),
  CityData('San Francisco', 37.7749, -122.4194, -8),
  CityData('Seattle', 47.6062, -122.3321, -8),
  CityData('Boston', 42.3601, -71.0589, -5),
  CityData('Atlanta', 33.7490, -84.3880, -5),
  CityData('London', 51.5074, -0.1278, 0),
  CityData('Paris', 48.8566, 2.3522, 1),
  CityData('Berlin', 52.5200, 13.4050, 1),
  CityData('Rome', 41.9028, 12.4964, 1),
  CityData('Madrid', 40.4168, -3.7038, 1),
  CityData('Moscow', 55.7558, 37.6173, 3),
  CityData('Dubai', 25.2048, 55.2708, 4),
  CityData('Mumbai', 19.0760, 72.8777, 5.5),
  CityData('Delhi', 28.7041, 77.1025, 5.5),
  CityData('Kolkata', 22.5726, 88.3639, 5.5),
  CityData('Chennai', 13.0827, 80.2707, 5.5),
  CityData('Bangalore', 12.9716, 77.5946, 5.5),
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
  CityData('Montreal', 45.5017, -73.5673, -5),
  CityData('Mexico City', 19.4326, -99.1332, -6),
  CityData('S\u00e3o Paulo', -23.5505, -46.6333, -3),
  CityData('Rio de Janeiro', -22.9068, -43.1729, -3),
  CityData('Buenos Aires', -34.6037, -58.3816, -3),
  CityData('Johannesburg', -26.2041, 28.0473, 2),
  CityData('Cape Town', -33.9249, 18.4241, 2),
  CityData('Lagos', 6.5244, 3.3792, 1),
  CityData('Nairobi', -1.2921, 36.8219, 3),
  CityData('Amsterdam', 52.3676, 4.9041, 1),
  CityData('Stockholm', 59.3293, 18.0686, 1),
  CityData('Lisbon', 38.7223, -9.1393, 0),
  CityData('Athens', 37.9838, 23.7275, 2),
  CityData('Warsaw', 52.2297, 21.0122, 1),
  CityData('Vienna', 48.2082, 16.3738, 1),
  CityData('Zurich', 47.3769, 8.5417, 1),
  CityData('Brussels', 50.8503, 4.3517, 1),
  CityData('Dublin', 53.3498, -6.2603, 0),
  CityData('Prague', 50.0755, 14.4378, 1),
  CityData('Budapest', 47.4979, 19.0402, 1),
  CityData('Copenhagen', 55.6761, 12.5683, 1),
  CityData('Oslo', 59.9139, 10.7522, 1),
  CityData('Helsinki', 60.1699, 24.9384, 2),
  CityData('Edinburgh', 55.9533, -3.1883, 0),
  CityData('Barcelona', 41.3874, 2.1686, 1),
  CityData('Milan', 45.4642, 9.1900, 1),
  CityData('Munich', 48.1351, 11.5820, 1),
  CityData('Riyadh', 24.7136, 46.6753, 3),
  CityData('Tehran', 35.6892, 51.3890, 3.5),
  CityData('Baghdad', 33.3152, 44.3661, 3),
  CityData('Karachi', 24.8607, 67.0011, 5),
  CityData('Lahore', 31.5204, 74.3587, 5),
  CityData('Dhaka', 23.8103, 90.4125, 6),
  CityData('Jakarta', -6.2088, 106.8456, 7),
  CityData('Manila', 14.5995, 120.9842, 8),
  CityData('Kuala Lumpur', 3.1390, 101.6869, 8),
  CityData('Taipei', 25.0330, 121.5654, 8),
  CityData('Osaka', 34.6937, 135.5023, 9),
  CityData('Auckland', -36.8485, 174.7633, 12),
  CityData('Lima', -12.0464, -77.0428, -5),
  CityData('Bogot\u00e1', 4.7110, -74.0721, -5),
  CityData('Santiago', -33.4489, -70.6693, -4),
  CityData('Vancouver', 49.2827, -123.1207, -8),
  CityData('Denver', 39.7392, -104.9903, -7),
  CityData('Miami', 25.7617, -80.1918, -5),
  CityData('Honolulu', 21.3069, -157.8583, -10),
  CityData('Anchorage', 61.2181, -149.9003, -9),
  CityData('Casablanca', 33.5731, -7.5898, 1),
  CityData('Accra', 5.6037, -0.1870, 0),
  CityData('Addis Ababa', 9.0250, 38.7469, 3),
  CityData('Hanoi', 21.0278, 105.8342, 7),
  CityData('Ho Chi Minh City', 10.8231, 106.6297, 7),
  CityData('Perth', -31.9505, 115.8605, 8),
  CityData('Doha', 25.2854, 51.5310, 3),
  CityData('Kuwait City', 29.3759, 47.9774, 3),
  CityData('Amman', 31.9454, 35.9284, 3),
  CityData('Beirut', 33.8938, 35.5018, 2),
  CityData('Tel Aviv', 32.0853, 34.7818, 2),
  CityData('Tunis', 36.8065, 10.1815, 1),
  CityData('Algiers', 36.7538, 3.0588, 1),
  CityData('Havana', 23.1136, -82.3666, -5),
  CityData('San Juan', 18.4655, -66.1057, -4),
  CityData('Reykjavik', 64.1466, -21.9426, 0),
];

class LocationPicker extends StatefulWidget {
  final void Function(CityData city) onCitySelected;

  const LocationPicker({super.key, required this.onCitySelected});

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  String _search = '';
  bool _showCustomInput = false;
  bool _isLoadingLocation = false;
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  final _utcController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _latController.dispose();
    _lngController.dispose();
    _utcController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  List<CityData> get _filtered {
    if (_search.isEmpty) return majorCities;
    final q = _search.toLowerCase();
    return majorCities.where((c) => c.name.toLowerCase().contains(q)).toList();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied';
      }

      final position = await Geolocator.getCurrentPosition();
      final lat = position.latitude;
      final lng = position.longitude;

      // Try to get city name
      String cityName = '${lat.toStringAsFixed(2)}, ${lng.toStringAsFixed(2)}';
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          cityName = p.locality ?? p.subAdministrativeArea ?? p.name ?? cityName;
        }
      } catch (_) {}

      // Approximate UTC offset based on longitude
      // This is a rough estimation (15 degrees = 1 hour)
      double estimatedUtc = (lng / 15.0).roundToDouble();

      setState(() {
        _latController.text = lat.toStringAsFixed(4);
        _lngController.text = lng.toStringAsFixed(4);
        _utcController.text = estimatedUtc.toString();
        _nameController.text = cityName;
        _showCustomInput = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  void _submitCustomLocation() {
    final lat = double.tryParse(_latController.text);
    final lng = double.tryParse(_lngController.text);
    final utc = double.tryParse(_utcController.text);

    if (lat == null || lng == null || utc == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid numbers')),
      );
      return;
    }
    if (lat < -90 || lat > 90) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Latitude must be between -90 and 90')),
      );
      return;
    }
    if (lng < -180 || lng > 180) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Longitude must be between -180 and 180')),
      );
      return;
    }
    if (utc < -12 || utc > 14) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('UTC offset must be between -12 and +14')),
      );
      return;
    }

    final name = _nameController.text.trim().isNotEmpty
        ? _nameController.text.trim()
        : '${lat.toStringAsFixed(2)}\u00B0, ${lng.toStringAsFixed(2)}\u00B0';

    widget.onCitySelected(CityData(name, lat, lng, utc));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Toggle between city search and custom input
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _showCustomInput = false),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: !_showCustomInput
                        ? AppTheme.accentPurple.withAlpha(30)
                        : AppTheme.cardDark,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    border: Border.all(
                      color: !_showCustomInput
                          ? AppTheme.accentPurple.withAlpha(80)
                          : Colors.white.withAlpha(10),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Search City',
                      style: TextStyle(
                        color: !_showCustomInput
                            ? AppTheme.accentPurple
                            : AppTheme.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _showCustomInput = true),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: _showCustomInput
                        ? AppTheme.accentPurple.withAlpha(30)
                        : AppTheme.cardDark,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    border: Border.all(
                      color: _showCustomInput
                          ? AppTheme.accentPurple.withAlpha(80)
                          : Colors.white.withAlpha(10),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Custom Location',
                      style: TextStyle(
                        color: _showCustomInput
                            ? AppTheme.accentPurple
                            : AppTheme.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (_showCustomInput) _buildCustomInput() else _buildCitySearch(),

        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _isLoadingLocation ? null : _getCurrentLocation,
            icon: _isLoadingLocation
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppTheme.accentPurple),
                  )
                : const Icon(Icons.my_location, size: 18),
            label: Text(_isLoadingLocation ? 'Locating...' : 'Use My Current Location'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.accentPurple,
              side: BorderSide(color: AppTheme.accentPurple.withAlpha(60)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCitySearch() {
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
          child: _filtered.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('No cities found.',
                          style: TextStyle(color: AppTheme.textSecondary)),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => setState(() => _showCustomInput = true),
                        child: const Text(
                          'Enter coordinates manually',
                          style: TextStyle(
                            color: AppTheme.accentPurple,
                            fontSize: 13,
                            decoration: TextDecoration.underline,
                            decorationColor: AppTheme.accentPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _filtered.length,
                  itemBuilder: (ctx, i) {
                    final city = _filtered[i];
                    return ListTile(
                      dense: true,
                      title: Text(city.name,
                          style:
                              const TextStyle(color: AppTheme.textPrimary)),
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

  Widget _buildCustomInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter any location by coordinates',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _nameController,
          style: const TextStyle(color: AppTheme.textPrimary),
          decoration: const InputDecoration(
            hintText: 'Location name (e.g. London)',
            prefixIcon:
                Icon(Icons.label_outline, color: AppTheme.textSecondary),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _latController,
                style: const TextStyle(color: AppTheme.textPrimary),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true, signed: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
                ],
                decoration: const InputDecoration(
                  hintText: 'Latitude',
                  helperText: '-90 to 90',
                  helperStyle:
                      TextStyle(color: AppTheme.textSecondary, fontSize: 10),
                  prefixIcon: Icon(Icons.north, color: AppTheme.textSecondary,
                      size: 18),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _lngController,
                style: const TextStyle(color: AppTheme.textPrimary),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true, signed: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
                ],
                decoration: const InputDecoration(
                  hintText: 'Longitude',
                  helperText: '-180 to 180',
                  helperStyle:
                      TextStyle(color: AppTheme.textSecondary, fontSize: 10),
                  prefixIcon: Icon(Icons.east, color: AppTheme.textSecondary,
                      size: 18),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _utcController,
          style: const TextStyle(color: AppTheme.textPrimary),
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true, signed: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
          ],
          decoration: const InputDecoration(
            hintText: 'UTC offset (e.g. -5, 5.5, 3)',
            helperText: '-12 to +14',
            helperStyle:
                TextStyle(color: AppTheme.textSecondary, fontSize: 10),
            prefixIcon:
                Icon(Icons.schedule, color: AppTheme.textSecondary, size: 18),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _submitCustomLocation,
            icon: const Icon(Icons.check, size: 18),
            label: const Text('Use This Location'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }
}
