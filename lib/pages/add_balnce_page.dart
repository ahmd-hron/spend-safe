import 'package:flutter/material.dart';

import '../widgets/add_balance_form.dart';

import '../helper/theme_colors.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddBalancePage extends StatelessWidget {
  static String routeName = '/addBalance-page';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: ThemeColors.darkBlue,
        title: Text(AppLocalizations.of(context)!.addBalance),
      ),
      body: AddBalanceForm(),
    );
  }
}
