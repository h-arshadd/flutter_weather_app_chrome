import 'package:flutter/material.dart';

class LightThemeColors {
  // PRIMARY - Teal/Emerald palette (replacing purple)
  static const Color primaryColor = Color(0xFF0D9488);   // teal-600
  static const Color primaryColorLight = Color(0xFF99F6E4); // teal-200
  static const Color primaryColorDark = Color(0xFF0F766E);  // teal-700

  // SECONDARY COLOR
  static const Color accentColor = Color(0xFFF0FDFB);

  //APPBAR
  static const Color appBarColor = Colors.transparent;

  //SCAFFOLD
  static const Color scaffoldBackgroundColor = Colors.white;
  static const Color backgroundColor = Colors.white;
  static const Color dividerColor = Color(0xFFCCFBF1);
  static const Color canvasColor = Color(0xFFF0FDFB);
  static const Color cardColor = Colors.white;

  // SHADOW
  static const Color shadowColor = Colors.grey;

  //ICONS
  static const Color appBarIconsColor = Colors.white;
  static const Color iconColor = Color(0xFF134E4A);

  //BUTTON
  static const Color buttonColor = primaryColor;
  static const Color buttonTextColor = Colors.white;
  static const Color buttonDisabledColor = Colors.grey;
  static const Color buttonDisabledTextColor = Colors.black;

  //TEXT
  static const Color bodyTextColor = Color(0xFF6B7280);
  static const Color displayTextColor = Color(0xFF134E4A);
  static const Color bodySmallTextColor = Color(0xFF134E4A);
  static const Color hintTextColor = Color(0xff686868);

  //chip
  static const Color chipBackground = Colors.white;
  static const Color chipTextColor = Color(0xFF1B1B1B);

  // progress bar indicator
  static const Color progressIndicatorColor = primaryColor;

  // list tile
  static const Color listTileTitleColor = Color(0xFF575757);
  static const Color listTileSubtitleColor = Color(0xFF575757);
  static const Color listTileBackgroundColor = Color(0xFFF8F8F8);
  static const Color listTileIconColor = Color(0xFF575757);

  //------------------- custom theme (extensions) ------------------- //
  // shimmer theme
  static const Color shimmerBackgroundColor = Color(0xFFF9FEFF);
  static const Color shimmerBaseColor = Color(0xFFE0F7F4);
  static const Color shimmerHighlightColor = Color(0xFFC7F2ED);
}