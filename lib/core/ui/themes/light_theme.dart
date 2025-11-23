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
  iconTheme: IconThemeData(color: Colors.grey[800]),
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
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith<Color>((
      Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.selected)) {
        return Colors.white; // White thumb when ON
      }
      return Colors.grey[700]!; // Light grey thumb when OFF
    }),
    trackColor: WidgetStateProperty.resolveWith<Color>((
      Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.selected)) {
        return AppColor.buttonBackgroundColor.withValues(
          alpha: 0.8,
        ); // Red track when ON
      }
      return AppColor.bodyPrimaryColor; // Light grey track when OFF
    }),
    trackOutlineColor: WidgetStateProperty.resolveWith<Color>((
      Set<WidgetState> states,
    ) {
      return Colors.grey[700]!; // No outline
    }),
  ),
);
