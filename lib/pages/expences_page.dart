import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../icons/spend_safe_icon_icons.dart';

import '../providers/expence_provider.dart';
import '../providers/user_data.dart';

import '../widgets/expence_item.dart';

import '../helper/theme_colors.dart';
import '../helper/date.dart';
import '../helper/tutrial_dialog.dart';

import '../models/expense.dart';

import '../pages/tutrial_page.dart';

import '../pages/add_expense_page.dart';

class ExpensesPage extends StatefulWidget {
  static const String routeName = '/expense-page';

  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  AppLocalizations? _appL;
  bool _isTyping = false;
  UserTimeFilter _filter = UserTimeFilter.month;
  List<Expense> _tempExpense = [];
  Size? appSize;
  bool _alreadyHaveTutrial = false;

  @override
  Widget build(BuildContext context) {
    _appL = AppLocalizations.of(context);

    final ori = MediaQuery.of(context).orientation;
    appSize = MediaQuery.of(context).size;
    //show tutrial
    if (Tutrial.firstTimeInExpenseValue && !_alreadyHaveTutrial) {
      Future.delayed(Duration(milliseconds: 1500)).then(
        (value) => Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (ctx, s, _) => TutrialPage(
              content: TutrialDialog.expensePage(ctx),
              expense: false,
            ),
            transitionDuration: Duration(milliseconds: 100),
          ),
        ),
      );
      _alreadyHaveTutrial = true;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: ThemeColors.darkRed,
        title: _isTyping
            ? _buildTextSearchField()
            : Text(_appL!.monthExpense(
                Date.getMonthName(DateTime.now().month, context: context))),
        actions: [
          IconButton(
              onPressed: () async {
                //on pressed tempExpense get assigned a value
                _tempExpense =
                    Provider.of<ExpenseProvider>(context, listen: false)
                        .userExpenxeView;
                setState(
                  () {
                    _isTyping = true;
                  },
                );
              },
              icon: Icon(SpendSafeIcon.search__icon)),
          PopupMenuButton(
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Text(_appL!.all),
                value: UserTimeFilter.all,
              ),
              PopupMenuItem(
                child: Text(_appL!.thisMonth),
                value: UserTimeFilter.month,
              ),
              PopupMenuItem(
                child: Text(_appL!.thisYear),
                value: UserTimeFilter.year,
              ),
            ],
            onSelected: (value) async {
              if (value == UserTimeFilter.all)
                setState(() {
                  _filter = UserTimeFilter.all;
                  _isTyping = false;
                });
              else if (value == UserTimeFilter.month) {
                setState(() {
                  _filter = UserTimeFilter.month;
                  _isTyping = false;
                });
              } else if (value == UserTimeFilter.year) {
                setState(() {
                  _filter = UserTimeFilter.year;
                  _isTyping = false;
                });
              }
            },
          )
        ],
      ),
      // build the list
      body: Consumer<ExpenseProvider>(
        builder: (_, provider, __) => FutureBuilder(
          future: provider.totalFiltered(_filter),
          builder: (ctx, snapShot) =>
              snapShot.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        if (ori == Orientation.portrait)
                          ..._buildPortritMode(provider),
                        if (ori == Orientation.landscape)
                          Expanded(
                            child: Container(
                              height: appSize!.height * 0.8,
                              child: _itemsList(provider),
                            ),
                          ),
                      ],
                    ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).pushNamed(AddExpensePage.routeName),
        splashColor: ThemeColors.darkRed,
        child: Icon(
          SpendSafeIcon.plus_icon,
          color: Colors.white,
          size: 35,
        ),
        backgroundColor: ThemeColors.darkRed,
      ),
    );
  }

  List<Widget> _buildPortritMode(ExpenseProvider provider) {
    return [
      Container(
        height: appSize!.height * 0.82,
        child: _itemsList(provider),
      ),
      _buildTotalExpenseAmount(provider),
    ];
  }

  Widget _itemsList(ExpenseProvider provider) {
    return ListView.builder(
      itemCount:
          _isTyping ? _tempExpense.length : provider.userExpenxeView.length,
      itemBuilder: (ctx, i) => _isTyping
          ? ExpenceItem(_tempExpense[i])
          : ExpenceItem(provider.userExpenxeView[i]),
    );
  }

//return the total amount of the viewed expenses
  double totalExpense(List<Expense> expenseList) {
    double total = 0.0;
    expenseList.forEach((expense) {
      total += expense.amount;
    });
    return total;
  }

// build the search bar in title widget once pressed on search icon
  Widget _buildTextSearchField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.white,
      ),
      clipBehavior: Clip.none,
      margin: const EdgeInsets.symmetric(vertical: 50),
      child: TextField(
        decoration: InputDecoration(
          fillColor: Colors.white,
          focusColor: Colors.white,
          hoverColor: Colors.white,
          hintText: _appL!.searchText,
        ),
        textInputAction: TextInputAction.done,
        onChanged: (value) => setState(() {
          _tempExpense = Provider.of<ExpenseProvider>(context, listen: false)
              .filterSearch(value);
        }),
        onSubmitted: (value) {},
      ),
    );
  }

  // build the total widget
  Widget _buildTotalExpenseAmount(ExpenseProvider provider) {
    return Expanded(
      child: Container(
        height: appSize!.height * 0.1,
        width: appSize!.width,
        decoration: BoxDecoration(color: ThemeColors.darkRed),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 25),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            _isTyping
                ? '${_appL!.total(totalExpense(_tempExpense).toString())} ${UserDataProvider.currency}'
                : '${_appL!.total(totalExpense(provider.userExpenxeView).toString())} ${UserDataProvider.currency}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
            ),
          ),
          // Text(
          //   _isTyping
          //       ? '${totalExpense(_tempExpense)}'
          //       : '${totalExpense(provider.userExpenxeView)}',
          //   style: TextStyle(
          //     color: Colors.white,
          //     fontSize: 20,
          //   ),
          // ),
        ]),
      ),
    );
  }

  void test() {
    OverlayEntry(
        builder: (ctx) => Container(
              width: 300,
              height: 300,
              color: Colors.red,
            ));
  }
}
