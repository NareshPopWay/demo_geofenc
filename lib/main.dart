import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:demo_geofenc/common/localization/demo_localization.dart';
import 'package:demo_geofenc/common/localization/language_constant.dart';
import 'package:demo_geofenc/common/location_service.dart';
import 'package:demo_geofenc/ui/home_screen.dart';
import 'package:demo_geofenc/common/phoenix.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:workmanager/workmanager.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  FirebaseOptions options;
  if (Platform.isAndroid) {
    options = const FirebaseOptions(
        apiKey: "AIzaSyAW81Y8tg72GeQW-lP3lBGkb2lKpDQU6zE",
        appId: "1:668998087416:android:1c42dfe6648a9b9d22010d",
        messagingSenderId: "668998087416",
        projectId: "demoapp-9c6d4");
  } else {
    options = const FirebaseOptions(
        apiKey: "AIzaSyAWpZXX1XZ4MURLcnlFnpEWDQPq0r0yW_U",
        appId: "1:851415038414:ios:161a82264c21e3c7fb939f",
        messagingSenderId: "668998087416",
        projectId: "demoapp-9c6d4");
  }
  await Firebase.initializeApp(options: options);
  await initializeService();
  await GetStorage.init();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  runApp(DemoGeofence(child: const MyApp()));
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.value(false);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.value(false);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.value(false);
    }
      // Timer.periodic(const Duration(seconds: 5), (timer) async{
        Position position = await Geolocator.getCurrentPosition();
        print("Background Location: ${position.latitude}, ${position.longitude}");

        Map data = {
          'VendorID': '1',
          'Latitude':  position.latitude.toString(),
          'Longitude': position.longitude.toString(),
          'Locationdatetime': DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now()),
          'LocationAddress': 'Background Service from Phone Work Manager',
          'City': 'Surat',
          'Country': 'India',
          'PostalCode': '395005',
        };
        log('LIVELocation :- ${position.latitude.toString()},${position.longitude.toString()}  ');

        // saveLiveLocation(data);
      // });
      // You can send the location data to your server or handle it as needed
      return Future.value(true);

  });
}

Future<void> saveLiveLocation(data) async {
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

Future<void> initializeService() async {
    Location location = Location();
    location.enableBackgroundMode(enable: true);
    final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      autoStart: true,
    ),
  );
  service.startService();
}

void onStart(ServiceInstance service) {
   LocationService.startBackgroundLocationUpdates();
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (_locale == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[800]!)),
        ),
      );
    } else {
      return GetMaterialApp(
        title: 'GeoFenceDemo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        locale: _locale,
        localizationsDelegates: const [
          DemoLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale("en", "US"),
          Locale("gu", "IN"),
          Locale("hi", "IN"),
          Locale("mr", "IN")
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale!.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          // If the current locale doesn't match with any of the
          // supportedLocales, use the first supportedLocale, i.e., English.
          return supportedLocales.first;
        },
        home: HomeScreen(),
      );
    }
  }
}
