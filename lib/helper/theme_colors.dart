import 'package:flutter/material.dart';

class ThemeColors {
  static const Color darkBlue = Color.fromRGBO(41, 106, 198, 1);
  static const Color green = Color.fromRGBO(58, 170, 53, 1);
  static const Color grey = Color.fromRGBO(247, 247, 247, 1);
  static const Color brightGreen = Color.fromRGBO(50, 166, 45, 1);
  static const Color darkRed = Color.fromRGBO(173, 0, 0, 1);
  static const Color lightBlueG = Color.fromRGBO(54, 169, 255, 1);
  static const Color darkBlueG = Color.fromRGBO(53, 75, 142, 1);
  static const Color mylightRed = Color.fromRGBO(190, 0, 0, 1);
  static LinearGradient get myBlueGradient {
    return const LinearGradient(
      stops: [0.0, 0.8],
      begin: Alignment(-1.0, -1),
      end: Alignment(1.0, 1),
      colors: [lightBlueG, darkBlueG],
    );
  }

  static LinearGradient get myRedGradient {
    return LinearGradient(
      stops: [0.0, 0.8],
      begin: Alignment(-1.0, -1),
      end: Alignment(1.0, 1),
      colors: [mylightRed, darkRed],
    );
  }

  //welcome  page gradient
  static LinearGradient get lightBlueGradient {
    return LinearGradient(
      colors: [
        //light blue
        Color.fromRGBO(53, 166, 224, 1),
        //dark blue
        Color.fromRGBO(29, 50, 174, 1),
      ],
      stops: [0.0, 0.8],
      begin: Alignment(-1.0, -1),
      end: Alignment(1.0, 1),
    );
  }
}
