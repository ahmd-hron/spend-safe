import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../helper/utilities.dart';
import '../helper/db_helper.dart';
import '../helper/date.dart';

enum UserTimeFilter { month, year, all }

class UserDataProvider with ChangeNotifier {
  static UserTimeFilter? timeFilter = UserTimeFilter.all;
  bool _showLetters = true;
  bool? _shouldShowTutrial;

  bool get showLetters {
    return _showLetters;
  }

  bool get shouldShowFirstTutrial {
    if (_shouldShowTutrial == null) return false;
    return _shouldShowTutrial!;
    // return _shouldShowTutrial != null && _shouldShowTutrial == true;
  }

  void stopShowingTutrial() {
    // print('no more salary tutial for this dude');
    _shouldShowTutrial = false;
  }

  static String? currency;
  bool? isNewUser;
  UserData user = UserData(
    id: 'null',
    name: 'unKnown',
    lastAddedSalaryDate: null,
    currency: 'SYP',
    salary: 0,
  );
  static Future<SharedPreferences> sharedPref() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    return sharedPref;
  }

  UserData get currentUser {
    return user;
  }

  double get userSalary {
    return (user.salary);
  }

  Future saveUserData(String name, double salary) async {
    //this method just add salary for the very first time only
    addNewUserSalary(salary);
    final userSavedData = await SharedPreferences.getInstance();
    String userId = DateTime.now().toIso8601String();

    final userData = json.encode({
      'name': name,
      'salary': salary,
      'lastAddedSalaryDate': DateTime.now().toIso8601String(),
      'userId': userId,
      'currency': currency,
    });
    userSavedData.setString('userData', userData);
    notifyListeners();
  }

  void addNewUserSalary(double salary) {
    if (isNewUser == true) {
      DataBaseHelper.insertInBalance({
        'id': DateTime.now().toIso8601String(),
        'title': '${Date.getMonthName(DateTime.now().month)} Salary',
        'amount': salary,
        'decription': 'Month Salary for ${DateTime.now().month} month',
        'date': DateTime.now().toIso8601String(),
      });
    }
  }

//user only get to pass veryfirst page isNewUser is false and userDevice dose contain
// userData Key
//this method is the very first method to get called before building the app
  Future getUserData() async {
    await Tutrial.fetchTutrialKeys();

    // print(
    //     'value of firstExpense load is ${Tutrial.firstTimeInExpenseValue} \n value of first BonuseLoad is ${Tutrial.firstTimeInExpenseValue}');
    final userSavedData = await SharedPreferences.getInstance();
    if (userSavedData.containsKey('userData')) {
      Map<String, dynamic> info = json
          .decode(userSavedData.getString('userData')!) as Map<String, dynamic>;
      user = UserData(
        id: info['userId'],
        name: info['name'],
        lastAddedSalaryDate: info['lastAddedSalaryDate'],
        salary: info['salary'],
        currency: info['currency'],
      );
      _checkLastSalaryDate(user);

      isNewUser = false;
      currency = user.currency;
      await getFilter();
      await getFormater();
    } else {
      isNewUser = true;
      _shouldShowTutrial = true;
    }
  }

  Future _checkLastSalaryDate(UserData user) async {
    if (user.lastAddedSalaryDate == null) {
      return;
    }
    final lastUpdatedDate = DateTime.parse(user.lastAddedSalaryDate!);
    final currentTime = DateTime.now();
    if (lastUpdatedDate.month != currentTime.month ||
        lastUpdatedDate.year != currentTime.year) {
      await _addThisMonthSalary(user, currentTime);
    }
  }

  Future _addThisMonthSalary(UserData user, DateTime currentDate) async {
    DataBaseHelper.insertInBalance({
      'id': DateTime.now().toIso8601String(),
      'title': '${Date.getMonthName(DateTime.now().month)} Salary',
      'amount': user.salary,
      'decription': 'Month Salary for ${currentDate.month} month',
      'date': DateTime.now().toIso8601String(),
    });
    await saveUserData(user.name, user.salary);
  }

  changeTimerFilter(UserTimeFilter filter) {
    // print('the filter provided is $filter');
    timeFilter = filter;
    notifyListeners();
  }

  Future saveFilter(UserTimeFilter filter) async {
    final SharedPreferences userPref = await SharedPreferences.getInstance();
    userPref.setString('filter', Utilities.toUsefulString(filter));
    timeFilter = filter;
    notifyListeners();
  }

  Future getFilter() async {
    final SharedPreferences userPref = await SharedPreferences.getInstance();
    if (userPref.getString('filter') == null) {
      saveFilter(timeFilter!);
    } else
      timeFilter = Utilities.toUsefulEnum(userPref.getString('filter')!);
  }

  Future saveFormater(bool value) async {
    final SharedPreferences userPref = await SharedPreferences.getInstance();
    userPref.setBool('show Letters', value);
    _showLetters = value;
  }

  Future getFormater() async {
    final SharedPreferences userPref = await SharedPreferences.getInstance();
    if (userPref.getBool('show Letters') == null) {
      saveFormater(_showLetters);
    } else
      _showLetters = userPref.getBool('show Letters')!;
  }
}

class UserData {
  final String id;
  final String name;
  final String? lastAddedSalaryDate;
  final double salary;
  final String currency;
  const UserData({
    required this.id,
    required this.name,
    required this.lastAddedSalaryDate,
    required this.salary,
    required this.currency,
  });
}

class Tutrial {
  static const String firstTimeInExpenseKey = 'first time in epxense';
  static const String firstTimeInBonuseKey = 'first time in bonuse';

  static bool firstTimeInExpenseValue = true;
  static bool firstTimeInBonuseValue = true;

  static Future fetchTutrialKeys() async {
    final SharedPreferences userPref = await SharedPreferences.getInstance();
    if (userPref.containsKey('saved tutrial info')) {
      Map<String, dynamic> info =
          json.decode(userPref.getString('saved tutrial info')!)
              as Map<String, dynamic>;
      // print('found the extracted date which is $info');
      if (info[firstTimeInExpenseKey] != null)
        firstTimeInExpenseValue = info[firstTimeInExpenseKey]!;
      if (info[firstTimeInBonuseKey] != null)
        firstTimeInBonuseValue = info[firstTimeInBonuseKey]!;
      // print('loaded');
    }
  }

  static Future saveTutrialValues(bool expense, bool bonuse) async {
    final SharedPreferences userPref = await SharedPreferences.getInstance();
    userPref.setString(
      'saved tutrial info',
      json.encode(
        {firstTimeInExpenseKey: expense, firstTimeInBonuseKey: bonuse},
      ),
    );
    // print('saved data is ${json.encode(
    //   {firstTimeInExpenseKey: expense, firstTimeInBonuseKey: bonuse},
    // )}');
    firstTimeInExpenseValue = expense;
    firstTimeInBonuseValue = bonuse;
  }
}
