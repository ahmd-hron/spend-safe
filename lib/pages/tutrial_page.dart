import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/user_data.dart';

class TutrialPage extends StatefulWidget {
  static const String routeName = '/tutrial-page';
  final List<String> content;
  final VoidCallback? saveSalaryPageChange;
  final bool? bonuse;
  final bool? expense;
  final bool shouldShowButton;
  const TutrialPage({
    required this.content,
    this.bonuse,
    this.expense,
    this.saveSalaryPageChange,
    this.shouldShowButton = false,
  });

  @override
  _TutrialPageState createState() => _TutrialPageState();
}

class _TutrialPageState extends State<TutrialPage> {
  AppLocalizations? appL;
  Orientation? _ori;
  Size? appSize;
  final padding = Padding(
    padding: const EdgeInsets.symmetric(vertical: 50),
  );

  int _index = 1;
  final key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    _ori = MediaQuery.of(context).orientation;
    appL = AppLocalizations.of(context);
    appSize = MediaQuery.of(context).size;

    return Scaffold(
      key: key,
      backgroundColor: Colors.black.withOpacity(
        0.75,
      ), // this is the main reason of transparency at next screen. I am ignoring rest implementation but what i have achieved is you can see.
      body: Container(
        height: appSize!.height,
        width: appSize!.width,
        child: _buildTutrialWidget(context),
      ),
    );
  }

  Widget _buildTutrialWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          height: widget.content[_index - 1].length < 90
              ? appSize!.height * 0.25
              : appSize!.height * 0.5,
          width: appSize!.width * 0.8,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _index < 0 ? 'waiting' : widget.content[_index - 1],
              style: TextStyle(color: Colors.yellow, fontSize: 20),
              softWrap: true,
              overflow: TextOverflow.fade,
              maxLines: 10,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(_ori == Orientation.portrait ? 5 : 10.0),
        ),
        // next_continue button
        if (widget.shouldShowButton) _buildTutrialsButtons(),
        if (widget.shouldShowButton && _ori == Orientation.portrait) padding,
        if (widget.shouldShowButton)
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.07),
          ),
        SizedBox(
          width: 120,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(8),
              primary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
              elevation: 3,
            ),
            onPressed: () async {
              if (_lastItemInList) {
                _saveNewValue();

                Navigator.of(context).pop();
              } else {
                setState(() {
                  _index++;
                });
              }
            },
            child: Text(
              _lastItemInList ? appL!.continueButton : appL!.next,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTutrialsButtons() {
    // print(_index);
    if (_index == 1)
      return _materialButton(Icons.payment_outlined);
    else
      return _materialButton(Icons.money_off_csred_outlined);
  }

  void _saveNewValue() async {
    if (widget.bonuse != null)
      Tutrial.saveTutrialValues(
          Tutrial.firstTimeInExpenseValue, widget.bonuse!);
    else if (widget.expense != null)
      Tutrial.saveTutrialValues(
          widget.expense!, Tutrial.firstTimeInBonuseValue);
    else {
      //now change userDataProvider firstTimeSalaryPage bool
      widget.saveSalaryPageChange!();
      // print('both are null this must be the salary page');
    }
  }

  bool get _lastItemInList {
    // print('this is the index $_index');
    // print('this is the content lenght ${widget.content.length}');
    return _index == widget.content.length;
  }

  Widget _materialButton(IconData icon) {
    return RawMaterialButton(
      constraints: const BoxConstraints(
        minHeight: 85,
        minWidth: 85,
      ),
      elevation: 5,
      fillColor: Colors.white,
      onPressed: null,
      child: Icon(
        icon,
        size: 50,
        color: Theme.of(context).primaryColor,
      ),
      shape: const CircleBorder(),
    );
  }
}
