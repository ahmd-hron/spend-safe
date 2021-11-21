import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helper/theme_colors.dart';

import '../widgets/elevated_gradient_button.dart';
import './new_user_page.dart';

class WelcomPage extends StatefulWidget {
  static String routeName = '/welcome-page';

  @override
  State<WelcomPage> createState() => _WelcomPageState();
}

class _WelcomPageState extends State<WelcomPage> {
  Size? appSize;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: ThemeColors.lightBlueGradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: const EdgeInsets.symmetric(vertical: 20)),
            //welcome text small
            const Text(
              '   WELCOME TO   ',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            Padding(padding: const EdgeInsets.only(top: 15)),
            //Spend Text Huge
            const Text(
              'SP.END',
              style: TextStyle(
                color: Colors.white,
                fontSize: 55,
                // fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              '          S  A  F  E          ',
              style: TextStyle(color: Colors.white30, fontSize: 25),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            //stack with tow circles and logo
            _buildLogoWidget(context),
            Padding(padding: EdgeInsets.symmetric(vertical: 15)),
            //explain text
            const Text(
              'You don\'t have to worry about money from now on',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const Text('We got you covered.',
                style: TextStyle(color: Colors.white, fontSize: 14)),
            // get started button takes user to new user
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
            ),
            _buildStartButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoWidget(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: appSize!.height * 0.4,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white10,
      ),
      child: Container(
        alignment: Alignment.center,
        height: appSize!.height * 0.27,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white12,
        ),
        child: Container(
          height: appSize!.height * 0.20,
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return RaisedGradientButton(
      borderRadius: 50,
      width: appSize!.width * 0.6,
      decorication: BoxDecoration(
        border: Border.all(width: 2, color: ThemeColors.darkBlue),
        gradient: ThemeColors.lightBlueGradient,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        'Get Started',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      onPressed: () {
        Navigator.of(context).pushReplacementNamed(NewUserPage.routeName);
      },
    );
  }
}
