import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_naka_ethos/utils/constants.dart';

final darkThemeData = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: backgroundDark,
  scaffoldBackgroundColor: backgroundDark,
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
  colorScheme: const ColorScheme.dark(primary: backgroundDark),
);
