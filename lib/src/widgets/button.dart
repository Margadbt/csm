import 'package:csm/src/widgets/text.dart';
import 'package:csm/theme/colors.dart';
import 'package:csm/utils/math_utils.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.title, this.color, this.textColor, required this.onTap, this.heightLimitSet});
  final String title;
  final Color? color;
  final Color? textColor;
  final Function onTap;
  final bool? heightLimitSet;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        height: heightLimitSet == true ? 50 : null,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
            color: color ?? ColorTheme.blue, // Background color
            borderRadius: defaultBorderRadius),
        child: text(value: title, color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }
}
