import 'package:csm/src/widgets/icon_button.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
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
    return Expanded(
      child: Row(
        children: [
          // Input Field
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: ColorTheme.cardStroke, width: 1),
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
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: placeholder,
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: InputBorder.none, // Remove default border
                      ),
                      style: TextStyle(color: ColorTheme.textColor),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12), // Space between input and button

          ButtonIcon(
            imagePath: buttonIconPath,
            onTap: onTap,
            color: ColorTheme.blue,
            iconColor: Colors.black,
          )
        ],
      ),
    );
  }
}
