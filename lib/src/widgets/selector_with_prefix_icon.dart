import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectorWithPrefixIcon<T> extends StatelessWidget {
  final String prefixIconPath;
  final String placeholder;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;

  const SelectorWithPrefixIcon({
    super.key,
    required this.prefixIconPath,
    required this.placeholder,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cardStroke, width: 1),
        color: AppColors.secondaryBg,
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SvgPicture.asset(prefixIconPath),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                isExpanded: true,
                value: value,
                items: items,
                onChanged: onChanged,
                dropdownColor: AppColors.secondaryBg,
                style: const TextStyle(color: Colors.white),
                hint: Text(
                  placeholder,
                  style: const TextStyle(color: Colors.grey),
                ),
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
