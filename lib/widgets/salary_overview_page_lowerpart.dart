import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../icons/spend_safe_icon_icons.dart';

import '../helper/theme_colors.dart';

import '../providers/total_user_balance.dart';

import '../pages/add_balnce_page.dart';
import '../pages/add_expense_page.dart';

import '../icons/custome_icons_icons.dart';

class SalaryOverViewLowerPart extends StatelessWidget {
  final formatter = NumberFormat('###.0#');

  final bool _longDevice;
  SalaryOverViewLowerPart(this._longDevice);

  @override
  Widget build(BuildContext context) {
    final totalUserBalance = Provider.of<TotalUserBalanceProvider>(context);
    final appSize = MediaQuery.of(context).size;
    return Column(
      children: [
        _buildBalanceCard(
            context, totalUserBalance.remainingBalance.round(), appSize),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
        ),
        _buildAvgDaySpendText(context, totalUserBalance.avgDaySpend),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: appSize.width * 0.1),
          child: Divider(
            height: _longDevice ? appSize.height * 0.07 : appSize.height * 0.05,
            thickness: 2.5,
            color: Colors.black,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildButton(
                AppLocalizations.of(context)!.addBalance,
                SpendSafeIcon.plus_icon,
                ThemeColors.green,
                () =>
                    Navigator.of(context).pushNamed(AddBalancePage.routeName)),
            _buildButton(
              AppLocalizations.of(context)!.addExpense,
              CustomeIcons.minus,
              ThemeColors.darkRed,
              () => Navigator.of(context).pushNamed(AddExpensePage.routeName),
            )
          ],
        )
      ],
    );
  }

  Widget _buildBalanceCard(
      BuildContext context, int remainBalance, Size appSize) {
    return Card(
      color: ThemeColors.grey,
      margin: EdgeInsets.only(
        top: appSize.height * 0.05,
        right: appSize.width * 0.23,
        left: appSize.width * 0.23,
        bottom: appSize.height * 0.025,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: appSize.height * 0.01, horizontal: appSize.width * 0.03),
        child: Row(
          children: [
            Text(
              AppLocalizations.of(context)!.balance,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const Spacer(),
            Text(
              _balanceText(remainBalance),
              style: TextStyle(
                color:
                    remainBalance > 0 ? ThemeColors.green : ThemeColors.darkRed,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  String _balanceText(int remainBalance) {
    final shortFormater = NumberFormat.compact();
    if (remainBalance > 9999999 || remainBalance < -9999999)
      return '${shortFormater.format(remainBalance)}';
    return '${formatter.format(remainBalance)}';
  }

  Widget _buildAvgDaySpendText(BuildContext context, double averageSpend) {
    const double smallFontSize = 13;
    const double regularFontSize = 15;
    //you can spend amount of money rich text
    return RichText(
        text: TextSpan(children: [
      TextSpan(
        text: AppLocalizations.of(context)!.youCanSPend,
        style: TextStyle(
          color: Colors.black,
          fontSize: smallFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(
        text: '${formatter.format(averageSpend)}',
        style: TextStyle(
          color: averageSpend == 0 ? ThemeColors.darkRed : ThemeColors.green,
          fontSize: regularFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(
        text: AppLocalizations.of(context)!.everyDay,
        style: TextStyle(
          color: Colors.black,
          fontSize: _longDevice ? smallFontSize + 2 : smallFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    ]));
  }

  Widget _buildButton(
      String hintText, IconData icon, Color color, VoidCallback onPressed) {
    double buttonsSize = _longDevice ? 60 : 52;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          hintText,
          style: TextStyle(color: Colors.grey, fontSize: _longDevice ? 15 : 12),
        ),
        Padding(padding: const EdgeInsets.symmetric(vertical: 5)),
        RawMaterialButton(
          constraints: BoxConstraints(
            minHeight: buttonsSize,
            minWidth: buttonsSize,
          ),
          elevation: 2.0,
          fillColor: color,
          onPressed: onPressed,
          child: Icon(
            icon,
            color: Colors.white,
            size: _longDevice ? 45 : 40,
          ),
          shape: const CircleBorder(),
        )
      ],
    );
  }
}
