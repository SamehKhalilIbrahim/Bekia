import 'package:flutter/material.dart';

class AppColor {
  static Color textColor = Colors.grey[600]!;
  static Color textColorDark = const Color(0xffEEEEEE);

  static Color externalColor = Colors.black.withOpacity(0.1);
  static Color externalColorDark =
      const Color.fromARGB(255, 255, 208, 169).withOpacity(0.2);
  static Color bodyPrimaryColor = const Color(0xffFFFFEC);

  static Color bodyPrimaryColorDark = const Color(0xff393D46);

  static Color bodySecondaryColor = const Color.fromARGB(255, 255, 208, 169);
  static Color bodySecondaryColorDark = const Color(0xff212832);

  static Color buttonBackgroundColor = const Color(0xffD84040);
  static Color buttonBackgroundColorDark = const Color(0xffD55A31);
}
