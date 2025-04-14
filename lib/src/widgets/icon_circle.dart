import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconCircle extends StatelessWidget {
  const IconCircle({
    super.key,
    required this.imagePath,
    this.color,
    this.iconColor,
    this.size,
    this.padding,
  });

  final String imagePath;
  final Color? color;
  final Color? iconColor;
  final double? size;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size ?? 50,
      width: size ?? 50,
      padding: EdgeInsets.all(padding ?? 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000),
        color: color ?? AppColors.secondaryBg,
        border: color == null ? Border.all(color: AppColors.cardStroke, width: 1) : null,
      ),
      child: SvgPicture.asset(
        imagePath,
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(
          iconColor ?? Colors.white,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
