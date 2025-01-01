import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bluishClr = Color(0xFF865DFF);
const Color orangeClr = Color(0xCFFF8746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);

class Themes {
  static final light = ThemeData(
    primaryColor: primaryClr,
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
  );

  static final dark = ThemeData(
    primaryColor: darkGreyClr,
    scaffoldBackgroundColor: darkGreyClr,
    brightness: Brightness.dark,
  );
}

TextStyle get headingStyle {
  return GoogleFonts.poppins(
      textStyle: TextStyle(
    color: Get.isDarkMode ? Colors.white : Colors.black,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ));
}

TextStyle get subHeadingStyle {
  return GoogleFonts.poppins(
      textStyle: TextStyle(
    color: Get.isDarkMode ? Colors.white : Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ));
}

TextStyle get titleStyle {
  return GoogleFonts.poppins(
      textStyle: TextStyle(
    color: Get.isDarkMode ? Colors.white : Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ));
}

TextStyle get subTitleStyle {
  return GoogleFonts.poppins(
      textStyle: TextStyle(
    color: Get.isDarkMode ? Colors.white : Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  ));
}

TextStyle get bodyStyle {
  return GoogleFonts.poppins(
      textStyle: TextStyle(
    color: Get.isDarkMode ? Colors.white : Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ));
}

TextStyle get body2Style {
  return GoogleFonts.poppins(
      textStyle: TextStyle(
    color: Get.isDarkMode ? Colors.grey : Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ));
}
