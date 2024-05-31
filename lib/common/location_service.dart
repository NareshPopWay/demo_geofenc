import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class LocationService {
  static  Timer? timer;
  // static Position? _lastPosition;

  static  StreamSubscription<LocationData>? locationSubscription;
  static  Location location = Location();

  // static void startBackgroundLocationUpdates() {
  //   timer = Timer.periodic(const Duration(seconds: 5), (timer) {
  //     // startTracking();
  //     log('saveLiveLocation${timer.tick}');
  //     // saveLiveLocation();
  //   });
  // }



  static Future<void> saveLiveLocation(data) async {
    var responseJson;
    // if (_shouldStoreLocation(position))  {
    log('$data');
    final response = await http.post(
      Uri.parse('http://116.72.8.100:2202/api/CommanAPI/SaveLocation'),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        'Accept': 'application/json',
      },
      body: data,
    );
    if(response.statusCode == 200){
      responseJson = response.body.toString();
      log('saveLiveLocation : ${responseJson}');
    }else{
      log('Error');
    }
    // _lastPosition = position;
    // }
  }

  static void startBackgroundLocationUpdates() async {

    locationSubscription = location.onLocationChanged.listen((LocationData currentLocation) async{
      Map data = {
        'VendorID': '1',
        'Latitude':  currentLocation.latitude,
        'Longitude': currentLocation.longitude,
        'Locationdatetime': DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now()),
        'LocationAddress': 'Ahmedabad',
        'City': 'Surat',
        'Country': 'India',
        'PostalCode': '395005',
      };
      log('LIVELocation :- ${currentLocation.latitude.toString()},${currentLocation.longitude.toString()}  ');
      saveLiveLocation(data);
    });

    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (locationSubscription != null) {
        log('saveLIVELocation :- ${timer.tick} ');
        locationSubscription?.resume();
      }
    });

  }

  // static Future<void> startTracking() async {
  //   try {
  //     // Position position = await Geolocator.getCurrentPosition();
  //     // await _firestore.collection('UserLocations').add({
  //     //   'latitude': position.latitude,
  //     //   'longitude': position.longitude,
  //     //   'timestamp': FieldValue.serverTimestamp(),
  //     // });
  //     Geolocator.getPositionStream().listen((Position position) {
  //       if (_shouldStoreLocation(position)) {
  //         FirebaseFirestore.instance.collection('TrackingLocation').add({
  //           'latitude': position.latitude,
  //           'longitude': position.longitude,
  //           'timestamp': FieldValue.serverTimestamp(),
  //         });
  //         _lastPosition = position;
  //       }
  //     });
  //   } catch (e) {
  //     print('Failed to get location: $e');
  //   }
  // }


  // static Future<void> saveLiveLocation() async {
  //
  //   Geolocator.getPositionStream().listen((Position position) async{
  //     var responseJson;
  //     Map data = {
  //       'vendorLocationID': '01',
  //       'vendorID': '01',
  //       'latitude':  position.latitude,
  //       'longitude': position.longitude,
  //       'locationDateTime': DateFormat("yyyy-MM-dd").format(DateTime.now()),
  //       'locationAddress': 'Surat',
  //       'city': 'Surat',
  //       'country': 'India',
  //       'postalCode': '395005',
  //     };
  //     // if (_shouldStoreLocation(position))  {
  //       log('$data');
  //       final response = await http.post(
  //         Uri.parse('http://116.72.8.100:2202/api/CommanAPI/SaveLocation'),
  //         headers: {
  //           "Content-Type": "application/x-www-form-urlencoded",
  //           'Accept': 'application/json',
  //         },
  //         body: json.encode(data),
  //       );
  //       responseJson = response.body.toString();
  //       log('saveLiveLocation : ${responseJson}');
  //       // _lastPosition = position;
  //     // }
  //   });
  //
  // }



  // static bool _shouldStoreLocation(Position newPosition) {
  //   if (_lastPosition == null) {
  //     return true; // No previous position, store the new one
  //   }
  //
  //   double distance = Geolocator.distanceBetween(
  //     _lastPosition!.latitude,
  //     _lastPosition!.longitude,
  //     newPosition.latitude,
  //     newPosition.longitude,
  //   );
  //
  //   // Store if the new position is more than 10 meters away from the last position
  //   return distance > 10;
  // }

}
