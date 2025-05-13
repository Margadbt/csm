import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/home/cubit/home_cubit.dart';
import 'package:csm/src/features/packages/cubit/package_cubit.dart';
import 'package:csm/src/features/theme/cubit/theme_cubit.dart';
import 'package:csm/src/widgets/package_card.dart';
import 'package:csm/src/widgets/text.dart';
import 'package:csm/theme/colors.dart';
import 'package:csm/utils/math_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart';

class StatusChips extends StatelessWidget {
  const StatusChips({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50, // Adjust height as needed
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildStatusChip(
                context: context,
                icon: Assets.images.warehouse.path,
                label: "Бүртгэсэн",
                color: ColorTheme.blue,
                onTap: () {
                  context.read<HomeCubit>().changePackageScreenIndex(0);
                  context.read<HomeCubit>().changeHomeScreenIndex(1);
                }),
            _buildStatusChip(
                context: context,
                icon: Assets.images.received.path,
                label: "Агуулахад ирсэн",
                color: ColorTheme.yellow,
                onTap: () {
                  context.read<HomeCubit>().changePackageScreenIndex(1);
                  context.read<HomeCubit>().changeHomeScreenIndex(1);
                }),
            _buildStatusChip(
                context: context,
                icon: Assets.images.delievery.path,
                label: "Хүргэлтэнд гарсан",
                color: ColorTheme.orange,
                onTap: () {
                  context.read<HomeCubit>().changePackageScreenIndex(2);
                  context.read<HomeCubit>().changeHomeScreenIndex(1);
                }),
            _buildStatusChip(
                context: context,
                icon: Assets.images.completed.path,
                label: "Авсан",
                color: ColorTheme.green,
                onTap: () {
                  context.read<HomeCubit>().changePackageScreenIndex(3);
                  context.read<HomeCubit>().changeHomeScreenIndex(1);
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip({required BuildContext context, required String icon, required String label, required Color color, required Function onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: InkWell(
        onTap: () => onTap(),
        child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: context.read<ThemeCubit>().state ? ColorTheme.blue.withOpacity(0) : Colors.black.withOpacity(0.03), // Customize as needed
                  blurRadius: 5,
                  offset: const Offset(0, 5),
                )
              ],
              borderRadius: BorderRadius.circular(10000),
              color: color,
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  icon,
                  height: 18,
                  colorFilter: ColorFilter.mode(
                    Colors.black, // Replace with your color
                    BlendMode.srcIn, // Ensures the color replaces the original SVG color
                  ),
                ),
                const SizedBox(width: 6),
                SizedBox(child: text(value: label.split(' ').join('\n'), maxLine: 2, fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black))
              ],
            )),
      ),
    );
  }
}
