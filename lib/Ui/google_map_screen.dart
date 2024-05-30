
import 'package:demo_geofenc/Controller/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends GetView<MapController> {
   GoogleMapScreen({super.key});

  MapController controller = Get.put(MapController());

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<MapController>(
        builder:(controller) {
      return Scaffold(
        body:
        // Obx(() {
        //   if (controller.locations.isEmpty) {
        //     return Center(child: CircularProgressIndicator());
        //   } else {
        //     List<LatLng> latLngs = controller.locations.map((loc) {
        //       return LatLng(loc['latitude'], loc['longitude']);
        //     }).toList();
        //     return GoogleMap(
        //       initialCameraPosition: CameraPosition(
        //         target: latLngs.first,
        //         zoom: 15,
        //       ),
        //       mapType: MapType.hybrid,
        //       markers: latLngs.map((latLng) => Marker(
        //         markerId: MarkerId(latLng.toString()),
        //         position: latLng,
        //       )).toSet(),
        //       polylines: {
        //         Polyline(
        //           polylineId: PolylineId('route'),
        //           points: latLngs,
        //           color: Colors.blue,
        //           width: 5,
        //         )
        //       },
        //     );
        //   }
        // }),
        Stack(
          children: [
            if (controller.routeCoordinates.isEmpty)
             const Center(child: CircularProgressIndicator(color: Colors.blueAccent,))
           else
            Expanded(
              child:  GoogleMap(
                initialCameraPosition:  controller.initialCameraPosition,
                mapType: MapType.hybrid,
                markers: controller.markers,
                myLocationEnabled: true,
                zoomControlsEnabled: true,
                myLocationButtonEnabled: true,
                polylines: {controller.polyline!},
                onMapCreated: (GoogleMapController googleMapController) async {
                  controller.fetchLocations().then((location) {
                    googleMapController.animateCamera(CameraUpdate.newLatLng(
                      LatLng(location['latitude'], location['longitude']),
                    ));
                  });
                },

              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextField(
            //     decoration: InputDecoration(
            //       labelText: 'Enter date (yyyy-MM-dd)',
            //       border: OutlineInputBorder(),
            //     ),
            //     onSubmitted: (value) => controller.showLocationsByDate(value),
            //   ),
            // ),
          ],
        ),
      );
    }
    );

  }
}
