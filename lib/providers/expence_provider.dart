import 'package:flutter/foundation.dart';

import '../models/expense.dart';
import '../helper/db_helper.dart';
import '../providers/user_data.dart';

import '../helper/utilities.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];
  List<Expense> _expenseView = [];

  double get totalMonthExpence {
    double total = 0;
    _expenses.forEach((element) {
      total += element.amount;
    });
    return total;
  }

  List<Expense> get userExpenxe {
    return [..._expenses.reversed];
  }

  List<Expense> get userExpenxeView {
    return [..._expenseView.reversed];
  }

  Future updateProvider(
      [UserTimeFilter f = UserTimeFilter.all, bool requiredF = false]) async {
    if (requiredF)
      await getUserExpense(f);
    else
      await getUserExpense(UserDataProvider.timeFilter!);
    notifyListeners();
  }

  Future getUserExpense([UserTimeFilter filter = UserTimeFilter.all]) async {
    _expenses = await _readAllExpense(filter);
  }

  Future<double> totalFiltered(UserTimeFilter filter) async {
    double total = 0.0;
    _expenseView = await _readAllExpense(filter);
    if (_expenseView.length <= 0) {
      return 0.0;
    }
    _expenseView.forEach((bounse) {
      total += bounse.amount;
    });
    return total;
  }

  //return search based on category name listed or item title
  List<Expense> filterSearch(String searchFilter) {
    List<Expense> tempList = _expenseView
        .where(
          (expense) =>
              expense.title.contains(searchFilter) ||
              Utilities.toUsefulString(expense.expenseCategory)
                  .contains(searchFilter),
        )
        .toList();
    return tempList;
  }

  Future addExpence(double amount, String title, String decription,
      DateTime date, ExpenseCategory expenseCategory) async {
    await DataBaseHelper.insertExpense({
      'id': date.toIso8601String(),
      'title': title,
      'amount': amount,
      'decription': decription,
      'date': date.toIso8601String(),
      'category': Utilities.toUsefulString(expenseCategory),
    });
    final expense = Expense(
      amount: amount,
      id: date.toIso8601String(),
      title: title,
      decription: decription,
      date: date,
      expenseCategory: expenseCategory,
    );
    _checkFilterAndUpdateOverView(expense);
  }

  void removeExpence(String id) {
    int i = _expenses.indexWhere((expense) => expense.id == id);
    if (i >= 0) {
      _expenses.remove(_expenses[i]);
      notifyListeners();
    }
    DataBaseHelper.deleteFromTable(DataBaseHelper.expenseTable, id);
  }

  Future updateExpenses(String id, String title, double amount, DateTime date,
      ExpenseCategory category, String decription) async {
    var expense = Expense(
        id: id,
        title: title,
        decription: decription,
        amount: amount,
        date: date,
        expenseCategory: category);
    Map<String, dynamic> values = {
      'id': id,
      'title': title,
      'amount': amount,
      'decription': decription,
      'date': date.toIso8601String(),
      'category': Utilities.toUsefulString(category),
    };
    int i = _expenses.indexWhere((expense) => expense.id == id);
    if (i >= 0) _expenses.remove(_expenses[i]);
    _checkFilterAndUpdateOverView(expense, true);
    notifyListeners();
    DataBaseHelper.updateExpense(id, values);
  }

  Expense findById(String id) {
    Expense temp = _expenses.firstWhere((expense) => expense.id == id);
    return temp;
  }

  Future<List<Expense>> _readAllExpense(UserTimeFilter filter) async {
    final values = await DataBaseHelper.readExpenseTable();
    List<Expense> tempList = [];
    values.forEach((value) {
      Expense temp = (Expense(
        id: value['id'],
        title: value['title'],
        decription: value['decription'],
        amount: value['amount'],
        date: DateTime.parse(value['date']),
        expenseCategory: Expense.stringToCategory(value['category']),
      ));
      switch (filter) {
        case UserTimeFilter.all:
          tempList.add(temp);
          break;
        case UserTimeFilter.year:
          if (temp.date.year == DateTime.now().year) tempList.add(temp);
          break;
        case UserTimeFilter.month:
          if (temp.date.month == DateTime.now().month &&
              temp.date.year == DateTime.now().year) tempList.add(temp);
          break;
        default:
          tempList.add(temp);
      }
    });
    return tempList;
  }

  void _checkFilterAndUpdateOverView(Expense expense,
      [bool requiresUpdate = false]) {
    if (UserDataProvider.timeFilter == UserTimeFilter.all) {
      _expenses.add(expense);
      notifyListeners();
      return;
    } else if (UserDataProvider.timeFilter == UserTimeFilter.year) {
      if (expense.date.year == DateTime.now().year) {
        _expenses.add(expense);
        notifyListeners();
        return;
      }
    } else if (UserDataProvider.timeFilter == UserTimeFilter.month) {
      if (expense.date.month == DateTime.now().month &&
          expense.date.year == DateTime.now().year) {
        _expenses.add(expense);
        notifyListeners();
      }
    }
    if (requiresUpdate) notifyListeners();
  }
}
