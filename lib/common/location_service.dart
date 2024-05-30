import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class LocationService {
  static  Timer? timer;
  static Position? _lastPosition;
  static void startBackgroundLocationUpdates() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      startTracking();
    });
  }

  static Future<void> startTracking() async {
    try {
      // Position position = await Geolocator.getCurrentPosition();
      // await _firestore.collection('UserLocations').add({
      //   'latitude': position.latitude,
      //   'longitude': position.longitude,
      //   'timestamp': FieldValue.serverTimestamp(),
      // });
      Geolocator.getPositionStream().listen((Position position) {
        if (_shouldStoreLocation(position)) {
          FirebaseFirestore.instance.collection('TrackingLocation').add({
            'latitude': position.latitude,
            'longitude': position.longitude,
            'timestamp': FieldValue.serverTimestamp(),
          });
          _lastPosition = position;
        }
      });
    } catch (e) {
      print('Failed to get location: $e');
    }
  }

  static bool _shouldStoreLocation(Position newPosition) {
    if (_lastPosition == null) {
      return true; // No previous position, store the new one
    }

    double distance = Geolocator.distanceBetween(
      _lastPosition!.latitude,
      _lastPosition!.longitude,
      newPosition.latitude,
      newPosition.longitude,
    );

    // Store if the new position is more than 10 meters away from the last position
    return distance > 10;
  }

}
