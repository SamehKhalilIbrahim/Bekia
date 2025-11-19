import 'package:flutter/material.dart';
import 'app_color.dart';
import 'font.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColor.bodyPrimaryColor,
  secondaryHeaderColor: AppColor.bodySecondaryColor,
  scaffoldBackgroundColor: AppColor.bodyPrimaryColor,
  primaryColorLight: AppColor.buttonBackgroundColor,
  cardColor: AppColor.externalColor,
  hintColor: AppColor.textColor,
  textTheme: TextTheme(
    headlineLarge: const TextStyle(
      color: Colors.white,
      fontSize: 34,
      fontFamily: Font.bold,
    ),
    headlineMedium: const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontFamily: Font.semiBold,
    ),
    headlineSmall: const TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontFamily: Font.regular,
    ),
    bodyLarge: TextStyle(
      color: Colors.grey[700],
      fontSize: 16,
      fontFamily: Font.bold,
    ),
    bodyMedium: TextStyle(
      color: Colors.grey[700],
      fontSize: 12,
      fontFamily: Font.semiBold,
    ),
    bodySmall: TextStyle(
      color: Colors.grey[500],
      fontSize: 12,
      fontFamily: Font.regular,
    ),
  ),
  buttonTheme: ButtonThemeData(
    textTheme: ButtonTextTheme.primary,
    buttonColor: AppColor.buttonBackgroundColor,
  ),
);
