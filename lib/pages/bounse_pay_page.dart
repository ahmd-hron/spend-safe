import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/bounsePay.dart';

import '../widgets/bonuse_balance_item.dart';

import '../providers/user_data.dart';
import '../providers/bonuse_pay_provider.dart';

import '../helper/theme_colors.dart';
import '../helper/date.dart';
import '../helper/tutrial_dialog.dart';

import '../icons/spend_safe_icon_icons.dart';

import '../pages/add_balnce_page.dart';
import '../pages/tutrial_page.dart';

class BonusePayPage extends StatefulWidget {
  static const String routeName = '/bonuse-pay-Page';

  @override
  _BonusePayPageState createState() => _BonusePayPageState();
}

class _BonusePayPageState extends State<BonusePayPage> {
  UserTimeFilter _filter = UserTimeFilter.month;
  bool _isTyping = false;
  List<BonusePay> _tempBonuse = [];
  AppLocalizations? _appL;
  bool _alreadyHaveTutrial = false;

  @override
  Widget build(BuildContext context) {
    _appL = AppLocalizations.of(context);

    if (Tutrial.firstTimeInBonuseValue && !_alreadyHaveTutrial) {
      Future.delayed(Duration(milliseconds: 1500)).then(
        (value) => Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (ctx, s, _) => TutrialPage(
              content: TutrialDialog.expensePage(ctx),
              bonuse: false,
            ),
            transitionDuration: Duration(milliseconds: 100),
          ),
        ),
      );
      _alreadyHaveTutrial = true;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColors.green,
        actions: [
          //search button
          IconButton(
              onPressed: () async {
                _tempBonuse =
                    Provider.of<BonusePayProvider>(context, listen: false)
                        .viewBonusePays;
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
        title: _isTyping
            ? _buildTextSearchField()
            : Text(_appL!.monthIncome(
                Date.getMonthName(DateTime.now().month, context: context))),
      ),
      body: Consumer<BonusePayProvider>(builder: (_, prov, __) {
        return FutureBuilder(
          future: prov.totalFiltered(_filter),
          builder: (ctx, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapShot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount:
                    _isTyping ? _tempBonuse.length : prov.viewBonusePays.length,
                itemBuilder: (ctx, i) => _isTyping
                    ? BonuseBalanceItem(_tempBonuse[i])
                    : BonuseBalanceItem(prov.viewBonusePays[i]),
              );
            } else
              return const Text('something went wrong');
          },
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).pushNamed(AddBalancePage.routeName),
        splashColor: ThemeColors.darkRed,
        child: Icon(
          SpendSafeIcon.plus_icon,
          color: Colors.white,
          size: 35,
        ),
        backgroundColor: ThemeColors.green,
      ),
    );
  }

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
          _tempBonuse = Provider.of<BonusePayProvider>(context, listen: false)
              .filterSearch(value);
        }),
        onSubmitted: (value) => _isTyping = false,
      ),
    );
  }
}
