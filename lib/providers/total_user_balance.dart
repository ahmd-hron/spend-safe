import 'package:flutter/foundation.dart';

import '../helper/date.dart';

class TotalUserBalanceProvider with ChangeNotifier {
  // double _userSalary = 0;
  double _usertotalBonusePays = 0;
  double _userTotalExpens = 0;

  void updateProvider(
      double userSalary, double userTotalBalance, double userTotalExpens) {
    // this._userSalary = userSalary;
    this._usertotalBonusePays = userTotalBalance;
    this._userTotalExpens = userTotalExpens;

    notifyListeners();
  }

  double get totalUserBalance {
    return _usertotalBonusePays;
  }

  double get userTotalExpense {
    return _userTotalExpens;
  }

  double get remainingBalance {
    // if (userTotalExpens > totalUserBalance) return 0;

    return totalUserBalance - _userTotalExpens;
  }

  double get avgDaySpend {
    int monthDays = Date.getMonthLeanght(DateTime.now().month);
    int remainingDays = monthDays - DateTime.now().day;

    if (remainingDays <= 0) return remainingBalance;
    // print('this is the remaining days of this month $remainingDays');

    return remainingBalance <= 0 ? 0 : (remainingBalance / remainingDays);
  }

  double get spendPrecentage {
    if (remainingBalance <= 0) return 0.0;
    return remainingBalance / totalUserBalance;
  }
}
