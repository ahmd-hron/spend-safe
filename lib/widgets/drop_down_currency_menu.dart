import 'package:flutter/material.dart';

import '../helper/currency_database.dart';
import '../providers/user_data.dart';

class DropDownCurrencyMenu extends StatefulWidget {
  @override
  _DropDownCurrencyMenuState createState() => _DropDownCurrencyMenuState();
  final String value;
  final int elevation;
  final IconData icon;
  final double height;
  final double menuMaxheight;
  DropDownCurrencyMenu({
    required this.value,
    required this.elevation,
    required this.icon,
    required this.height,
    required this.menuMaxheight,
  });
}

class _DropDownCurrencyMenuState extends State<DropDownCurrencyMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButton<String>(
        isDense: true,
        items: currenctItem,
        elevation: widget.elevation,
        hint: FittedBox(
          child: Text(widget.value),
        ),
        icon: Icon(widget.icon),
        itemHeight: widget.height,
        menuMaxHeight: widget.menuMaxheight,
        value: UserDataProvider.currency,
        onChanged: (newValue) {
          setState(() {
            UserDataProvider.currency = newValue;
          });
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> get currenctItem {
    return CurrencyDataBase.worldCurrency
        .map((currency) => DropdownMenuItem<String>(
              child: Text(
                currency,
                textAlign: TextAlign.center,
              ),
              value: currency,
            ))
        .toList();
  }
}
