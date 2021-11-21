import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spend_safe/pages/transparent_details_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/bounsePay.dart';
import '../providers/bonuse_pay_provider.dart';

import '../helper/theme_colors.dart';

import '../pages/add_balnce_page.dart';

class BonuseBalanceItem extends StatelessWidget {
  final BonusePay bonuse;
  BonuseBalanceItem(this.bonuse);

  AppLocalizations? _appL;

  @override
  Widget build(BuildContext context) {
    final bounsePayProvider =
        Provider.of<BonusePayProvider>(context, listen: false);
    _appL = AppLocalizations.of(context);
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
                title: Text(_appL!.areYouSure),
                content: Text(
                  _appL!.deleteItemText(bonuse.title),
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      bounsePayProvider.deleteBounse(bonuse.id);
                      Navigator.of(context).pop(true);
                    },
                    child: Text(
                      _appL!.yes,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
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
                  )
                ],
              ),
            ),
          );
        },
        background: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          width: double.maxFinite,
          color: ThemeColors.darkRed,
          alignment: Alignment.centerRight,
          child: const Icon(
            Icons.delete,
            size: 35,
            color: Colors.grey,
          ),
        ),
        key: ValueKey(bonuse.id),
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 4,
          child: ListTile(
            onLongPress: () {
              Navigator.of(context)
                  .pushNamed(AddBalancePage.routeName, arguments: {
                'title': bonuse.title,
                'amount': bonuse.amount,
                'payDate': bonuse.payDate,
                'description': bonuse.decription,
                'id': bonuse.id
              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            onTap: () => Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext ctx, _, __) =>
                    TransparentDetailsPage(
                  bonuse.title,
                  bonuse.decription,
                ),
              ),
            ),

            // => DialogHelper.descriptionDialog(
            //   context,
            //   bonuse.title,
            //   bonuse.decription,
            // ),
            contentPadding: const EdgeInsets.all(8),
            leading: const CircleAvatar(
              backgroundColor: ThemeColors.green,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: const Icon(
                  Icons.money_off,
                  color: Colors.white,
                ),
              ),
            ),
            title: Text('${bonuse.title}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Text(
                '${bonuse.amount}',
                style: const TextStyle(
                  color: ThemeColors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            trailing:
                Text('${DateFormat('dd-MM-yyyy').format(bonuse.payDate)}'),
          ),
        ),
      ),
    );
  }
}
