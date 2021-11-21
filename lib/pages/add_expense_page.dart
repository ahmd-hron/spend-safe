import 'package:flutter/material.dart';

import '../widgets/add_expense_form.dart';
import '../helper/theme_colors.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddExpensePage extends StatelessWidget {
  static String routeName = '/add-expense-page';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addBalance),
        backgroundColor: ThemeColors.darkRed,
      ),
      body: AddExpenseForm(),
    );
  }
}
