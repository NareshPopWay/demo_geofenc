


import 'dart:developer';
import 'dart:io';
import 'dart:math' show atan2, cos, pi, pow, sin, sqrt;
import 'dart:math' as math;
import 'package:demo_geofenc/Model/language_model.dart';
import 'package:demo_geofenc/Model/lat_long_model.dart';
import 'package:demo_geofenc/localization/language_constant.dart';
import 'package:demo_geofenc/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class HomeController extends GetxController{

  Rx<double> latitude = 0.0.obs;
  Rx<double> longitude = 0.0.obs;

  RxString selected = "0".obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();

    permission = await Geolocator.requestPermission();
    _checkLocationPermission();
    selected.value = await GetStorage().read("selected")??"0";
  }

  LocationPermission? permission;
  Future<bool> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

   RxList<Language> languageList = <Language>[
     Language(id:0, flag: "🇺🇸", name: "English", languageCode: "en"),
     Language(id:1, flag: "🇮🇳", name: "ગુજરાતી", languageCode: "gu"),
     Language(id:2, flag: "🇮🇳", name: "हिंदी", languageCode: "hi"),
   ].obs;

  Future changeLanguage(Language language,context) async {
    log('press');
    await GetStorage().write("selected", language.id.toString());
    Locale _locale = await setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
    Phoenix.rebirth(context);
  }

  Future<Position?> _getCurrentLocation() async {
    bool hasPermission = await _checkLocationPermission();
    if (!hasPermission) {
      return null;
    }
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return position;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  List<Premises> premisesList = [
    Premises('આપડી ઓફિસ',21.180374200910343 ,72.83303760939276, 100), // Example premises
    Premises('નરેશ ના ઘર',21.22273766905689, 72.82031235394702, 100), // Example premises
    Premises('નિલેશ ના ઘર',21.22215503097752, 72.82183125905117, 100), // Example premises
    Premises('સુરેશ ભાઈ ના ઘર',21.150469096331015, 72.83434384427554, 100), // Example premises
    // Add more premises with their coordinates and radius
  ];


  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
     double R = 6371e3; // Earth's radius in meters
     double degreesToRadians(double degrees) {
       return degrees * (pi / 180); // Convert degrees to radians using pi
     }
    double dLat = degreesToRadians(lat2 - lat1);
    double dLon = degreesToRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) + cos(degreesToRadians(lat1)) * cos(degreesToRadians(lat2)) * sin(dLon / 2) * sin(dLon / 2);
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
      double distance = _calculateDistance(position.latitude, position.longitude, premises.latitude, premises.longitude);
      if (distance <= premises.radius) {
        // User is within the premises
        isInPremiseCheck.value = false;
        showCupertinoDialog(
          context: context,
          builder: (context) =>  CupertinoAlertDialog(
            title:   Text(getTranslated(context, 'title1_text')!),
            content:  Text(getTranslated(context, 'content1_text')!),
            actions:  <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child:  Text(getTranslated(context, 'dialogBtn_text')!),
                onPressed: (){
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
        builder: (context) =>   CupertinoAlertDialog(
          title:   Text(getTranslated(context, 'title2_text')!),
          content:   Text(getTranslated(context, 'content2_text')!),
          actions:  <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child:Text(getTranslated(context, 'dialogBtn_text')!),
              onPressed:(){
                Get.back();
              },
            ),
          ],
        )
    );
  }

}