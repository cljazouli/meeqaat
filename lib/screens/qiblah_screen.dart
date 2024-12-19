import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io' show Platform;

class QiblahScreen extends StatefulWidget {
  const QiblahScreen({Key? key}) : super(key: key);

  @override
  State<QiblahScreen> createState() => _QiblahScreenState();
}

class _QiblahScreenState extends State<QiblahScreen> {
  final _qiblah = FlutterQiblah();
  bool _isLoading = false;
  bool _hasPermission = false;
  String _errorMessage = '';
  bool _permissionChecked = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _handleLocationPermission();
  }

  Future<void> _handleLocationPermission() async {
    if (_permissionChecked) return;

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
        _permissionChecked = true;
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
          _permissionChecked = true;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _isLoading = false;
        _permissionChecked = true;
      });
      _showLocationPermissionDialog();
      return;
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      setState(() {
        _hasPermission = true;
        _isLoading = false;
        _permissionChecked = true;
      });
    } else {
      setState(() {
        _isLoading = false;
        _permissionChecked = true;
        _errorMessage = "Could not get location permission";
        _hasError = true;
      });
    }
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission'),
          content: const Text(
              'Location permission is permanently denied. Please enable it in settings.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                openAppSettings().then((_) => Navigator.of(context).pop());
              },
              child: const Text('Go to Settings'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (_errorMessage.isNotEmpty || _hasError) {
      return Scaffold(body: Center(child: Text(_errorMessage)));
    } else if (!_hasPermission) {
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: _handleLocationPermission,
            child: const Text('Request Location Permission'),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Qibla"),
        ),
        body: const QiblahCompass(),
      );
    }
  }
}

class QiblahCompass extends StatelessWidget {
  const QiblahCompass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QiblahDirection>(
      stream: FlutterQiblah.qiblahStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error.toString()}",
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        }

        if (snapshot.data == null) {
          return const Center(
            child: Text(
              "Waiting for Qiblah data",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        final qiblahDirection = snapshot.data!;
        final angle = qiblahDirection.qiblah * (pi / 180) * -1;

        return Center(
          child: AspectRatio(
            aspectRatio: 1, // Ensures a square aspect ratio
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  'lib/assets/compass.svg',
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                ),
                Transform.rotate(
                  angle: angle,
                  child: SvgPicture.asset(
                    'lib/assets/needle.svg',
                    width: 150, // Adjust needle size for better visibility
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  child: Text(
                    "${qiblahDirection.offset.toStringAsFixed(3)}°",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}