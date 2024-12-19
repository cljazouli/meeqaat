import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/prayer_times_service.dart';
import '../screens/prayer_times_screen.dart';

class LocationSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrayerTimesScreen(useCurrentLocation: true),
                  ),
                );
              },
              child: Text('Use Current Location'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrayerTimesScreen(useCurrentLocation: false),
                  ),
                );
              },
              child: Text('Enter City Name'),
            ),
          ],
        ),
      ),
    );
  }
}