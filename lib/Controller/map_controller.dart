

import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  List<LatLng> latlong = [
    const LatLng(21.180351273685073, 72.83307795975223),
    const LatLng(21.196701714974026, 72.81858339209033)
  ];

  final Set<Marker> markers ={};
  final Set<Polyline>polyLine ={};


  var location = Location();
  var routeCoordinates = <LatLng>[].obs;
  var routePolyline = Polyline(
    polylineId: PolylineId('route'),
    points: [],
    width: 5,
    color: Colors.blue,
  ).obs;

  GoogleMapController? mapController;



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
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    location.onLocationChanged.listen((LocationData currentLocation) async {
      final latLng = LatLng(currentLocation.latitude!, currentLocation.longitude!);
      final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

      await FirebaseFirestore.instance.collection('locations').add({
        'latitude': latLng.latitude,
        'longitude': latLng.longitude,
        'timestamp': timestamp,
      });

      routeCoordinates.add(latLng);

      updateRoutePolyline();

      // if (routeCoordinates.length > 1) {
      //   await _getRouteDirections();
      // } else {
      //   routePolyline.value = Polyline(
      //     polylineId: PolylineId('route'),
      //     points: List<LatLng>.from(routeCoordinates),
      //     width: 5,
      //     color: Colors.blue,
      //   );
      // }

      if (mapController != null) {
        mapController!.animateCamera(CameraUpdate.newLatLng(latLng));
      }
    });
  }


  void updateRoutePolyline() {
    routePolyline.value = Polyline(
      polylineId: PolylineId('route'),
      points: routeCoordinates,
      width: 5,
      color: Colors.blue,
    );
  }


  Future<void> _getRouteDirections() async {
    if (routeCoordinates.length < 2) return;

    final origin = routeCoordinates.first;
    final destination = routeCoordinates.last;
    final waypoints = routeCoordinates
        .sublist(1, routeCoordinates.length - 1)
        .map((point) => '${point.latitude},${point.longitude}')
        .join('|');

    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&waypoints=$waypoints&key=YOUR_API_KEY'; // Replace YOUR_API_KEY with your actual key

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final points = data['routes'][0]['overview_polyline']['points'];
      routePolyline.value = Polyline(
        polylineId: PolylineId('route'),
        points: _decodePolyline(points),
        width: 5,
        color: Colors.blue,
      );
    } else {
      print('Error fetching directions: ${response.body}');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      final p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }

  Future<void> showLocationsByDate(String date) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('locations')
        .where('timestamp', isGreaterThanOrEqualTo: '$date 00:00:00')
        .where('timestamp', isLessThanOrEqualTo: '$date 23:59:59')
        .get();

    List<LatLng> coordinates = querySnapshot.docs.map((doc) {
      return LatLng(doc['latitude'], doc['longitude']);
    }).toList();

    routeCoordinates.assignAll(coordinates);
    updateRoutePolyline();
    // await _getRouteDirections();
  }

}