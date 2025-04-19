import 'package:csm/gen/fonts.gen.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';

Text text({required String value, double fontSize = 14, TextAlign align = TextAlign.start, Color? color, int? maxLine, Key? key, FontWeight? fontWeight, String? fontFamily = "Comfortaa"}) {
  return Text(
    value,
    style: TextStyle(
      fontFamily: fontFamily ?? FontFamily.comfortaa,
      fontWeight: fontWeight,
      height: 1.2,
      fontSize: fontSize,
      color: color ?? ColorTheme.textColor,
      overflow: TextOverflow.ellipsis,
    ),
    maxLines: maxLine,
    textAlign: align,
    key: key,
  );
}
