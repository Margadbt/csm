import 'package:csm/src/features/theme/cubit/theme_cubit.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonIcon extends StatelessWidget {
  const ButtonIcon({
    super.key,
    required this.imagePath,
    required this.onTap,
    this.color,
    this.iconColor,
    this.width,
    this.height,
  });

  final String imagePath;
  final Function onTap;
  final Color? color;
  final Color? iconColor;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // Prevents unwanted background color
      child: Ink(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: context.read<ThemeCubit>().state ? ColorTheme.blue.withOpacity(0) : Colors.black.withOpacity(0.03), // Customize as needed
              blurRadius: 5,
              offset: const Offset(0, 5),
            )
          ],
          borderRadius: BorderRadius.circular(1000),
          color: color ?? ColorTheme.secondaryBg,
          border: color == null ? Border.all(color: ColorTheme.cardStroke, width: 1) : null,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(1000),
          splashColor: Colors.white.withOpacity(0.2), // Smooth splash effect
          highlightColor: Colors.white.withOpacity(0.1), // Soft highlight effect
          onTap: () {
            onTap();
          },
          child: Container(
            height: 50,
            width: 50,
            alignment: Alignment.center,
            child: SvgPicture.asset(
              imagePath,
              height: width ?? 18,
              width: height ?? 18,
              colorFilter: ColorFilter.mode(
                iconColor ?? ColorTheme.iconColor, // Set icon color dynamically
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
