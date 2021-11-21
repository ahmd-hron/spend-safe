import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../api/local_notifcation.dart';

import '../helper/theme_colors.dart';
import '../helper/tutrial_dialog.dart';

import '../providers/user_data.dart';

import '../widgets/circle_spend_prograss.dart';
import '../widgets/salary_overview_page_lowerpart.dart';

import './expences_page.dart';
import './bounse_pay_page.dart';
import './setting.dart';
import '../pages/tutrial_page.dart';

class SalaryOverviewPage extends StatefulWidget {
  @override
  _SalaryOverviewPageState createState() => _SalaryOverviewPageState();
}

class _SalaryOverviewPageState extends State<SalaryOverviewPage> {
  bool? _longDevice;
  Size? _size;
  // ignore: unused_field
  AppLocalizations? _appLocal;
  UserDataProvider? userProvider;
  bool _alreadyHaveTutrial = false;
  Orientation? ori;

  @override
  void initState() {
    LocalNotification.init(initScheduled: true);
    super.initState();
    listenNotification();
    // schedular notification based on hour and minutes everyday of the week
    if (!LocalNotification.subScribedToNotifications) {
      Future.delayed(Duration(seconds: 1)).then(
        (value) => LocalNotification.showScheduledNotification(
          body: AppLocalizations.of(context)!.notificationBody,
          title: AppLocalizations.of(context)!.dailyReminderTitle,
          payload: '1',
          hour: 18,
          minutes: 45,
          notiDate: DateTime.now().add(Duration(seconds: 5)),
        ),
      );
      LocalNotification.subScribedToNotifications = true;
    }
  }

  void listenNotification() =>
      LocalNotification.onNotification.stream.listen(onCLickNotification);

  void onCLickNotification(String? payload) =>
      Navigator.of(context).pushNamed(ExpensesPage.routeName);

  @override
  Widget build(BuildContext context) {
    ori = MediaQuery.of(context).orientation;
    userProvider = Provider.of<UserDataProvider>(context);
    _appLocal = AppLocalizations.of(context);
    _longDevice = MediaQuery.of(context).size.height > 800;
    _size = MediaQuery.of(context).size;

    //show tutrial
    if (userProvider!.shouldShowFirstTutrial && !_alreadyHaveTutrial) {
      Future.delayed(Duration(milliseconds: 1300)).then(
        (value) => Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (ctx, s, _) => TutrialPage(
              content: TutrialDialog.salaryPage(ctx),
              saveSalaryPageChange: userProvider!.stopShowingTutrial,
              shouldShowButton: true,
            ),
            transitionDuration: Duration(milliseconds: 100),
          ),
        ),
      );
      _alreadyHaveTutrial = true;
    }

    return Scaffold(
      // backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            MainAppBar(_longDevice!),
            // SalaryOverViewFilter(),
            SizedBox(
              height:
                  _longDevice! ? _size!.height * 0.02 : _size!.height * 0.01,
            ),
            CircleSpendPrograss(
              ori == Orientation.portrait
                  ? _size!.height * 0.335
                  : _size!.width * 0.335,
            ),
            SizedBox(
              height:
                  _longDevice! ? _size!.height * 0.02 : _size!.height * 0.01,
            ),
            SalaryOverViewLowerPart(_longDevice!),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MainAppBar extends StatelessWidget {
  final bool longDevice;
  AppLocalizations? _appLocal;
  MainAppBar(this.longDevice);

  @override
  Widget build(BuildContext context) {
    final appSize = MediaQuery.of(context).size;
    final userData = Provider.of<UserDataProvider>(context).currentUser;
    final ori = MediaQuery.of(context).orientation;

    return SizedBox(
      height: appSize.height * 0.3,
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Container(
            width: appSize.width,
            height: appSize.height * 0.2,
            decoration: BoxDecoration(
              // color: Colors.white,
              gradient: ThemeColors.myBlueGradient,
              boxShadow: [
                const BoxShadow(
                  color: Color.fromRGBO(191, 175, 178, 00.5),
                  offset: Offset(3, 3),
                )
              ],
              borderRadius: const BorderRadius.only(
                bottomLeft: const Radius.circular(90),
                bottomRight: const Radius.circular(90),
              ),
            ),
          ),
          Positioned(
            bottom: appSize.height * 0.17,
            child: Container(
              height: appSize.height * 0.1,
              width: appSize.width * 0.6,
              child: _buildWelcomeUserText(userData, context),
            ),
          ),
          Positioned(
            bottom: ori == Orientation.portrait
                ? appSize.height * 0.067
                : appSize.height * 0.045,
            child: SizedBox(
              width: appSize.width * 0.85,
              child: _buildUpperButtonRow(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeUserText(UserData userData, BuildContext context) {
    _appLocal = AppLocalizations.of(context)!;
    final ori = MediaQuery.of(context).orientation;

    if (ori == Orientation.portrait)
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _appLocal!.welcome,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            height: MediaQuery.of(context).size.height * 0.05,
            child: FittedBox(
              fit: userData.name.length > 6 ? BoxFit.cover : BoxFit.none,
              child: Text(
                '${userData.name}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  shadows: const <Shadow>[
                    Shadow(
                      offset: Offset(0, -0),
                      blurRadius: 25,
                      color: Color.fromRGBO(255, 255, 255, 0.6),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    return SizedBox();
  }

  Widget _buildUpperButtonRow(BuildContext context) {
    Widget rawMatButton({
      required VoidCallback onPressed,
      required IconData icon,
      required Color iconColor,
      required Color splashColor,
    }) {
      return RawMaterialButton(
        constraints: BoxConstraints(
          minHeight: 55,
          minWidth: 55,
        ),
        elevation: 3,
        splashColor: splashColor,
        fillColor: Colors.white,
        onPressed: onPressed,
        child: Icon(
          icon,
          size: 35,
          color: iconColor,
        ),
        shape: const CircleBorder(),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        rawMatButton(
          onPressed: () =>
              Navigator.of(context).pushNamed(SettingsPage.routeName),
          icon: Icons.settings,
          iconColor: ThemeColors.darkBlue,
          splashColor: ThemeColors.darkBlue,
        ),
        RawMaterialButton(
          constraints: const BoxConstraints(
            minHeight: 65,
            minWidth: 65,
          ),
          elevation: 3,
          splashColor: ThemeColors.darkRed,
          fillColor: Colors.white,
          onPressed: () {
            Navigator.of(context).pushNamed(ExpensesPage.routeName);
          },
          child: Icon(
            Icons.payment_outlined,
            size: 35,
            color: Theme.of(context).primaryColor,
          ),
          shape: const CircleBorder(),
        ),
        rawMatButton(
          onPressed: () =>
              Navigator.of(context).pushNamed(BonusePayPage.routeName),
          icon: Icons.money_off_csred_outlined,
          iconColor: ThemeColors.darkBlue,
          splashColor: ThemeColors.brightGreen,
        ),
      ],
    );
  }
}
