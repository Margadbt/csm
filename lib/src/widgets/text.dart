import 'package:csm/gen/fonts.gen.dart';
import 'package:flutter/material.dart';

Text text({required String value, double fontSize = 14, TextAlign align = TextAlign.start, Color? color, int? maxLine, Key? key, FontWeight? fontWeight, String? fontFamily = "Comfortaa"}) {
  return Text(
    value,
    style: TextStyle(
      fontFamily: fontFamily ?? FontFamily.comfortaa,
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: color ?? const Color(0xFFFFFFFF),
      overflow: TextOverflow.ellipsis,
    ),
    maxLines: maxLine,
    textAlign: align,
    key: key,
  );
}
