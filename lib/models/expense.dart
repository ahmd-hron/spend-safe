import 'package:flutter/material.dart';

import '../helper/utilities.dart';

import '../icons/custome_icons_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum ExpenseCategory {
  car,
  electronics,
  entertainments,
  family,
  food,
  friends,
  home,
  sports,
  transportation,
  vacation,
  work,
  other,
}

//IMPORTANT
//changeing the order here requires changing in localCategories
//ignoreing this leads to missmatch for each category
class Expense {
  final String id;
  final String title;
  final String decription;
  final double amount;
  final DateTime date;
  final ExpenseCategory expenseCategory;

  const Expense({
    required this.id,
    required this.title,
    required this.decription,
    required this.amount,
    required this.date,
    required this.expenseCategory,
  });

  static ExpenseCategory stringToCategory(String savedValue) {
    for (var i = 0; i < ExpenseCategory.values.length; i++) {
      if (savedValue == Utilities.toUsefulString(ExpenseCategory.values[i]))
        return ExpenseCategory.values[i];
    }
    return ExpenseCategory.other;
  }

  static IconData rightIcon(Expense expence) {
    switch (expence.expenseCategory) {
      //car
      case ExpenseCategory.car:
        return Icons.car_repair;
      //electronices
      case ExpenseCategory.electronics:
        return Icons.electrical_services;
      // entertainments
      case ExpenseCategory.entertainments:
        return CustomeIcons.gamepad;
      // family
      case ExpenseCategory.family:
        return Icons.family_restroom;
      // food
      case ExpenseCategory.food:
        return Icons.restaurant;
      // friends
      case ExpenseCategory.friends:
        return Icons.group;
      // home
      case ExpenseCategory.home:
        return Icons.home;
      //sports
      case ExpenseCategory.sports:
        return CustomeIcons.soccer_ball;
      // transportation
      case ExpenseCategory.transportation:
        return CustomeIcons.bus_alt;
      // vacation
      case ExpenseCategory.vacation:
        return CustomeIcons.umbrella_beach;
      // work
      case ExpenseCategory.work:
        return Icons.work_outline;
      // defoult
      default:
        return CustomeIcons.looped_square_interest;
    }
  }

  static List<String> localCategories({BuildContext? context}) {
    if (context == null)
      return ExpenseCategory.values
          .map(
            (category) => Utilities.toUsefulString(category),
          )
          .toList();
    final appL = AppLocalizations.of(context)!;
    List<String> categoryList = [
      appL.car,
      appL.electronics,
      appL.entertainments,
      appL.family,
      appL.food,
      appL.friends,
      appL.home,
      appL.sports,
      appL.transportation,
      appL.vacation,
      appL.work,
      appL.other,
    ];
    return categoryList;
  }
}
