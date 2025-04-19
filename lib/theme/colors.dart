import 'package:csm/theme/dark_colors.dart';
import 'package:csm/theme/light_colors.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const Color orange = Color(0xFFFF9C84);
  static const Color green = Color(0xFFC7FFCA);
  static const Color yellow = Color(0xFFFCFFA3);
}

class ColorTheme {
  static bool isDark = false;

  static Color get primary => isDark ? DarkColors.primary : LightColors.primary;
  static Color get background => isDark ? DarkColors.background : LightColors.background;
  static Color get secondaryBg => isDark ? DarkColors.secondaryBg : LightColors.secondaryBg;
  static Color get blue => isDark ? DarkColors.blue : LightColors.blue;
  static Color get cardStroke => isDark ? DarkColors.cardStroke : LightColors.cardStroke;
  static Color get inactive => isDark ? DarkColors.inactive : LightColors.inactive;
  static Color get orange => isDark ? DarkColors.orange : LightColors.orange;
  static Color get green => isDark ? DarkColors.green : LightColors.green;
  static Color get yellow => isDark ? DarkColors.yellow : LightColors.yellow;
  static Color get textColor => isDark ? DarkColors.textColor : LightColors.textColor;
  static Color get iconColor => isDark ? DarkColors.iconColor : LightColors.iconColor;
}
