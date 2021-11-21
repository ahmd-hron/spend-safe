import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../helper/currency_database.dart';
import '../helper/theme_colors.dart';

import '../providers/user_data.dart';

import '../widgets/circular_container.dart';
import '../providers/total_user_balance.dart';

class CircleSpendPrograss extends StatelessWidget {
  final double minWidth;
  const CircleSpendPrograss(this.minWidth);

  @override
  Widget build(BuildContext context) {
    final totalUserBalanceProvider =
        Provider.of<TotalUserBalanceProvider>(context);
    final userProvider = Provider.of<UserDataProvider>(context);

    NumberFormat formatter(
        String currency, String localCode, String sympol, bool numbersOnly) {
      if (!numbersOnly)
        return NumberFormat.currency(
          customPattern: '$sympol #,###,###.00',
          symbol: sympol,
          locale: localCode,
        );
      return NumberFormat.compactCurrency(
        locale: localCode,
        symbol: sympol,
        decimalDigits: 2,
      );
    }

    return CircularContainer(
      circleColor: ThemeColors.darkBlue,
      minHeightWidth: minWidth,
      //overall outside shadow
      child: PhysicalModel(
        shape: BoxShape.circle,
        color: Colors.black,
        shadowColor: Colors.black,
        elevation: 8.8,
        //outside color circle
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          //tring here
          constraints: BoxConstraints(
            minWidth: minWidth - (minWidth * 0.2),
            minHeight: minWidth - (minWidth * 0.2),
            maxHeight: minWidth - (minWidth * 0.2),
            maxWidth: minWidth - (minWidth * 0.2),
          ),
          // height: minWidth,
          // width: minWidth,
          // maxRadius: 120,
          // minRadius: 120,
          // backgroundColor: ThemeColors.myDarkBlue,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // progras indicatorr
              TweenAnimationBuilder<double>(
                tween: Tween<double>(
                    begin: 0.0, end: totalUserBalanceProvider.spendPrecentage),
                duration: const Duration(milliseconds: 500),
                builder: (ctx, value, _) => CircularProgressIndicator(
                    value: value,
                    // trying here
                    strokeWidth: minWidth > 180
                        ? minWidth - (minWidth * 0.225)
                        : minWidth - (minWidth * 0.26),
                    // strokeWidth: 78,
                    color: _desiredValueColor(value)
                    // backgroundColor: Color.fromRGBO(1, 1, 1, 0.1),
                    ),
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: ThemeColors.myBlueGradient,
                ),
                // constraints: const BoxConstraints(
                //   minHeight: 300,
                //   minWidth: 300,
                // ),
                // trying here
                height: minWidth + (minWidth * 0.2),
                width: minWidth + (minWidth * 0.2),
              ),
              //inside value circle
              CircularContainer(
                circleColor: ThemeColors.darkBlue,
                //trying here
                // maxHeightWidth: 180,
                maxHeightWidth: minWidth - (minWidth * 0.28),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  constraints: BoxConstraints(
                    // maxHeight: 200,
                    // maxWidth: 200,
                    maxHeight: minWidth - (minWidth * 0.2),
                    maxWidth: minWidth - (minWidth * 0.2),
                  ),
                  alignment: Alignment.center,
                  child: SizedBox(
                    //trying here
                    height: minWidth - (minWidth * 0.6),
                    // height: 100,
                    // add future builder here
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildBalanceNumber(
                          ThemeColors.brightGreen,
                          formatter(
                            UserDataProvider.currency!,
                            'en',
                            CurrencyDataBase.worldSympols(
                              UserDataProvider.currency!,
                            ),
                            userProvider.showLetters,
                          ),
                          totalUserBalanceProvider.totalUserBalance,
                        ),
                        _buildBalanceNumber(
                          ThemeColors.darkRed,
                          formatter(
                            UserDataProvider.currency!,
                            'en',
                            CurrencyDataBase.worldSympols(
                              UserDataProvider.currency!,
                            ),
                            userProvider.showLetters,
                          ),
                          totalUserBalanceProvider.userTotalExpense,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceNumber(
      Color color, NumberFormat formatter, double amount) {
    final double myFontSize = 20;
    // final double mySmallFontSize = 13;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: FittedBox(
        fit: BoxFit.contain,
        child: RichText(
          text: TextSpan(children: [
            _buildTextSpan('${formatter.format(amount)}', color, myFontSize),
            // _buildTextSpan(' 00', color, mySmallFontSize),
            // _buildTextSpan(' ${UserDataProvider.currency}', color, myFontSize),
          ]),
        ),
      ),
    );
  }

  TextSpan _buildTextSpan(String text, Color color, double myFontSize) {
    return TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: myFontSize,
      ),
    );
  }

  Color _desiredValueColor(double value) {
    return value > 0.75
        ? Colors.greenAccent.shade400
        : value > 0.5
            ? Colors.yellow.shade600
            : value > 0.25
                ? Colors.orange
                : value > 0.15
                    ? Colors.deepOrange.shade700
                    : Colors.redAccent.shade700;
  }
}
