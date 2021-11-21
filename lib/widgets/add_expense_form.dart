import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../icons/custome_icons_icons.dart';

import '../models/expense.dart';

import '../providers/expence_provider.dart';

import '../helper/theme_colors.dart';
import '../helper/validator.dart';

import '../widgets/custome_text_field.dart';

class AddExpenseForm extends StatefulWidget {
  @override
  _AddExpenseFormState createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<AddExpenseForm> {
  ExpenseCategory? expenseCategory;
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

  var _titleController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _amountController = TextEditingController();

  bool _balanceExisted = false;
  bool _unique = true;

  final _form = GlobalKey<FormState>();
  double amount = 0;
  String title = '';
  DateTime? date;
  Orientation? ori;
  Size? appSize;
  String? id;
  AppLocalizations? _appL;

  String decription = '';

  bool get _validName {
    return Validator.nameValidator(_titleController.text, _appL) == null;
  }

  bool get _validAmount {
    return Validator.amountValidator(_amountController.text, _appL) == null;
  }

  void _save() {
    bool validate = _form.currentState!.validate();
    hasConfirmed = true;
    if (validate) {
      _form.currentState!.save();

      final expenseProv = Provider.of<ExpenseProvider>(context, listen: false);
      if (expenseCategory == null) expenseCategory = ExpenseCategory.other;
      if (date == null) date = DateTime.now();
      if (!_unique)
        expenseProv.updateExpenses(
            id!, title, amount, date!, expenseCategory!, decription);
      else
        expenseProv.addExpence(
            amount, title, decription, date!, expenseCategory!);
      Navigator.of(context).pop();
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    print('rebuilt');
    _appL = AppLocalizations.of(context);
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
                    ? appSize!.height * 0.62
                    : appSize!.height * 0.5,
                child: ori == Orientation.portrait
                    ? _portraitMode()
                    : _landscapMode()),
          ),

          //pick date button
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: ori == Orientation.landscape ? 0 : 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: ThemeColors.darkRed),
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
          //save button
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
                    primary: ThemeColors.darkRed,
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
        onTap: () => setState(() {}),
        controller: _titleController,
        onSaved: (value) => title = value!,
        focusNode: _titleFocus,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          labelText: (_appL!.title),
        ),
        textInputAction: TextInputAction.next,
        validator: (value) => Validator.nameValidator(value, _appL));
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
      onSaved: (value) => amount = double.parse(value!),
      validator: (value) => Validator.amountValidator(value, _appL),
    );
  }

  Widget _detailsTextField() {
    return TextFormField(
      controller: _descriptionController,
      focusNode: _detailsFocus,
      onTap: () => setState(() {}),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
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

  Future _datePicker() async {
    final picker = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 5),
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

  List<DropdownMenuItem<ExpenseCategory>> buildDropDownMenuItem() {
    int index = -1;
    return ExpenseCategory.values.map(
      (expence) {
        index++;
        return DropdownMenuItem(
          value: expence,
          child: Text(
            Expense.localCategories(context: context)[index],
            textAlign: TextAlign.center,
          ),
        );
      },
    ).toList();
  }

  void _editeExistingBonuse() {
    _unique = false;
    Map<String, dynamic> oldExpens =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    date = oldExpens['date'];
    id = oldExpens['id'];
    _titleController.text = oldExpens['title'];
    _amountController.text = oldExpens['amount'].toString();
    _descriptionController.text = oldExpens['decription'];
    expenseCategory = oldExpens['category'];
  }

  void _checkForExistingBalance() {
    _balanceExisted = ModalRoute.of(context)!.settings.arguments != null;
    if (_balanceExisted) {
      _editeExistingBonuse();
      _balanceExisted = false;
    }
  }

  List<Widget> _formChildren() {
    final double width = appSize!.width * 0.7;
    return [
      CustomTextField(
        containsError: hasConfirmed ? !_validName : false,
        showBorder: _titleFocus.hasFocus,
        child: _titleTextField(),
        icon: CustomeIcons.edit_1,
        iconSize: 30,
        color: ThemeColors.darkRed,
        appWidth: width,
      ),
      // amount
      CustomTextField(
        containsError: hasConfirmed ? !_validAmount : false,
        showBorder: _amountFocus.hasFocus,
        child: _amountTextField(),
        icon: Icons.monetization_on_rounded,
        iconSize: 28,
        color: ThemeColors.darkRed,
        appWidth: width,
      ),

      //details
      CustomTextField(
        showBorder: _detailsFocus.hasFocus,
        child: _detailsTextField(),
        icon: CustomeIcons.description,
        iconSize: 30,
        color: ThemeColors.darkRed,
        appWidth: width,
      ),
      // category
      Container(
        alignment: Alignment.center,
        child: DropdownButton<ExpenseCategory>(
          icon: const Icon(Icons.expand_more_sharp),
          hint: Text(_appL!.chooseCategory),
          alignment: Alignment.center,
          value: expenseCategory,
          elevation: 3,
          itemHeight: 50,
          menuMaxHeight: 350,
          onChanged: (newValue) {
            setState(() {
              expenseCategory = newValue as ExpenseCategory;
            });
          },
          items: buildDropDownMenuItem(),
        ),
      ),
    ];
  }
}
