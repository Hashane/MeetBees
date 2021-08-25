import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppTheme {
  Color bg1;
  Color accent1;
  bool isDark;

  /// Default constructor
  MyAppTheme({@required this.isDark});

  ThemeData get themeData {

    /// Create a TextTheme and ColorScheme, that we can use to generate ThemeData
    TextTheme textTheme =  TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headline2: GoogleFonts.lobster(textStyle: TextStyle(color: Colors.white, fontFamily: 'Lobster', fontSize: 40,)),
      headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      headline4: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,color: Colors.black45),
      bodyText1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w100,fontStyle: FontStyle.normal, color: Colors.black54),
      bodyText2: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600,fontStyle: FontStyle.normal, color: Colors.white),
    );

    Color txtColor = textTheme.bodyText1.color;
    ColorScheme colorScheme = ColorScheme(
      primary: Colors.deepOrange,
      onPrimary: Colors.orange,
      primaryVariant: Colors.orangeAccent,

      background: Colors.black.withOpacity(0.5),
      onBackground: Colors.black,

      secondary: Colors.black45,
      onSecondary: Colors.white,
      secondaryVariant: Colors.deepOrange,

      error: Colors.black,
      onError: Colors.white,

      surface: Colors.white,
      onSurface: Colors.black54,

      brightness: isDark ? Brightness.dark : Brightness.light,
    );

    /// Now that we have ColorScheme and TextTheme, we can create the ThemeData
    var t = ThemeData.from(textTheme: textTheme, colorScheme: colorScheme);
    // We can also add on some extra properties that ColorScheme seems to miss
        //.copyWith(buttonColor: accent1, cursorColor: accent1, highlightColor: accent1, toggleableActiveColor: accent1);

    /// Return the themeData which MaterialApp can now use
    return t;
  }
}