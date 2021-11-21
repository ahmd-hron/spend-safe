import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/l10n.dart';

class LocalProvider with ChangeNotifier {
  Locale? _locale;

  Locale? get locale {
    return _locale;
  }

  void setLocal(Locale locale) async {
    if (!L10n.all.contains(locale)) return;
    _locale = locale;
    await saveLanguage(locale.toString());
    notifyListeners();
  }

  void clearLocal() {
    _locale = null;
  }

  Future saveLanguage(String languageCode) async {
    final SharedPreferences userPref = await SharedPreferences.getInstance();
    userPref.setString('local', languageCode);
  }

  Future getLang() async {
    final SharedPreferences userPref = await SharedPreferences.getInstance();
    if (userPref.getString('local') == null) {
      // saveLanguage('en');
    } else {
      _locale = Locale(userPref.getString('local')!);
    }
  }

  String localToString(BuildContext context) {
    //this if statement only work for 2 languages
    //it check if the device in arabic or not for the very first time and return a value
    //for more language just make it a map with local key and string value pairs
    //this will work more than fine for here
    if (_locale == null)
      return Localizations.localeOf(context) == Locale('ar')
          ? 'Arabic'
          : 'English';
    return _locale.toString() == 'en' ? 'English' : 'Arabic';
  }
}
