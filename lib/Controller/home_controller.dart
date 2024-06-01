import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' show atan2, cos, pi, pow, sin, sqrt;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_geofenc/Model/lat_long_model.dart';
import 'package:demo_geofenc/common/localization/language_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:workmanager/workmanager.dart';

class HomeController extends GetxController {
  Rx<double> latitude = 0.0.obs;
  Rx<double> longitude = 0.0.obs;

  static Position? _lastPosition;
  Timer? _timer;
  StreamSubscription<LocationData>? locationSubscription;
  Location location = Location();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> getLocationAndSave() async {
    try {
      // Position position = await Geolocator.getCurrentPosition();
      // await _firestore.collection('UserLocations').add({
      //   'latitude': position.latitude,
      //   'longitude': position.longitude,
      //   'timestamp': FieldValue.serverTimestamp(),
      // });
      Geolocator.getPositionStream().listen((Position position) {
        if (_shouldStoreLocation(position)) {
          _firestore.collection('TrackingLocation').add({
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

   Future<void> saveLiveLocation(data) async {
      var responseJson;
      // if (_shouldStoreLocation(position))  {
        log('$data');
        final response = await http.post(
          Uri.parse('http://116.72.8.100:2202/api/CommanAPI/SaveLocation'),
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
          },
          body: data,
        );
        if(response.statusCode == 200){
          responseJson = response.body.toString();
          log('http://116.72.8.100:2202/api/CommanAPI/SaveLocation');
          log('saveLiveLocation : ${responseJson}');
        }else{
          log('Error');
        }
        // _lastPosition = position;
      // }
  }

  void _startForegroundLocationUpdates() {
      // getLocationAndSave();
      locationSubscription = location.onLocationChanged.listen((LocationData currentLocation) async{

        String lat = currentLocation.latitude.toString();
        String long = currentLocation.longitude.toString();

        Map data = {
          'VendorID':'1',
          'Latitude': lat,
          'Longitude':long,
          'Locationdatetime': DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now()),
          'LocationAddress':'Bhavnagar',
          'City':'surat',
          'Country':'india',
          'PostalCode':'395006',
        };
        saveLiveLocation(data);
      });

      Timer.periodic(const Duration(seconds: 5), (timer) {
        if (locationSubscription != null) {
          locationSubscription?.resume();
        }
      });

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

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();

    permission = await Geolocator.requestPermission();
    _checkLocationPermission();
    Workmanager().registerOneOffTask(
      "1",
      "fetchLocation",
      constraints: Constraints(networkType: NetworkType.connected),
      initialDelay: const Duration(seconds: 5),
    );
    _startForegroundLocationUpdates();

  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  LocationPermission? permission;
  Future _checkLocationPermission() async {

    // bool serviceEnabled;
    //
    // // Test if location services are enabled.
    // serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   return Future.error('Location services are disabled.');
    // }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  Future<Position?> _getCurrentLocation() async {
    bool hasPermission = await _checkLocationPermission();
    if (!hasPermission) {
      return null;
    }
    try {
      Position position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  List<Premises> premisesList = [
    Premises('આપડી ઓફિસ', 21.180374200910343, 72.83303760939276,
        100), // Example premises
    Premises('નરેશ ના ઘર', 21.22273766905689, 72.82031235394702,
        100), // Example premises
    Premises('નિલેશ ના ઘર', 21.22215503097752, 72.82183125905117,
        100), // Example premises
    Premises('સુરેશ ભાઈ ના ઘર', 21.150469096331015, 72.83434384427554,
        100), // Example premises
    // Add more premises with their coordinates and radius
  ];

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    double R = 6371e3; // Earth's radius in meters
    double degreesToRadians(double degrees) {
      return degrees * (pi / 180); // Convert degrees to radians using pi
    }

    double dLat = degreesToRadians(lat2 - lat1);
    double dLon = degreesToRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(degreesToRadians(lat1)) *
            cos(degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }

// Check if device is within any premise
  bool isInPremise = false;
  RxBool isInPremiseCheck = false.obs;

  Future<void> checkPremisesEntry(context) async {
    isInPremiseCheck.value = true;
    Position? position = await _getCurrentLocation();
    if (position == null) {
      return;
    }

    for (Premises premises in premisesList) {
      double distance = _calculateDistance(position.latitude,
          position.longitude, premises.latitude, premises.longitude);
      if (distance <= premises.radius) {
        // User is within the premises
        isInPremiseCheck.value = false;
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text(getTranslated(context, 'title1_text')!),
            content: Text(getTranslated(context, 'content1_text')!),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(getTranslated(context, 'dialogBtn_text')!),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          ),
        );
        return;
      }
    }
    isInPremiseCheck.value = false;
    // User is not within any premises (optional: update UI)
    showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text(getTranslated(context, 'title2_text')!),
              content: Text(getTranslated(context, 'content2_text')!),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(getTranslated(context, 'dialogBtn_text')!),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ));
  }


}
