import 'package:csm/src/features/theme/cubit/theme_cubit.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InputWithPrefixIcon extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final String prefixIconPath;
  final Function onTap;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  final bool enabled;
  final bool hasBorder;

  const InputWithPrefixIcon({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.prefixIconPath,
    required this.onTap,
    this.obscureText = false,
    this.enableSuggestions = true,
    this.autocorrect = false,
    this.enabled = true,
    this.hasBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: hasBorder
                ? ColorTheme.blue.withOpacity(0)
                : context.read<ThemeCubit>().state
                    ? ColorTheme.blue.withOpacity(0)
                    : Colors.black.withOpacity(0.03), // Customize as needed
            blurRadius: 5,
            offset: const Offset(0, 5),
          )
        ],
        border: hasBorder
            ? Border.all(color: ColorTheme.cardStroke, width: 1)
            : context.read<ThemeCubit>().state
                ? Border.all(color: ColorTheme.cardStroke, width: 1)
                : null,
        color: ColorTheme.secondaryBg, // Background color
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SvgPicture.asset(
            prefixIconPath,
            colorFilter: ColorFilter.mode(
              ColorTheme.iconColor, // Replace with your color
              BlendMode.srcIn, // Ensures the color replaces the original SVG color
            ),
          ), // Prefix Icon
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              enabled: enabled,
              obscureText: obscureText,
              enableSuggestions: enableSuggestions,
              autocorrect: autocorrect,
              controller: controller,
              decoration: InputDecoration(
                fillColor: ColorTheme.textColor,
                hintText: placeholder,
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none, // Remove default border
              ),
              style: TextStyle(color: ColorTheme.textColor),
            ),
          ),
        ],
      ),
    );
  }
}
