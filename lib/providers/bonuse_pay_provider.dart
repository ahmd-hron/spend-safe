import 'package:flutter/foundation.dart';

import '../models/bounsePay.dart';

import '../helper/db_helper.dart';
import '../providers/user_data.dart';

class BonusePayProvider with ChangeNotifier {
  List<BonusePay> _bonusePays = [];
  List<BonusePay> _bonusePaysView = [];

  Future updateProvider() async {
    await getBonuseBalances(UserDataProvider.timeFilter!);
    notifyListeners();
  }

  List<BonusePay> get monthBousePays {
    return [..._bonusePays.reversed];
  }

  List<BonusePay> get viewBonusePays {
    return [..._bonusePaysView.reversed];
  }

  double get totalMonthBounse {
    double total = 0.0;
    if (_bonusePays.length <= 0) {
      return 0;
    }
    _bonusePays.forEach((bounse) {
      total += bounse.amount;
    });

    return total;
  }

  Future<double> totalFiltered(UserTimeFilter filter) async {
    double total = 0.0;
    _bonusePaysView = await _readBalanceTable(filter);
    if (_bonusePaysView.length <= 0) {
      return 0.0;
    }
    _bonusePaysView.forEach((bounse) {
      total += bounse.amount;
    });
    return total;
  }

  //this method provide total info for the total user provider
  Future getBonuseBalances([UserTimeFilter filter = UserTimeFilter.all]) async {
    _bonusePays = await _readBalanceTable(filter);
  }

  //read all database from device based on filtered search
  Future<List<BonusePay>> _readBalanceTable(UserTimeFilter filter) async {
    List<BonusePay> tempList = [];
    List<Map<String, dynamic>> db = await DataBaseHelper.readFromBalance();
    db.forEach((balancePay) {
      final tempBonuse = BonusePay(
        amount: balancePay['amount'],
        id: balancePay['id'],
        title: balancePay['title'],
        decription: balancePay['decription'],
        payDate: DateTime.parse(
          balancePay['date'],
        ),
      );
      switch (filter) {
        case UserTimeFilter.all:
          tempList.add(tempBonuse);
          break;
        case UserTimeFilter.year:
          if (tempBonuse.payDate.year == DateTime.now().year)
            tempList.add(tempBonuse);
          break;
        case UserTimeFilter.month:
          if (tempBonuse.payDate.month == DateTime.now().month &&
              tempBonuse.payDate.year == DateTime.now().year)
            tempList.add(tempBonuse);
          break;
        default:
          tempList.add(tempBonuse);
      }
    });
    return tempList;
  }

  Future addMonthBounse(
      double amount, String title, String decription, DateTime date) async {
    await DataBaseHelper.insertInBalance({
      'id': date.toIso8601String(),
      'title': title,
      'amount': amount,
      'decription': decription,
      'date': date.toIso8601String(),
    });
    BonusePay bonuse = BonusePay(
      amount: amount,
      title: title,
      id: date.toIso8601String(),
      decription: decription,
      payDate: date,
    );
    _checkFilterAndUpdateOverView(bonuse);
  }

  Future updateBonuse(String id, String title, double amount,
      String description, DateTime payDate) async {
    BonusePay bonuse = BonusePay(
        id: id,
        title: title,
        amount: amount,
        decription: description,
        payDate: payDate);
    int i = _bonusePays.indexWhere((bonuse) => bonuse.id == id);
    if (i >= 0) _bonusePays.remove(_bonusePays[i]);
    _checkFilterAndUpdateOverView(bonuse, true);
    DataBaseHelper.updateBonuse(id, {
      'id': id,
      'title': title,
      'amount': amount,
      'decription': description,
      'date': payDate.toIso8601String()
    });
  }

  void deleteBounse(String id) {
    int i = _bonusePays.indexWhere((bonuse) => bonuse.id == id);
    if (i >= 0) {
      _bonusePays.remove(_bonusePays[i]);
      notifyListeners();
    }
    DataBaseHelper.deleteFromTable(DataBaseHelper.balanceTable, id);
  }

  List<BonusePay> filterSearch(String searchFilter) {
    List<BonusePay> tempList = _bonusePaysView
        .where((expense) => expense.title.contains(searchFilter))
        .toList();
    return tempList;
  }

  BonusePay findById(String id) {
    BonusePay bonuse = _bonusePays.firstWhere((bonuse) => bonuse.id == id);
    return bonuse;
  }

  void _checkFilterAndUpdateOverView(BonusePay bonuse,
      [bool requiresUpdate = false]) {
    if (UserDataProvider.timeFilter == UserTimeFilter.all) {
      _bonusePays.add(bonuse);
      notifyListeners();
      return;
    } else if (UserDataProvider.timeFilter == UserTimeFilter.year) {
      if (bonuse.payDate.year == DateTime.now().year) {
        _bonusePays.add(bonuse);
        notifyListeners();
        return;
      }
    } else if (UserDataProvider.timeFilter == UserTimeFilter.month) {
      if (bonuse.payDate.month == DateTime.now().month &&
          bonuse.payDate.year == DateTime.now().year) {
        _bonusePays.add(bonuse);
        notifyListeners();
      }
    }
    if (requiresUpdate) notifyListeners();
  }
}
