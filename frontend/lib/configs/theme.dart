import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme textTheme(Color color) => TextTheme(
      headline1: GoogleFonts.inter(
        color: color,
        fontSize: 32,
        fontWeight: FontWeight.w700,
      ),
      headline2: GoogleFonts.inter(
        color: color,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      headline3: GoogleFonts.inter(
        color: color,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      headline4: GoogleFonts.inter(
        color: color,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
      headline5: GoogleFonts.inter(
        color: color,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      headline6: GoogleFonts.inter(
        color: color,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      bodyText1: GoogleFonts.inter(
        color: color,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      bodyText2: GoogleFonts.inter(
        color: color,
        fontSize: 10,
        fontWeight: FontWeight.normal,
      ),
    );

ThemeData lightThemeData() {
  return ThemeData.light().copyWith(
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: appBarTheme,
    iconTheme: IconThemeData(color: kContentColorLightTheme),
    colorScheme: ColorScheme.light(
      primary: kPrimaryColor,
      secondary: kSecondaryColor,
      error: kErrorColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFB6B7B7),
      selectedItemColor: kContentColorLightTheme.withOpacity(0.7),
      unselectedItemColor: kContentColorLightTheme.withOpacity(0.32),
      selectedIconTheme: IconThemeData(color: kPrimaryColor),
      showUnselectedLabels: true,
    ),
    textTheme: textTheme(kContentColorLightTheme),
    inputDecorationTheme: inputDecorationTheme(),
  );
}

ThemeData darkThemeData() {
  return ThemeData.dark().copyWith(
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: kContentColorLightTheme,
    appBarTheme: appBarTheme,
    iconTheme: IconThemeData(color: kContentColorDarkTheme),
    colorScheme: ColorScheme.dark().copyWith(
      primary: kPrimaryColor,
      secondary: kSecondaryColor,
      error: kErrorColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: kContentColorLightTheme,
      selectedItemColor: Colors.white70,
      unselectedItemColor: kContentColorDarkTheme.withOpacity(0.32),
      selectedIconTheme: IconThemeData(color: kPrimaryColor),
      showUnselectedLabels: true,
    ),
    textTheme: textTheme(kContentColorDarkTheme),
    inputDecorationTheme: inputDecorationTheme(),
  );
}

final appBarTheme = AppBarTheme(centerTitle: true, elevation: 0);

InputDecorationTheme inputDecorationTheme() {
  return InputDecorationTheme(
    labelStyle: GoogleFonts.roboto(),
    floatingLabelStyle: GoogleFonts.roboto(),
    errorMaxLines: 1,
    hintStyle: GoogleFonts.roboto(),
    
  );
}
