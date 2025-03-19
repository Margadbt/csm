import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonIcon extends StatelessWidget {
  const ButtonIcon({super.key, required this.imagePath, required this.onTap, this.color, this.iconColor});
  final String imagePath;
  final Function onTap;
  final Color? color;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1000),
              color: color ?? AppColors.secondaryBg,
              border: color == null ? Border.all(color: AppColors.cardStroke, width: 1) : null,
            ),
            child: SvgPicture.asset(
              imagePath,
              fit: BoxFit.none,
              height: 18,
              width: 18,
              colorFilter: ColorFilter.mode(
                iconColor ?? Colors.white, // Replace with your color
                BlendMode.srcIn, // Ensures the color replaces the original SVG color
              ),
            )));
  }
}
