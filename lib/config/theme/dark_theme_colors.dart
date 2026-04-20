import 'package:flutter/material.dart';

class DarkThemeColors {
  // PRIMARY - Teal/Emerald palette
  static const Color primaryColor = Color(0xFF0D9488);   // teal-600
  static const Color primaryColorLight = Color(0xFF99F6E4);
  static const Color primaryColorDark = Color(0xFF0F766E);

  // SECONDARY
  static const Color accentColor = Color(0xFF1C2B2A);

  //Appbar
  static const Color appbarColor = Colors.transparent;

  //SCAFFOLD
  static const Color scaffoldBackgroundColor = Color(0xFF111827);
  static const Color backgroundColor = Color(0xFF0B1614);
  static const Color dividerColor = Color(0xFF1C2B2A);
  static const Color canvasColor = Color(0xFF1A2E2C);
  static const Color cardColor = Color(0xFF111827);

  // SHADOW
  static const Color shadowColor = Color(0xFF111827);

  //ICONS
  static const Color appBarIconsColor = Colors.white;
  static const Color iconColor = Colors.white;

  //BUTTON
  static const Color buttonColor = primaryColor;
  static const Color buttonTextColor = Colors.black;
  static const Color buttonDisabledColor = Colors.grey;
  static const Color buttonDisabledTextColor = Colors.black;

  //TEXT
  static const Color bodyTextColor = Color(0xFF9CA3AF);
  static const Color displayTextColor = Colors.white;
  static const Color bodySmallTextColor = Colors.white;
  static const Color hintTextColor = Color(0xFF7A7A7A);

  //chip
  static const Color chipBackground = Color(0xFF1A2E2C);
  static const Color chipTextColor = Colors.white;

  // progress bar indicator
  static const Color progressIndicatorColor = primaryColor;

  // list tile
  static const Color listTileTitleColor = Colors.white;
  static const Color listTileSubtitleColor = Colors.white;
  static const Color listTileBackgroundColor = Color(0xFF1C2B2A);
  static const Color listTileIconColor = Colors.white;

  //------------------- custom theme (extensions) ------------------- //
  // shimmer theme
  static const Color shimmerBackgroundColor = Color(0xFF1A2E2C);
  static const Color shimmerBaseColor = Color(0xFF1C2B2A);
  static const Color shimmerHighlightColor = Color(0xFF1C2B2A);
}