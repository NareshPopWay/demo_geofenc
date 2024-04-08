


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


class ChangeLanguageController extends GetxController{


  RxString selected = "0".obs;
  RxString languageCode = "en".obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    selected.value = await GetStorage().read("selected")??"0";
  }

  RxList<Language> languageList = <Language>[
    Language(id:0, flag: "🇺🇸", name: "English", languageCode: "en"),
    Language(id:1, flag: "🇮🇳", name: "ગુજરાતી\n Gujrati", languageCode: "gu"),
    Language(id:2, flag: "🇮🇳", name: "हिंदी\n Hindi", languageCode: "hi"),
    Language(id:3, flag: "🇮🇳", name: "मराठी\n Marathi", languageCode: "mr"),
  ].obs;

  Future changeLanguage(context) async {
    log('press');
    await GetStorage().write("selected", languageCode.value);
    await setLocale(languageCode.value);
    Phoenix.rebirth(context);
  }

}

/*{
  "appTitle_text" : "હોમ સ્ક્રીન",
  "btn_text" : "અહી દબાવ લ્યા",
  "loader_text" : "શાંતિ રાખ લ્યા",
  "title1_text" : "લોકેશન મળે છે",
  "title2_text" : "લોકેશન મળતી નથી",
  "content1_text" : "તમારી લોકેશન મળે છે",
  "content2_text" : "તમારી લોકેશન મળતી નથી",
  "dialogBtn_text" : "કશો વાંધો નઈ હો"
}*/