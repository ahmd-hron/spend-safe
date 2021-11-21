import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../icons/spend_safe_icon_icons.dart';

import '../providers/user_data.dart';
import '../helper/theme_colors.dart';
import '../helper/validator.dart';

import '../widgets/drop_down_currency_menu.dart';
import '../widgets/elevated_gradient_button.dart';

class NewUserPage extends StatefulWidget {
  static const String routeName = '/new-user-page';
  @override
  _NewUserPageState createState() => _NewUserPageState();
}

class _NewUserPageState extends State<NewUserPage> {
  final nameController = TextEditingController();
  final salaryController = TextEditingController();
  final _form = GlobalKey<FormState>();

  String userName = '';
  double userSalary = 0.0;
  String? selectedCurrency;
  Size? appSize;

  AppLocalizations? appl;

  Future _save() async {
    bool validate = _form.currentState!.validate();

    if (validate) {
      selectedCurrency = UserDataProvider.currency;
      if (selectedCurrency == null) {
        _showErrorDialog();
        return;
      }
      _form.currentState!.save();
      await Provider.of<UserDataProvider>(context, listen: false)
          .saveUserData(userName, userSalary);
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    appl = AppLocalizations.of(context);
    appSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Center(
            child: Text(
          nameController.text.isEmpty ? appl!.newUser : nameController.text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            shadows: const <Shadow>[
              Shadow(
                offset: Offset(-3.3, -3.0),
                blurRadius: 50,
                color: Color.fromRGBO(255, 255, 255, 0.5),
              ),
            ],
          ),
        )),
        backgroundColor: ThemeColors.darkBlue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Form(
                key: _form,
                child: Column(
                  children: [
                    //name
                    customTextField(
                        accountTextField(), SpendSafeIcon.new_user_icon, 35),
                    const Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5)),
                    //salary
                    customTextField(
                        salaryTextField(), Icons.monetization_on_rounded, 40),
                    //currency
                    const Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5)),
                    DropDownCurrencyMenu(
                      value: appl!.rigeonCurrency,
                      icon: Icons.monetization_on_sharp,
                      height: 50,
                      menuMaxheight: 350,
                      elevation: 4,
                    ),
                    startButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget startButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: RaisedGradientButton(
          borderRadius: 50,
          width: appSize!.width * 0.35,
          decorication: BoxDecoration(
            border: Border.all(width: 2, color: ThemeColors.darkBlue),
            gradient: ThemeColors.lightBlueGradient,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            appl!.start,
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          onPressed: () => _save()),
    );
  }

  Widget customTextField(Widget textField, IconData icon, double iconSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 3,
        child: SizedBox(
          height: 75,
          width: double.maxFinite,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    icon,
                    size: iconSize,
                    color: ThemeColors.darkBlue,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: VerticalDivider(
                    color: Colors.black26,
                    width: 10,
                  ),
                ),
                SizedBox(width: 280, child: textField),
              ]),
        ),
      ),
    );
  }

  Widget accountTextField() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: appl!.enterName,
      ),
      textInputAction: TextInputAction.next,
      validator: (value) => Validator.nameValidator(value, appl),
      onChanged: (dsa) => setState(() {}),
      onSaved: (value) => userName = value!,
      controller: nameController,
    );
  }

  Widget salaryTextField() {
    return TextFormField(
      controller: salaryController,
      decoration: InputDecoration(
          border: InputBorder.none, labelText: appl!.monthSalary),
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) return appl!.nullSalary;
        if (double.tryParse(value) == null) return appl!.nullNumber;
        if (double.parse(value) < 0) return appl!.negativeNumber;
        return null;
      },
      onSaved: (value) => userSalary = double.parse(value!),
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(appl!.currencyAlert),
        actions: [
          TextButton(
            child: Text(appl!.start),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }
}
