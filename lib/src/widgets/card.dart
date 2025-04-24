import 'package:csm/src/features/theme/cubit/theme_cubit.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyCard extends StatelessWidget {
  const MyCard({super.key, this.padding = const EdgeInsets.all(16), this.child, this.radius = 10, this.hasBorder = true});
  final EdgeInsets padding;
  final Widget? child;
  final double radius;
  final bool hasBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      width: double.infinity,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: context.read<ThemeCubit>().state ? ColorTheme.blue.withOpacity(0) : Colors.black.withOpacity(0.03), // Customize as needed
              blurRadius: 5,
              offset: const Offset(0, 5),
            )
          ],
          border: context.read<ThemeCubit>().state ? Border.all(color: ColorTheme.cardStroke, width: 1) : null,
          color: ColorTheme.secondaryBg, // Background color
          borderRadius: BorderRadius.circular(radius)),
      child: child,
    );
  }
}
