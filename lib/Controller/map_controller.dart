

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class MapController extends GetxController{

   Completer<GoogleMapController> mapController = Completer<GoogleMapController>();

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

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    //
    // for(int i=0;i<latlong.length ; i++){
    //   markers.add(
    //     Marker(
    //         markerId: MarkerId(i.toString()),
    //         position: latlong[i],
    //         // infoWindow: const InfoWindow(
    //         //   title: 'Location from map',
    //         //   snippet: '5 star location' ,
    //         // ),
    //       icon: BitmapDescriptor.defaultMarker,
    //     )
    //   );
    //   update();
    //   polyLine.add(
    //       Polyline(
    //           polylineId: const PolylineId('1'),
    //           points: latlong,
    //           color:Colors.blueAccent,
    //           width: 4,
    //           startCap: Cap.roundCap,
    //           endCap: Cap.buttCap
    //       ));
    // }

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
   }

}