import 'dart:convert';
import 'package:flutter/services.dart'; // For rootBundle
import 'package:http/http.dart' as http;

class PrayerTimesService {
  final String _baseUrl = 'http://api.aladhan.com/v1/timings';
  final String _cityCoordinatesFile = 'lib/assets/city_coordinates.json';

  Future<Map<String, String>> getPrayerTimes({double? latitude, double? longitude, String? city}) async {
    if (city != null) {
      final coordinates = await _getCoordinatesFromCity(city);
      if (coordinates != null) {
        latitude = coordinates['latitude'];
        longitude = coordinates['longitude'];
      } else {
        throw Exception('City not found in the local database.');
      }
    }

    if (latitude == null || longitude == null) {
      throw Exception('Either coordinates or city must be provided.');
    }

    final url = Uri.parse('$_baseUrl?latitude=$latitude&longitude=$longitude&method=2');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null && data['data']['timings'] != null) {
          return Map<String, String>.from(data['data']['timings']);
        } else {
          throw Exception('Unexpected API response format.');
        }
      } else {
        throw Exception('Failed to load prayer times: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching prayer times: $error');
    }
  }

  Future<Map<String, double>?> _getCoordinatesFromCity(String city) async {
    try {
      // Use rootBundle to load assets instead of File
      final fileContent = await rootBundle.loadString(_cityCoordinatesFile);
      final Map<String, dynamic> data = json.decode(fileContent);

      if (data.containsKey(city)) {
        final coordinates = data[city];
        return {
          'latitude': coordinates['latitude'],
          'longitude': coordinates['longitude'],
        };
      }
      return null;
    } catch (error) {
      throw Exception('Error reading city coordinates: $error');
    }
  }
}
