import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TutrialDialog {
  // static List<String> salaryPage() { return [
  //   'you can press on this button to see where have you spent all your money so far ',
  //   'you can press on this button to check where have you gain all your money'
  // ];}
  static List<String> salaryPage(BuildContext context) {
    var appL = AppLocalizations.of(context);
    return [
      appL!.firstSalaryTip,
      appL.secondSalaryTip,
    ];
  }

  // static List<String> expensePage = [
  //   'three rules here : \n\n\n1_Press on expense item to view the details you provided\n\n2_Jold on expense item to edite it\n\n3_Swipe left to delete stuff'
  // ];
  static List<String> expensePage(BuildContext context) {
    var appL = AppLocalizations.of(context);
    return [appL!.expensesTip];
  }

  // static List<String> bonusePage = [
  //   'three rules here \n\n\n1_Press on bonuse item to view the details you provided\n\n2_Jold on bonuse item to edite it\n\n3_Swipe left to delete an stuff'
  // ];
  static List<String> bonusePage(BuildContext context) {
    var appL = AppLocalizations.of(context);

    return [appL!.balanceTip];
  }
}
