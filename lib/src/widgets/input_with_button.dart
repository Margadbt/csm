import 'package:csm/src/features/theme/cubit/theme_cubit.dart';
import 'package:csm/src/widgets/icon_button.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InputWithButton extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final String prefixIconPath;
  final String buttonIconPath;
  final Function onTap;

  const InputWithButton({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.prefixIconPath,
    required this.buttonIconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Input Field
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: context.read<ThemeCubit>().state ? ColorTheme.blue.withOpacity(0) : Colors.black.withOpacity(0.03), // Customize as needed
                  blurRadius: 5,
                  offset: const Offset(0, 5),
                )
              ],
              border: context.read<ThemeCubit>().state ? Border.all(color: ColorTheme.cardStroke, width: 1) : null,
              color: ColorTheme.secondaryBg,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                SvgPicture.asset(
                  prefixIconPath,
                  colorFilter: ColorFilter.mode(
                    ColorTheme.iconColor,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: placeholder,
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: ColorTheme.textColor),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        ButtonIcon(
          imagePath: buttonIconPath,
          onTap: onTap,
          color: ColorTheme.blue,
          iconColor: Colors.black,
        )
      ],
    );
  }
}
