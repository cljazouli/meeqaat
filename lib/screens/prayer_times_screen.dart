import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/prayer_times_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class PrayerTimesScreen extends StatefulWidget {
  final bool useCurrentLocation;

  const PrayerTimesScreen({required this.useCurrentLocation});

  @override
  _PrayerTimesScreenState createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  Map<String, String>? _prayerTimes;
  final TextEditingController _cityController = TextEditingController();
  final PrayerTimesService _prayerTimesService = PrayerTimesService();
  Map<String, Map<String, dynamic>> _cityData = {};

  @override
  void initState() {
    super.initState();
    if (widget.useCurrentLocation) {
      _handleLocationPermission();
    } else {
      _loadCityData();
    }
  }

  Future<void> _loadCityData() async {
    try {
      final String response = await rootBundle.loadString('lib/assets/city_coordinates.json');
      final Map<String, dynamic> data = json.decode(response);
      setState(() {
        _cityData = Map<String, Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Error loading city data: $e';
      });
    }
  }

  Future<void> _handleLocationPermission() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
       setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Location services are disabled. Please enable them.';
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'Location permissions are denied';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _isLoading = false;
      });
      _showLocationPermissionDialog();
      return;
    }

    _fetchLocationAndTimes();
  }

  Future<void> _fetchLocationAndTimes() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      await _fetchPrayerTimes(
          latitude: position.latitude, longitude: position.longitude);
    } catch (e) {
       setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Error getting location: $e';
      });
    }
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Permission'),
          content: Text('Location permission is permanently denied. Please enable it in settings.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await openAppSettings();
                Navigator.of(context).pop();
              },
              child: const Text('Go to Settings'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _fetchPrayerTimes({double? latitude, double? longitude, String? city}) async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      final timings = await _prayerTimesService.getPrayerTimes(
        latitude: latitude,
        longitude: longitude,
        city: city,
      );

      setState(() {
        _prayerTimes = timings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  List<String> _getCitySuggestions(String query) {
    return _cityData.keys
        .where((cityName) => cityName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Times'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)))
              : _prayerTimes == null
                  ? widget.useCurrentLocation
                      ? const Center(child: Text('Fetching location...'))
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              TypeAheadField<String>(
                                textFieldConfiguration: const TextFieldConfiguration(
                                  decoration: InputDecoration(
                                    labelText: 'Enter City Name',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                suggestionsBoxDecoration: const SuggestionsBoxDecoration(
                                  constraints: BoxConstraints(maxHeight: 200),
                                ),
                                suggestionsCallback: (pattern) async {
                                  return _getCitySuggestions(pattern);
                                },
                                itemBuilder: (context, String suggestion) {
                                  return ListTile(
                                    title: Text(suggestion),
                                  );
                                },
                                onSuggestionSelected: (String suggestion) {
                                  _cityController.text = suggestion;
                                },
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  String city = _cityController.text;
                                  if (_cityData.containsKey(city)) {
                                    double latitude = _cityData[city]!['latitude'];
                                    double longitude = _cityData[city]!['longitude'];
                                    _fetchPrayerTimes(city: city);
                                  } else {
                                    setState(() {
                                      _errorMessage = 'City not found!';
                                      _hasError = true;
                                    });
                                  }
                                },
                                child: const Text('Fetch Prayer Times'),
                              ),
                            ],
                          ),
                        )
                  : ListView.builder(
                      itemCount: _prayerTimes!.length,
                      itemBuilder: (context, index) {
                        String prayerName = _prayerTimes!.keys.elementAt(index);
                        String prayerTime = _prayerTimes![prayerName]!;

                        return ListTile(
                          title: Text(prayerName),
                          subtitle: Text(prayerTime),
                        );
                      },
                    ),
    );
  }
}