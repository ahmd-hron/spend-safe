import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Validator {
  static String? nameValidator(String? value, AppLocalizations? appl) {
    if (value == null || value.isEmpty)
      return appl!.nullName;
    else if (value.length < 2)
      return appl!.shortName;
    else if (value.length > 25) return appl!.longName;
    return null;
  }

  static String? amountValidator(String? value, AppLocalizations? appl) {
    if (value == null || value.isEmpty) return appl!.nullNumber;
    if (double.tryParse(value) == null) return appl!.falseNumber;
    if (double.parse(value) <= 0) return appl!.negativeNumber;
    return null;
  }
}
