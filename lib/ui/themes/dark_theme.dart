import 'package:bekia/ui/themes/font.dart';
import 'package:flutter/material.dart';
import 'app_color.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColor.bodyPrimaryColorDark,
  secondaryHeaderColor: AppColor.bodySecondaryColorDark,
  scaffoldBackgroundColor: AppColor.bodyPrimaryColorDark,
  hintColor: AppColor.textColorDark,
  primaryColorLight: AppColor.buttonBackgroundColorDark,
  cardColor: AppColor.externalColorDark,
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      color: Colors.white,
      fontSize: 34,
      fontFamily: Font.bold,
    ),
    headlineMedium: TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontFamily: Font.semiBold,
    ),
    headlineSmall: TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontFamily: Font.regular,
    ),
    bodyLarge: TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontFamily: Font.bold,
    ),
    bodyMedium: TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontFamily: Font.semiBold,
    ),
    bodySmall: TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontFamily: Font.regular,
    ),
  ),
  buttonTheme: ButtonThemeData(
    textTheme: ButtonTextTheme.primary,
    buttonColor: AppColor.buttonBackgroundColorDark,
  ),
);
