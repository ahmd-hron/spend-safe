import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/bonuse_pay_provider.dart';
import '../providers/expence_provider.dart';

import '../providers/user_data.dart';
import '../helper/theme_colors.dart';
import '../helper/utilities.dart';
import '../helper/validator.dart';

import '../widgets/drop_down_currency_menu.dart';
import '../widgets/salary_overview_filter.dart';

import '../providers/local_provider.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = '/page-settings';
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _nameController = TextEditingController();
  final _salaryController = TextEditingController();
  AppLocalizations? apploccazition;
  bool _bottomShietIsUp = false;
  String? languageValu;
  LocalProvider? localProv;
  bool didSetCorrectLang = false;

  Orientation? ori;
  final paddeing = Padding(padding: EdgeInsets.symmetric(vertical: 10));

  @override
  void initState() {
    super.initState();
    localProv = Provider.of<LocalProvider>(context, listen: false);
    didSetCorrectLang = false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  void changeSettingLan() {
    languageValu = localProv!.localToString(context);
    didSetCorrectLang = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (!didSetCorrectLang) changeSettingLan();
    if (_bottomShietIsUp) {
      if (MediaQuery.of(context).orientation == Orientation.landscape)
        Navigator.of(context).pop();
    }
    _bottomShietIsUp = false;
    apploccazition = AppLocalizations.of(context);
    ori = MediaQuery.of(context).orientation;
    final userProvider = Provider.of<UserDataProvider>(context);

    return Scaffold(
      //this line prevent buttons scrolling up with keyboard
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Center(child: Text(apploccazition!.settings)),
        backgroundColor: ThemeColors.darkBlue,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () => _save(userProvider),
              icon: const Icon(Icons.save),
              color: ThemeColors.grey,
            ),
          ),
        ],
      ),
      body: Column(children: [
        Expanded(
          child: Container(
            // margin: EdgeInsets.only(right: 10, left: 10),
            //higher column part
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // name change field
                Padding(padding: const EdgeInsets.only(top: 10)),
                _buildListTile(
                  Icons.account_circle_outlined,
                  apploccazition!.nameText(userProvider.user.name),
                  () => _showEditeBox(
                    _nameController,
                    apploccazition!.changeName,
                    userProvider.user.name,
                    () => _confirmNameInput(userProvider),
                  ),
                ),
                paddeing,
                //salary change field
                _buildListTile(
                  Icons.monetization_on_outlined,
                  apploccazition!
                      .salaryText(userProvider.user.salary.toString()),
                  () => _showEditeBox(
                    _salaryController,
                    apploccazition!.salaryChange,
                    userProvider.user.salary.toString(),
                    () => _confirmSalaryInput(userProvider),
                  ),
                ),
                paddeing,
                //currency change field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    tileColor: Colors.grey.shade200,
                    leading: Text(
                      apploccazition!.currency,
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: DropDownCurrencyMenu(
                      value:
                          ' ${Utilities.toUsefulString(UserDataProvider.currency)}      ',
                      elevation: 4,
                      height: 50,
                      menuMaxheight: 350,
                      icon: Icons.expand_more,
                    ),
                  ),
                ),
                paddeing,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    tileColor: Colors.grey.shade200,
                    leading: Text(
                      apploccazition!.overviewFilter,
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: SalaryOverViewFilter(),
                  ),
                ),
                paddeing,

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    tileColor: Colors.grey.shade200,
                    leading: Text(
                      apploccazition!.language,
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: DropdownButton<String>(
                      isDense: true,
                      elevation: 4,
                      menuMaxHeight: 150,

                      //Get local From Saved Language and display it here
                      value: languageValu,
                      items: _dropDownLanguageButtom(),
                      onChanged: (value) {
                        setState(() {
                          languageValu = value!;
                        });
                      },
                    ),
                  ),
                ),
                paddeing,
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  width: double.maxFinite,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.grey.shade200,
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('200000', style: (TextStyle(fontSize: 18))),
                        Spacer(),
                        Switch.adaptive(
                          value: userProvider.showLetters,
                          onChanged: (value) => setState(() {
                            userProvider.saveFormater(value);
                          }),
                        ),
                        Spacer(),
                        Text('200K', style: (TextStyle(fontSize: 18)))
                      ]),
                ),
                paddeing,
              ],
            ),
          ),
        ),
        //lower save button
        Container(
          width: double.maxFinite,
          child: ElevatedButton(
            // clipBehavior: Clip,
            onPressed: () => _save(userProvider),
            child: Text(apploccazition!.save),
            style: ElevatedButton.styleFrom(
              primary: ThemeColors.darkBlue,
              elevation: 1,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildListTile(
      IconData leadingIcon, String title, Function onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListTile(
        minVerticalPadding: 0,
        leading: Icon(leadingIcon),
        title: Text(title),
        trailing: IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () => onPressed(),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        tileColor: Colors.grey.shade200,
      ),
    );
  }

  _showEditeBox(TextEditingController controller, String title, String hintText,
      Function confirm) {
    if (ori == Orientation.landscape)
      showDialog(
        context: context,
        builder: (ctx) => SingleChildScrollView(
          child: Dialog(
            elevation: 3,
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: _EditSettingsContainer(
                title: title,
                controller: controller,
                height: MediaQuery.of(context).size.height * 0.5,
                hintText: hintText,
                confirm: confirm,
              ),
            ),
          ),
        ),
      );
    else {
      _bottomShietIsUp = true;
      showModalBottomSheet(
        //this line help the bottom sheet scroll up with the keyboard
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (ctx) => SingleChildScrollView(
          child: Padding(
              //THIS LINE RIGHT HERE MAKE THE BOTTOM SHEET SCROLL UP WITH KEYBOARD
              padding: MediaQuery.of(context).viewInsets,
              child: _EditSettingsContainer(
                confirm: confirm,
                title: title,
                hintText: hintText,
                controller: controller,
                height: MediaQuery.of(context).size.height * 0.32,
              )),
        ),
      );
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(apploccazition!.error),
        content: Text(errorMessage),
        actions: [
          TextButton(
            child: Text(apploccazition!.ok),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Future _confirmNameInput(UserDataProvider userProvider) async {
    //check if the userInput is valied
    if (Validator.nameValidator(_nameController.text, apploccazition) == null) {
      await userProvider.saveUserData(
        _nameController.text,
        userProvider.user.salary,
      );
      Navigator.of(context).pop();
    } else
      _showErrorDialog(
          Validator.nameValidator(_nameController.text, apploccazition)!);
  }

  Future _confirmSalaryInput(UserDataProvider userProvider) async {
    if (Validator.amountValidator(_salaryController.text, apploccazition) ==
        null) {
      await userProvider.saveUserData(
        userProvider.user.name,
        double.parse(_salaryController.text),
      );
      Navigator.of(context).pop();
    } else
      _showErrorDialog(
          Validator.amountValidator(_salaryController.text, apploccazition)!);
  }

  void _save(
    UserDataProvider prov,
  ) async {
    Locale local = Locale(stringToLocal(languageValu!));
    prov.saveUserData(prov.user.name, prov.user.salary);
    if (SalaryOverViewFilter.filter != null &&
        UserDataProvider.timeFilter != SalaryOverViewFilter.filter) {
      prov.saveFilter(SalaryOverViewFilter.filter!);
      await Provider.of<ExpenseProvider>(context, listen: false)
          .updateProvider(SalaryOverViewFilter.filter!, true);
      await Provider.of<BonusePayProvider>(context, listen: false)
          .updateProvider();
    }
    if (localProv!.locale != local) localProv!.setLocal(local);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(apploccazition!.changeSaved),
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownLanguageButtom() {
    return [
      DropdownMenuItem(
        child: Text('English'),
        value: 'English',
      ),
      DropdownMenuItem(
        child: Text('Arabic'),
        value: 'Arabic',
      )
    ];
  }

  String stringToLocal(String value) {
    if (value == 'English')
      return 'en';
    else
      return 'ar';
  }
}

class _EditSettingsContainer extends StatelessWidget {
  final double height;
  final TextEditingController controller;
  final String hintText;
  final String title;
  final Function confirm;
  _EditSettingsContainer({
    required this.title,
    required this.controller,
    required this.height,
    required this.hintText,
    required this.confirm,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          //overall modalSheetContainer
          Container(
            height: 50,
            width: double.maxFinite,
            alignment: Alignment.bottomCenter,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
          // inputTextField
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 5,
                ),
                hintText: hintText,
              ),
            ),
          ),
          //bottons low row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              TextButton(
                //this method calls userProvider and rebuild the entire app
                onPressed: () => confirm(),
                child: Text(AppLocalizations.of(context)!.ok),
              )
            ],
          )
        ],
      ),
    );
  }
}
