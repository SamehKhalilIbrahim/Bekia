import 'package:flutter/material.dart';

class AppColor {
  static Color textColor = Colors.grey[600]!;
  static Color externalColor = Colors.black.withOpacity(0.1);
  static Color bodyPrimaryColor = const Color(0xffFFFFEC);
  static Color bodySecondaryColor = const Color.fromARGB(255, 255, 208, 169);
  static Color buttonBackgroundColor = const Color(0xffD84040);

  // Dark Theme Colors - Improved
  static Color textColorDark = const Color(0xffE8E8E8);

  // Background colors - deeper, more comfortable for dark mode
  static Color bodyPrimaryColorDark = const Color(0xff1A1D23);
  static Color bodySecondaryColorDark = const Color(0xff25292F);

  // Card/Surface color - slightly elevated from background
  static Color externalColorDark = const Color(0xff2D3139).withOpacity(0.8);

  // Accent color - warm orange that complements your light theme
  static Color buttonBackgroundColorDark = const Color(0xffFF6B35);

  // Additional helpful colors for dark theme
  static Color accentColorDark = const Color(
    0xffFFB088,
  ); // Softer orange for hover states
  static Color dividerColorDark = const Color(0xff3D4149);
  static Color disabledColorDark = const Color(0xff5A5F6B);
}
