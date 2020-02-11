import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:flutter/material.dart';
import 'ps_colors.dart';
import 'ps_config.dart';

ThemeData themeData(ThemeData baseTheme) {
  //final baseTheme = ThemeData.light();

  if (baseTheme.brightness == Brightness.dark) {
    // Dark Theme
    return baseTheme.copyWith(
      primaryColor: ps_dtheme_color_primary,
      primaryColorDark: ps_dtheme_color_primary,
      primaryColorLight: ps_dtheme_color_primary_light,
      textTheme: TextTheme(
        display4: TextStyle(
            color: ps_dtheme_text__primary_color,
            fontFamily: ps_default_font_family),
        display3: TextStyle(
            color: ps_dtheme_text__primary_color,
            fontFamily: ps_default_font_family),
        display2: TextStyle(
            color: ps_dtheme_text__primary_color,
            fontFamily: ps_default_font_family),
        display1: TextStyle(
          color: ps_dtheme_text__primary_color,
          fontFamily: ps_default_font_family,
        ),
        headline: TextStyle(
            color: ps_dtheme_text__primary_color,
            fontFamily: ps_default_font_family,
            fontWeight: FontWeight.bold),
        title: TextStyle(
            color: ps_dtheme_text__primary_color,
            fontFamily: ps_default_font_family),
        subhead: TextStyle(
            color: ps_dtheme_text__primary_color,
            fontFamily: ps_default_font_family,
            fontSize: ps_space_18,
            fontWeight: FontWeight.bold),
        body2: TextStyle(
            color: ps_dtheme_text__primary_color,
            fontFamily: ps_default_font_family,
            fontWeight: FontWeight.bold,
            fontSize: 15),
        body1: TextStyle(
            color: ps_dtheme_text__primary_color,
            fontFamily: ps_default_font_family,
            fontSize: 15),
        caption: TextStyle(
            color: ps_dtheme_text__primary_color,
            fontFamily: ps_default_font_family),
        button: TextStyle(
            color: ps_dtheme_text__primary_color,
            fontFamily: ps_default_font_family),
        subtitle: TextStyle(
            color: ps_dtheme_text__primary_color,
            fontFamily: ps_default_font_family,
            fontSize: ps_space_16,
            fontWeight: FontWeight.bold),
        overline: TextStyle(
            color: ps_dtheme_text__primary_color,
            fontFamily: ps_default_font_family),
      ),
      iconTheme: const IconThemeData(color: ps_dtheme_icon_color),
    );
  } else {
    // White Theme
    return baseTheme.copyWith(
      primaryColor: ps_wtheme_color_primary,
      primaryColorDark: ps_wtheme_color_primary,
      primaryColorLight: ps_wtheme_color_primary_light,
      textTheme: TextTheme(
        display4: TextStyle(
            color: ps_wtheme_text__primary_color,
            fontFamily: ps_default_font_family),
        display3: TextStyle(
            color: ps_wtheme_text__primary_color,
            fontFamily: ps_default_font_family),
        display2: TextStyle(
            color: ps_wtheme_text__primary_color,
            fontFamily: ps_default_font_family),
        display1: TextStyle(
            color: ps_wtheme_text__primary_color,
            fontFamily: ps_default_font_family),
        headline: TextStyle(
            color: ps_wtheme_text__primary_color,
            fontFamily: ps_default_font_family,
            fontWeight: FontWeight.bold),
        title: TextStyle(
            color: ps_wtheme_text__primary_color,
            fontFamily: ps_default_font_family),
        subhead: TextStyle(
            color: ps_wtheme_text__primary_color,
            fontFamily: ps_default_font_family,
            fontSize: ps_space_18,
            fontWeight: FontWeight.bold),
        body2: TextStyle(
            color: ps_wtheme_text__primary_color,
            fontFamily: ps_default_font_family,
            fontWeight: FontWeight.bold,
            fontSize: 15),
        body1: TextStyle(
            color: ps_wtheme_text__primary_color,
            fontFamily: ps_default_font_family,
            fontSize: 15),
        caption: TextStyle(
            color: ps_wtheme_text__primary_light_color,
            fontFamily: ps_default_font_family),
        button: TextStyle(
            color: ps_wtheme_text__primary_color,
            fontFamily: ps_default_font_family),
        subtitle: TextStyle(
            color: ps_wtheme_text__primary_color,
            fontFamily: ps_default_font_family,
            fontSize: ps_space_16,
            fontWeight: FontWeight.bold),
        overline: TextStyle(
            color: ps_wtheme_text__primary_color,
            fontFamily: ps_default_font_family),
      ),
      iconTheme: const IconThemeData(color: ps_wtheme_icon_color),
    );
  }
}
