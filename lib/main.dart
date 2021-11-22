import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import './l10n/l10n.dart';

import './providers/user_data.dart';
import './providers/bonuse_pay_provider.dart';
import './providers/expence_provider.dart';
import './providers/total_user_balance.dart';
import './providers/local_provider.dart';

import './pages/welcome_page.dart';
import './pages/salary_overview_page.dart';
import './pages/expences_page.dart';
import './pages/add_balnce_page.dart';
import './pages/add_expense_page.dart';
import './pages/bounse_pay_page.dart';
import './pages/new_user_page.dart';
import './pages/setting.dart';
import 'pages/transparent_details_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //app rebuilt
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => UserDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => BonusePayProvider()..updateProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ExpenseProvider()..updateProvider(),
        ),
        ChangeNotifierProxyProvider3<UserDataProvider, BonusePayProvider,
            ExpenseProvider, TotalUserBalanceProvider>(
          create: (ctx) => TotalUserBalanceProvider(),
          update: (_, myUserInfo, myUserBalance, myUserExpense, my) =>
              TotalUserBalanceProvider()
                ..updateProvider(
                  myUserInfo.userSalary,
                  myUserBalance.totalMonthBounse,
                  myUserExpense.totalMonthExpence,
                ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => LocalProvider(),
        )
      ],
      child: Consumer<LocalProvider>(builder: (ctx, localProv, _) {
        return FutureBuilder(
            future: localProv.getLang(),
            builder: (ctx, snpShot) {
              if (snpShot.connectionState == ConnectionState.waiting)
                return LoadingMain();
              if (snpShot.connectionState == ConnectionState.done)
                return MaterialApp(
                  locale: localProv.locale,
                  //to support multi language we need this
                  localizationsDelegates: [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: L10n.all,
                  title: 'spend safe',
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                    secondaryHeaderColor: Colors.white,
                    // fontFamily: "Raleway",
                  ),

                  home: Consumer<UserDataProvider>(
                    builder: (ctx, userDataProvider, _) => FutureBuilder(
                      future: userDataProvider.getUserData(),
                      builder: (ctx, snapShot) {
                        if (snapShot.connectionState == ConnectionState.waiting)
                          return (Loading());
                        else if (snapShot.connectionState ==
                            ConnectionState
                                .done) if (userDataProvider.isNewUser!)
                          return WelcomPage();
                        return SalaryOverviewPage();
                      },
                    ),
                  ),
                  routes: {
                    // WelcomPage.routeName: (ctx) => WelcomPage(),
                    NewUserPage.routeName: (ctx) => NewUserPage(),
                    ExpensesPage.routeName: (ctx) => ExpensesPage(),
                    AddBalancePage.routeName: (ctx) => AddBalancePage(),
                    AddExpensePage.routeName: (ctx) => AddExpensePage(),
                    BonusePayPage.routeName: (ctx) => BonusePayPage(),
                    SettingsPage.routeName: (ctx) => SettingsPage(),
                    TransparentDetailsPage.routeName: (ctx) =>
                        TransparentDetailsPage(),
                  },
                );
              return LoadingMain();
            });
      }),
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: const Text('loading...')),
    );
  }
}

class LoadingMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Loading(),
    );
  }
}
