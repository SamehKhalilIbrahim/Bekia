import 'package:flutter/widgets.dart';

import 'font.dart';

abstract class TextStyles {
  static const String bold = Font.bold;
  static const String semiBold = Font.semiBold;
  static const String regular = Font.regular;

  static const bold48 = TextStyle(
    fontFamily: bold,
    fontSize: 48,
    fontWeight: FontWeight.bold,
  );

  // **************
  //     36
  // **************
  static const regular36 = TextStyle(
    fontFamily: regular,
    fontSize: 36,
    fontWeight: FontWeight.normal,
  );

  // **************
  //     32
  // **************
  static const regular32 = TextStyle(
    fontFamily: regular,
    fontSize: 32,
    fontWeight: FontWeight.w500,
  );

  // **************
  //     28
  // **************
  static const bold28 = TextStyle(
    fontFamily: bold,
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  // **************
  //     22
  // **************
  static const regular22 = TextStyle(
    fontFamily: regular,
    fontSize: 22,
    fontWeight: FontWeight.normal,
  );

  // **************
  //     20
  // **************
  static const bold20 = TextStyle(
    fontFamily: bold,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const regular20 = TextStyle(
    fontFamily: regular,
    fontSize: 20,
    fontWeight: FontWeight.normal,
  );

  // **************
  //     16
  // **************
  static const bold16 = TextStyle(
    fontFamily: bold,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const regular16 = TextStyle(
    fontFamily: regular,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const semi16 = TextStyle(
    fontFamily: semiBold,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  // **************
  //     15
  // **************
  static const regular15 = TextStyle(
    fontFamily: regular,
    fontSize: 15,
    fontWeight: FontWeight.normal,
  );

  // **************
  //     14
  // **************
  static const bold14 = TextStyle(
    fontFamily: bold,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  // **************
  //     12
  // **************
  static const regular12 = TextStyle(
    fontFamily: regular,
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );
}
