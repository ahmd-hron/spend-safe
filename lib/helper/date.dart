import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Date {
  static Map<String, int> _celender({BuildContext? context}) {
    final Map<String, int> months = {
      'January': 31,
      'February': 28,
      'March': 31,
      'April': 30,
      'May': 31,
      'June': 30,
      'July': 31,
      'August': 31,
      'September': 30,
      'October': 31,
      'November': 30,
      'December': 31
    };
    if (context == null) return months;
    final AppLocalizations appLocal = AppLocalizations.of(context)!;
    final Map<String, int> localMonths = {
      appLocal.january: 31,
      appLocal.february: 28,
      appLocal.march: 31,
      appLocal.april: 30,
      appLocal.may: 31,
      appLocal.june: 30,
      appLocal.july: 31,
      appLocal.august: 31,
      appLocal.september: 30,
      appLocal.october: 31,
      appLocal.november: 30,
      appLocal.december: 31
    };
    return localMonths;
  }

  static int getMonthLeanght(int monthNumber) {
    int? days = 0;
    // days = celender.containsKey(monthName) ? celender[monthName] : 0;
    List<int> monthesDays = _celender().values.toList();
    days = monthesDays[monthNumber - 1];
    return days;
  }

  static String getMonthName(int monthNumber, {BuildContext? context}) {
    return _celender(context: context).keys.toList()[monthNumber - 1];
  }
}

// 1 January - 31 days
// 2 February - 28 days in a common year and 29 days in leap years
// 3 March - 31 days
// 4 April - 30 days
// 5 May - 31 days
// 6 June - 30 days
// 7 July - 31 days
// 8 August - 31 days
// 9 September - 30 days
// 10 October - 31 days
// 11 November - 30 days
// 12 December - 31 days
