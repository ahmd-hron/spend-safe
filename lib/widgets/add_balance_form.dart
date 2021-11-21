import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:spend_safe/icons/custome_icons_icons.dart';

import '../providers/bonuse_pay_provider.dart';

import '../helper/theme_colors.dart';
import '../helper/validator.dart';

import '../widgets/custome_text_field.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddBalanceForm extends StatefulWidget {
  @override
  _AddBalanceFormState createState() => _AddBalanceFormState();
  AddBalanceForm();
}

class _AddBalanceFormState extends State<AddBalanceForm> {
  final _form = GlobalKey<FormState>();
  var _titleController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _amountController = TextEditingController();

  final _titleFocus = FocusNode();
  final _amountFocus = FocusNode();
  final _detailsFocus = FocusNode();
  bool hasConfirmed = false;

  @override
  void dispose() {
    _titleFocus.dispose();
    _amountFocus.dispose();
    _detailsFocus.dispose();
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool _balanceExisted = false;
  bool _unique = true;

  String? id;
  double amount = 0.0;
  String title = '';
  String decription = '';
  DateTime? date;

  Orientation? ori;
  Size? appSize;
  AppLocalizations? _appL;

  bool get _validName {
    return Validator.nameValidator(_titleController.text, _appL) == null;
  }

  bool get _validAmount {
    return Validator.amountValidator(_amountController.text, _appL) == null;
  }

  void _save() {
    bool validate = _form.currentState!.validate();
    if (validate) {
      _form.currentState!.save();
      final bonuseProv = Provider.of<BonusePayProvider>(context, listen: false);
      if (date == null) date = DateTime.now();
      if (!_unique)
        bonuseProv.updateBonuse(id!, title, amount, decription, date!);
      else
        bonuseProv.addMonthBounse(amount, title, decription, date!);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    _appL = AppLocalizations.of(context);
    //_unique is only tru on first run
    if (_unique) _checkForExistingBalance();

    ori = MediaQuery.of(context).orientation;
    appSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Form(
            key: _form,
            child: SizedBox(
                height: ori == Orientation.portrait
                    ? appSize!.height * 0.6
                    : appSize!.height * 0.4,
                child: ori == Orientation.portrait
                    ? _portraitMode()
                    : _landscapMode()),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: ThemeColors.darkBlue,
              ),
              onPressed: _datePicker,
              child: Text(
                _appL!.dateSelect,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(children: [
              Spacer(),
              Container(
                width: double.maxFinite,
                child: ElevatedButton(
                  // clipBehavior: Clip,
                  onPressed: () => _save(),
                  child: Text(_appL!.saveAndExite),
                  style: ElevatedButton.styleFrom(
                    primary: ThemeColors.darkBlue,
                    elevation: 1,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }

  Widget _landscapMode() {
    return ListView(children: _formChildren());
  }

  Widget _portraitMode() {
    return Column(children: _formChildren());
  }

  Widget _titleTextField() {
    return TextFormField(
      controller: _titleController,
      focusNode: _titleFocus,
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: _appL!.title,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      ),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      validator: (value) => Validator.nameValidator(value, _appL),
      onSaved: (value) => title = value!,
    );
  }

  Widget _amountTextField() {
    return TextFormField(
      controller: _amountController,
      focusNode: _amountFocus,
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: _appL!.amount,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      ),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      validator: (value) => Validator.amountValidator(value, _appL),
      onSaved: (value) {
        amount = double.parse(value!);
      },
    );
  }

  Widget _detailsTextField() {
    return TextFormField(
      focusNode: _detailsFocus,
      controller: _descriptionController,
      decoration: InputDecoration(
        // border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        labelText: _appL!.details,
        hintText: _appL!.optional,
      ),
      maxLines: ori == Orientation.portrait ? 2 : 1,
      keyboardType: ori == Orientation.portrait
          ? TextInputType.multiline
          : TextInputType.text,
      textInputAction: ori == Orientation.landscape
          ? TextInputAction.done
          : TextInputAction.newline,
      onSaved: (value) => decription = value!,
    );
  }

  void _editeExistingBonuse() {
    _unique = false;
    Map<String, dynamic> oldBalance =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    date = oldBalance['payDate'];
    id = oldBalance['id'];
    _titleController.text = oldBalance['title'];
    _amountController.text = oldBalance['amount'].toString();
    _descriptionController.text = oldBalance['description'];
  }

  Future _datePicker() async {
    final picker = await showDatePicker(
      context: context,
      initialDate: _balanceExisted ? date! : DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
      helpText: _appL!.dateSelect,
      initialEntryMode: DatePickerEntryMode.input,
    );
    if (picker != null) {
      DateTime temp = DateTime.now();
      date = DateTime(picker.year, picker.month, picker.day, temp.hour,
          temp.minute, temp.second, temp.microsecond, temp.microsecond);
    }
  }

  void _checkForExistingBalance() {
    _balanceExisted = ModalRoute.of(context)!.settings.arguments != null;
    if (_balanceExisted) {
      _editeExistingBonuse();
      _balanceExisted = false;
    }
  }

  List<Widget> _formChildren() {
    double width = appSize!.width * 0.7;
    return [
      CustomTextField(
        child: _titleTextField(),
        showBorder: _titleFocus.hasFocus,
        containsError: hasConfirmed ? !_validName : false,
        icon: CustomeIcons.edit_1,
        iconSize: 30,
        color: ThemeColors.darkBlue,
        appWidth: width,
      ),
      //amount
      CustomTextField(
        child: _amountTextField(),
        showBorder: _amountFocus.hasFocus,
        containsError: hasConfirmed ? !_validAmount : false,
        icon: Icons.monetization_on_rounded,
        iconSize: 30,
        color: ThemeColors.darkBlue,
        appWidth: width,
      ),
      //description
      CustomTextField(
        child: _detailsTextField(),
        showBorder: _detailsFocus.hasFocus,
        icon: CustomeIcons.description,
        iconSize: 31,
        color: ThemeColors.darkBlue,
        appWidth: width,
      ),
    ];
  }
}
