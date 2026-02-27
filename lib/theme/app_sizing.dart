import 'package:flutter/material.dart';

class AppSize {
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double width(BuildContext context, double percent) =>
      MediaQuery.of(context).size.width * percent;

  static double height(BuildContext context, double percent) =>
      MediaQuery.of(context).size.height * percent;
}
