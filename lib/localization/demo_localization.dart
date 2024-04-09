import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class DemoLocalization {
  DemoLocalization(this.locale);

  final Locale locale;

  static DemoLocalization? of(BuildContext context) {
    return Localizations.of<DemoLocalization>(context, DemoLocalization);
  }

  Map<String, String>? _localizedValues;

  Future<void> load() async {
    String jsonStringValues = await rootBundle
        .loadString('lib/languages/${locale.languageCode}.json');

    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);

    _localizedValues =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  String? translate(String key) {
    return _localizedValues![key];
  }

  static const LocalizationsDelegate<DemoLocalization> delegate =
      _DemoLocalizationsDelegate();
}

class _DemoLocalizationsDelegate
    extends LocalizationsDelegate<DemoLocalization> {
  const _DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // All supported languages

    return ['en', 'gu', 'hi', 'mr'].contains(locale.languageCode);
  }

  @override
  Future<DemoLocalization> load(Locale locale) async {
    DemoLocalization localization = DemoLocalization(locale);

    // The [load] method from DemoLocalization class runs here

    await localization.load();

    return localization;
  }

  @override
  //This method is called whenever its Localizations widget is rebuilt.

  // If it returns true then dependent widgets will be rebuilt after load has completed.

  bool shouldReload(LocalizationsDelegate<DemoLocalization> old) => false;
}
