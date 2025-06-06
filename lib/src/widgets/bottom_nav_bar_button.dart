import 'package:csm/src/features/theme/cubit/theme_cubit.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavButtonIcon extends StatelessWidget {
  const NavButtonIcon({
    super.key,
    required this.icon,
    required this.onTap,
    required this.selected,
    this.iconColor,
  });

  final String icon;
  final Function onTap;
  final bool selected;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    Color notSelectedColor = context.read<ThemeCubit>().state ? Colors.white : Colors.black;
    return Material(
      color: Colors.transparent, // Ensures no extra background color
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1000),
          color: selected ? ColorTheme.blue : Colors.transparent,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(1000),
          splashColor: Colors.white.withOpacity(0.2), // Light splash effect
          highlightColor: Colors.white.withOpacity(0.1), // Subtle highlight effect
          onTap: () {
            onTap();
          },
          child: Container(
            height: 50,
            width: 50,
            alignment: Alignment.center,
            child: SvgPicture.asset(
              icon,
              height: 18,
              width: 18,
              colorFilter: ColorFilter.mode(
                selected ? Colors.black : notSelectedColor, // Change icon color
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
