import 'package:flutter/material.dart';

class MyTheme {
  static Color primaryColor = const Color(0xff5D9CEC);
  static Color whiteColor = const Color(0xffffffff);
  static Color blackColor = const Color(0xff383838);
  static Color greenColor = const Color(0xff61E757);

  static Color redColor = const Color(0xffec4b4b);
  static Color greyColor = const Color(0xffC8C9CB);
  static Color backgroundLightColor = const Color(0xffdfecdb);
  static Color backgroundDarkColor = const Color(0xff060e1e);
  static Color blackDarkColor = const Color(0xff141922);

  static ThemeData lightTheme = ThemeData(
      canvasColor: whiteColor,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape:
            CircleBorder(side: BorderSide(width: 3, color: MyTheme.whiteColor)),
      ),
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundLightColor,
      bottomSheetTheme: BottomSheetThemeData(
          shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              side: BorderSide(width: 4, color: primaryColor))),
      appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          elevation: 0,
          titleTextStyle: TextStyle(
              fontFamily: "Poppins-Regular",
              color: whiteColor,
              fontSize: 22,
              fontWeight: FontWeight.bold)),
      textTheme: TextTheme(
          titleLarge: TextStyle(
              fontFamily: "Poppins-Regular",
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 18),
          bodySmall: TextStyle(
              fontFamily: "Roboto",
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: primaryColor)),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedItemColor: primaryColor,
          unselectedItemColor: greyColor,
          unselectedIconTheme: IconThemeData(color: greyColor, size: 35),
          selectedIconTheme: IconThemeData(color: primaryColor, size: 35)));

  static ThemeData darkTheme = ThemeData(
      canvasColor: blackDarkColor,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 5,
        shape:
            CircleBorder(side: BorderSide(width: 3, color: MyTheme.blackColor)),
      ),
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundDarkColor,
      bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: blackColor,
          shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              side: BorderSide(width: 4, color: primaryColor))),
      appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          elevation: 0,
          titleTextStyle: TextStyle(
              fontFamily: "Poppins-Regular",
              color: backgroundDarkColor,
              fontSize: 22,
              fontWeight: FontWeight.bold)),
      textTheme: TextTheme(
          titleLarge: TextStyle(
              fontFamily: "Poppins-Regular",
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 18),
          bodySmall: TextStyle(
              fontFamily: "Roboto",
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: primaryColor)),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedItemColor: primaryColor,
          unselectedItemColor: whiteColor,
          unselectedLabelStyle: TextStyle(
            color: whiteColor,
          ),
          unselectedIconTheme: IconThemeData(color: whiteColor, size: 35),
          selectedIconTheme: IconThemeData(color: primaryColor, size: 35)));
}
