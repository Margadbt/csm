import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
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
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cardStroke, width: 1),
        color: AppColors.secondaryBg, // Background color
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SvgPicture.asset(prefixIconPath), // Prefix Icon
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              enabled: enabled,
              obscureText: obscureText,
              enableSuggestions: enableSuggestions,
              autocorrect: autocorrect,
              controller: controller,
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none, // Remove default border
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
