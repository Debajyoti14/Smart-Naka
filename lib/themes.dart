import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_naka_ethos/utils/constants.dart';

final darkThemeData = ThemeData(
  brightness: Brightness.dark,
  primaryColor: BACKGROUND_DARK,
  scaffoldBackgroundColor: BACKGROUND_DARK,
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
  colorScheme: const ColorScheme.dark(primary: BACKGROUND_DARK),
  // buttonTheme: const ButtonThemeData(
  //   minWidth: 200,
  //   height: 100,
  //   buttonColor: ACCENT_GREEN,
  //   textTheme: ButtonTextTheme.primary,
  // ),
);
