
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
        body: Column(
          children: [
            Expanded(
              child: Obx(() => GoogleMap(
                initialCameraPosition:  controller.initialCameraPosition,
                mapType: MapType.hybrid,
                markers: controller.markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                polylines: Set<Polyline>.of([controller.routePolyline.value]),
                onMapCreated: (GoogleMapController googleMapController) async {
                  controller.location.getLocation().then((location) {
                    googleMapController.animateCamera(CameraUpdate.newLatLng(
                      LatLng(location.latitude!, location.longitude!),
                    ));
                  });
                },

              ),)
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Enter date (yyyy-MM-dd)',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) => controller.showLocationsByDate(value),
              ),
            ),
          ],
        ),
      );
    }
    );

  }
}
