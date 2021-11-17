import 'dart:ui';

import 'package:flutter/cupertino.dart';

import 'network_api.dart';

enum LanguageSupport { ru, en, unknown }

class LanguageStuff {
  static late LanguageSupport _own_language;

  static LanguageSupport languageDetect(String str) {
    RegExp en_exp = new RegExp(r"[a-zA-Z]");
    RegExp ru_exp = new RegExp(r"[а-яА-Я]");

    if (ru_exp.hasMatch(str)) {
      return LanguageSupport.ru;
    }
    if (en_exp.hasMatch(str)) {
      return LanguageSupport.en;
    }
    return LanguageSupport.unknown;
  }

  static LanguageSupport getOwnLanguage() {
    return _own_language;
  }

  static LanguageSupport computeOwnLanguage(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    print(
        "my: ${myLocale.languageCode} ru: ${Locale("ru").languageCode}, en: ${Locale("en").languageCode}");

    if (myLocale.languageCode == const Locale("ru").languageCode) {
      _own_language = LanguageSupport.ru;
      return _own_language;
    }
    if (myLocale.languageCode == const Locale("en").languageCode) {
      _own_language = LanguageSupport.en;
      return _own_language;
    }

    _own_language = LanguageSupport.en;
    return _own_language;
  }
}
