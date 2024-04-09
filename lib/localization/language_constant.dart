import 'package:demo_geofenc/localization/demo_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

const String LAGUAGE_CODE = 'languageCode';

///languages code

const String ENGLISH = 'en';

const String GUJRATI = 'gu';

const String HINDI = 'hi';

const String MARATHI = 'mr';

/// To store and save the selected language according to the language code

Future<Locale> setLocale(String languageCode) async {
  await GetStorage().write(LAGUAGE_CODE, languageCode);

  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  String languageCode = GetStorage().read(LAGUAGE_CODE).toString() ?? "en";

  return _locale(languageCode);
}

// switch statements

Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return const Locale(ENGLISH, 'US');

    case GUJRATI:
      return const Locale(GUJRATI, "IN");

    case HINDI:
      return const Locale(HINDI, "IN");

    case MARATHI:
      return const Locale(MARATHI, "IN");

    default:
      return const Locale(ENGLISH, 'US');
  }
}

String? getTranslated(BuildContext context, String key) {
  return DemoLocalization.of(context)!.translate(key);
}
