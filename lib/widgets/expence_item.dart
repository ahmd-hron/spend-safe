import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/expense.dart';
import '../providers/expence_provider.dart';

import '../helper/theme_colors.dart';

import '../pages/transparent_details_page.dart';

import '../pages/add_expense_page.dart';

class ExpenceItem extends StatelessWidget {
  final Expense expense;
  ExpenceItem(this.expense);

  AppLocalizations? _appL;

  @override
  Widget build(BuildContext context) {
    _appL = AppLocalizations.of(context);
    final expenceProvider =
        Provider.of<ExpenseProvider>(context, listen: false);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Dismissible(
        direction: DismissDirection.endToStart,
        confirmDismiss: (dir) {
          return showDialog(
            context: context,
            builder: (ctx) => BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(_appL!.areYouSure,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                content: Text(
                  _appL!.deleteItemText(expense.title),
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      expenceProvider.removeExpence(expense.id);
                      Navigator.of(context).pop(true);
                    },
                    child: Text(
                      _appL!.yes,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      _appL!.no,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        background: Container(
          decoration: BoxDecoration(
            color: ThemeColors.darkRed,
            // borderRadius: BorderRadius.circular(200),
          ),
          margin: const EdgeInsets.symmetric(vertical: 10),
          width: double.maxFinite,
          alignment: Alignment.centerRight,
          child: const Icon(
            Icons.delete,
            size: 35,
            color: Colors.grey,
          ),
        ),
        key: ValueKey(expense.id),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          elevation: 3,
          child: ListTile(
            onLongPress: () => Navigator.of(context)
                .pushNamed(AddExpensePage.routeName, arguments: {
              'id': expense.id,
              'title': expense.title,
              'amount': expense.amount,
              'decription': expense.decription,
              'category': expense.expenseCategory,
              'date': expense.date
            }),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            onTap: () => Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext ctx, _, __) =>
                    TransparentDetailsPage(
                  expense.title,
                  expense.decription,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.all(8),
            leading: CircleAvatar(
              backgroundColor: ThemeColors.darkRed,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Icon(
                  Expense.rightIcon(expense),
                  color: Colors.white,
                ),
              ),
            ),
            title: Text('${expense.title}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                '${expense.amount}',
                style: TextStyle(
                  color: ThemeColors.darkRed,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            trailing: Text('${DateFormat('dd-MM-yyyy').format(expense.date)}'),
          ),
        ),
      ),
    );
  }
}
