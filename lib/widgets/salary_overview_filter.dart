import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/user_data.dart';

class SalaryOverViewFilter extends StatefulWidget {
  static UserTimeFilter? filter;
  @override
  _SalaryOverViewFilterState createState() => _SalaryOverViewFilterState();
}

class _SalaryOverViewFilterState extends State<SalaryOverViewFilter> {
  final String newThing = 'it worked';

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserDataProvider>(context);
    return DropdownButton<UserTimeFilter>(
      isDense: true,
      items: _dropDownFilterItems(),
      value: UserDataProvider.timeFilter!,
      itemHeight: 50,
      elevation: 0,
      hint: Text(''),
      menuMaxHeight: 350,
      icon: Icon(Icons.expand_more),
      onChanged: (newValue) {
        setState(() {
          userProvider.changeTimerFilter(newValue!);
          SalaryOverViewFilter.filter = newValue;
        });
      },
    );
  }

  List<DropdownMenuItem<UserTimeFilter>> _dropDownFilterItems() {
    int index = -1;
    return UserTimeFilter.values.map(
      (timeFilter) {
        index++;
        return DropdownMenuItem(
          value: timeFilter,
          child: Text(
            '   ${filterLocal(context)[index]}   ',
            textAlign: TextAlign.center,
          ),
        );
      },
    ).toList();
  }

  static List<String> filterLocal(BuildContext context) {
    final appl = AppLocalizations.of(context);
    return [appl!.thisMonth, appl.thisYear, appl.all];
  }
}
