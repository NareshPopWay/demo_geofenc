

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_geofenc/Model/location_data_model.dart';
import 'package:demo_geofenc/common/api_provider.dart';
import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';


class MapController extends GetxController{

   // Completer<GoogleMapController> mapController = Completer<GoogleMapController>();
  CameraPosition initialCameraPosition = const CameraPosition(
      target: LatLng(21.180351273685073, 72.83307795975223),
      zoom: 11.2
  );

  // List<LatLng> latlong = [
  //   const LatLng(21.180351273685073, 72.83307795975223),
  //   const LatLng(21.196701714974026, 72.81858339209033)
  // ];
  //
  // final Set<Marker> markers ={};
  // final Set<Polyline>polyLine ={};
  //
  //
  // var location = Location();
  List<LatLng> polylineCoordinates = [];
  Set<Marker> markers = {};

  GoogleMapController? mapController;
  var locations = <Map<String, dynamic>>[].obs;

  // final Set<Marker> markers = {};
  Polyline? polyline;
  RxBool isLoading = false.obs;
  // Define your static data as a List of LatLng objects
  final List<LatLng> staticLocations = [
    LatLng(21.180386455116643, 72.8330288075414),
    LatLng(21.180524075433002, 72.83269093135651),
    LatLng(21.182532017420893, 72.8314761778303),
    LatLng(21.183046869948488, 72.83117801105568),
    LatLng(21.183517116951915, 72.83149031064191),
    LatLng(21.18375775236059, 72.8330196394889),
    LatLng(21.18402512457751, 72.83461587647295),
    LatLng(21.184782676566165, 72.83568640666584),
    LatLng(21.185549136980438, 72.83660400397405),
    LatLng(21.18624429531491, 72.83782746705164),
    LatLng(21.187028572588158, 72.83931856267745),
    LatLng(21.189028782204936, 72.84085616320793),
    LatLng(21.190850515603515, 72.84206438591039),
    LatLng(21.193102585961928, 72.84350934568951),
    LatLng(21.19423808057487, 72.84347835671986),
    LatLng(21.19470036598862, 72.84350624680751),
    LatLng(21.195922526029854, 72.84354343357842),
    LatLng(21.19750871865994, 72.8433420052777),
    LatLng(21.198496830063654, 72.84297633542288),
    LatLng(21.199224907918047, 72.84248361078635),
    LatLng(21.19999920900103, 72.84177396334553),
    LatLng(21.20108810399423, 72.8407714830566),
    LatLng(21.201871062722777, 72.83995957202723),
    LatLng(21.202466224134856, 72.83942346285193),
    LatLng(21.202968931441784, 72.83916315549293),
    LatLng(21.203266510235633, 72.83971166025609),
    LatLng(21.20369987636721, 72.83999985769904),
    LatLng(21.204193912173626, 72.84023537386854),
    LatLng(21.204627275555413, 72.84026016504427),
    LatLng(21.20472261532875, 72.84047398893499),
    LatLng(21.20490490211637, 72.8410786864115),
  ];



  void getAndShowStaticLocations() {
      markers.clear();
      polyline = Polyline(
        polylineId: PolylineId('static_locations'),
        points: polylineCoordinates,
        color: Colors.blue,
        width: 5,
      );
      // for (final location in routeCoordinates) {
      //   markers.add(Marker(
      //     markerId: MarkerId(location.toString()),
      //     position: location,
      //     infoWindow: InfoWindow(
      //       title: 'Static Location',
      //       snippet: '${location.latitude}, ${location.longitude}',
      //     ),
      //   ));
      // }

      /// Add markers only for start and end positions
      // markers.add(Marker(
      //   markerId: MarkerId('start'),
      //   position: polylineCoordinates.first,
      //   infoWindow: InfoWindow(
      //     title: 'Start Location',
      //     snippet: '${polylineCoordinates.first.latitude}, ${polylineCoordinates.first.longitude}',
      //   ),
      // ));
      // markers.add(Marker(
      //   markerId: MarkerId('end'),
      //   position: polylineCoordinates.last,
      //   infoWindow: InfoWindow(
      //     title: 'End Location',
      //     snippet: '${polylineCoordinates.last.latitude}, ${polylineCoordinates.last.longitude}',
      //   ),
      // ));
    update();
  }

  // Timer? _timer;
  //
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //
  //  Future<void> getLocationAndSave() async {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition();
  //     await _firestore.collection('UserLocations').add({
  //       'latitude': position.latitude,
  //       'longitude': position.longitude,
  //       'timestamp': FieldValue.serverTimestamp(),
  //     });
  //   } catch (e) {
  //     print('Failed to get location: $e');
  //   }
  // }
  //
  // void _startForegroundLocationUpdates() {
  //   _timer = Timer.periodic(Duration(seconds: 5), (timer) {
  //     getLocationAndSave();
  //   });
  // }

  // List<LatLng> latlong = [
  //   const LatLng(21.180351273685073, 72.83307795975223),
  //   const LatLng(21.196701714974026, 72.81858339209033)
  // ];
  //
  // final Set<Marker> markers ={};
  // final Set<Polyline>polyLine ={};
  //
  //
  //  var location = Location();
  //  var routeCoordinates = <LatLng>[].obs;
  //  var routePolyline = Polyline(
  //    polylineId: PolylineId('route'),
  //    points: [],
  //    width: 5,
  //    color: Colors.blue,
  //  ).obs;

  @override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();
    // location.onLocationChanged.listen((LocationData currentLocation) async {
    //   final latLng = LatLng(currentLocation.latitude!, currentLocation.longitude!);
    //   final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    //
    //   await FirebaseFirestore.instance.collection('locations').add({
    //     'latitude': latLng.latitude,
    //     'longitude': latLng.longitude,
    //     'timestamp': timestamp,
    //   });
    //
    //   routeCoordinates.add(latLng);
    //
    //   updateRoutePolyline();
    //
    //   // if (routeCoordinates.length > 1) {
    //   //   await _getRouteDirections();
    //   // } else {
    //   //   routePolyline.value = Polyline(
    //   //     polylineId: PolylineId('route'),
    //   //     points: List<LatLng>.from(routeCoordinates),
    //   //     width: 5,
    //   //     color: Colors.blue,
    //   //   );
    //   // }
    //
    //   if (mapController != null) {
    //     mapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    //   }
    // });
    // _startForegroundLocationUpdates();

    _startEndIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(24, 24)),
      'assets/location.png',
    );
    _intermediateIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      'assets/intermediate_marker.png',
    );
    getLocationList();
    //     .then((value) {
    //   getAndShowStaticLocations();
    // }
    // );
  }

  Future fetchLocations() async{
    isLoading.value = true ;
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    Timestamp startTimestamp = Timestamp.fromDate(startOfDay);
    Timestamp endTimestamp = Timestamp.fromDate(endOfDay);
    // final querySnapshot = await FirebaseFirestore.instance
    //     .collection('UserLocations')
    //     .where('timestamp', isGreaterThanOrEqualTo: '$date 00:00:00')
    //     .where('timestamp', isLessThanOrEqualTo: '$date 23:59:59')
    //     .get();

    // final querySnapshot = await FirebaseFirestore.instance
    //     .collection('UserLocations')
    //     .where('timestamp', isGreaterThanOrEqualTo: startTimestamp)
    //     .where('timestamp', isLessThanOrEqualTo: endTimestamp)
    //     .get();

    final querySnapshot = await FirebaseFirestore.instance
        .collection('TrackingLocation')
        .where('timestamp', isGreaterThanOrEqualTo: startTimestamp)
        .where('timestamp', isLessThanOrEqualTo: endTimestamp)
        .get();



    List<LatLng> coordinates = querySnapshot.docs.map((doc) {
      return LatLng(doc['latitude'], doc['longitude']);
    }).toList();

    // if(coordinates.isNotEmpty){
    polylineCoordinates.assignAll(coordinates);
      isLoading.value = false;
    // }else{
    //   Geolocator.getPositionStream().listen((Position position) async{
    //     List<LatLng> coordinates = querySnapshot.docs.map((doc) {
    //       return LatLng(position.latitude,position.longitude);
    //     }).toList();
    //     routeCoordinates.assignAll(coordinates);
    //     isLoading.value = false;
    //     });
    //   isLoading.value = false;
    // }

    isLoading.value = false;
    // _firestore.collection('UserLocations').snapshots().listen((snapshot) {
    //
    //   locations.value = snapshot.docs.map((doc) => doc.data()).toList();
    // });
  }

  BitmapDescriptor? _startEndIcon;
  BitmapDescriptor? _intermediateIcon;
  Future<void> getLocationList() async {
    isLoading.value = true;

    try {
      List<LocationDataModel> locations = await APiProvider().fetchLIVELocationData();

      List<LatLng> coordinates = locations
          .where((location) => location.latitude != null && location.longitude != null)
          .map((location) => LatLng(double.parse(location.latitude!), double.parse(location.longitude!)))
          .toList();




      Set<Marker> marker = locations
          .where((location) => location.latitude != null && location.longitude != null)
          .map((location) => Marker(
        markerId: MarkerId(location.vendorLocationId.toString()),
        icon: _intermediateIcon!,
        position: LatLng(double.parse(location.latitude!), double.parse(location.longitude!)),
        infoWindow: InfoWindow(
          title: location.locationAddress,
          snippet: '${location.city}, ${location.country}',
        ),
      )).toSet();


      polylineCoordinates = coordinates;
      markers = marker;
      markers.add(Marker(
        markerId: MarkerId('start'),
        position: polylineCoordinates.first,
        icon: _startEndIcon!,
        infoWindow: InfoWindow(
          title: 'Start Location',
          snippet: '${polylineCoordinates.first.latitude}, ${polylineCoordinates.first.longitude}',
        ),
      ));
      markers.add(Marker(
        markerId: MarkerId('end'),
        position: polylineCoordinates.last,
        icon: _startEndIcon!,
        infoWindow: InfoWindow(
          title: 'End Location',
          snippet: '${polylineCoordinates.last.latitude}, ${polylineCoordinates.last.longitude}',
        ),
      ));
      update();
      isLoading.value = false;

    } catch (e) {
      print('Error loading location data: $e');
    }

    isLoading.value = false;
    return;
  }

  // void updateRoutePolyline() {
  //   routePolyline.value = Polyline(
  //     polylineId: PolylineId('route'),
  //     points: routeCoordinates,
  //     width: 5,
  //     color: Colors.blue,
  //   );
  // }

  //
  // Future<void> _getRouteDirections() async {
  //   if (routeCoordinates.length < 2) return;
  //
  //   final origin = routeCoordinates.first;
  //   final destination = routeCoordinates.last;
  //   final waypoints = routeCoordinates
  //       .sublist(1, routeCoordinates.length - 1)
  //       .map((point) => '${point.latitude},${point.longitude}')
  //       .join('|');
  //
  //   final url =
  //       'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&waypoints=$waypoints&key=YOUR_API_KEY'; // Replace YOUR_API_KEY with your actual key
  //
  //   final response = await http.get(Uri.parse(url));
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     final points = data['routes'][0]['overview_polyline']['points'];
  //     routePolyline.value = Polyline(
  //       polylineId: PolylineId('route'),
  //       points: _decodePolyline(points),
  //       width: 5,
  //       color: Colors.blue,
  //     );
  //   } else {
  //     print('Error fetching directions: ${response.body}');
  //   }
  // }
  //
  // List<LatLng> _decodePolyline(String encoded) {
  //   List<LatLng> poly = [];
  //   int index = 0, len = encoded.length;
  //   int lat = 0, lng = 0;
  //
  //   while (index < len) {
  //     int b, shift = 0, result = 0;
  //     do {
  //       b = encoded.codeUnitAt(index++) - 63;
  //       result |= (b & 0x1f) << shift;
  //       shift += 5;
  //     } while (b >= 0x20);
  //     int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
  //     lat += dlat;
  //
  //     shift = 0;
  //     result = 0;
  //     do {
  //       b = encoded.codeUnitAt(index++) - 63;
  //       result |= (b & 0x1f) << shift;
  //       shift += 5;
  //     } while (b >= 0x20);
  //     int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
  //     lng += dlng;
  //
  //     final p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
  //     poly.add(p);
  //   }
  //   return poly;
  // }

  // Future<void> showLocationsByDate(String date) async {
  //   final querySnapshot = await FirebaseFirestore.instance
  //       .collection('locations')
  //       .where('timestamp', isGreaterThanOrEqualTo: '$date 00:00:00')
  //       .where('timestamp', isLessThanOrEqualTo: '$date 23:59:59')
  //       .get();
  //
  //   List<LatLng> coordinates = querySnapshot.docs.map((doc) {
  //     return LatLng(doc['latitude'], doc['longitude']);
  //   }).toList();
  //
  //   routeCoordinates.assignAll(coordinates);
  //   updateRoutePolyline();
  //   // await _getRouteDirections();
  // }

}