import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/home/cubit/home_cubit.dart';
import 'package:csm/src/widgets/text.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                icon: Assets.images.warehouse.path,
                label: "Агуулахад ирсэн",
                color: AppColors.blue,
                onTap: () {
                  context.read<HomeCubit>().changeHomeScreenIndex(1);
                }),
            _buildStatusChip(icon: Assets.images.received.path, label: "Монголд ирсэн", color: AppColors.yellow, onTap: () {}),
            _buildStatusChip(icon: Assets.images.delievery.path, label: "Хүргэлтэнд гарсан", color: AppColors.orange, onTap: () {}),
            _buildStatusChip(icon: Assets.images.completed.path, label: "Хүргэгдсэн", color: AppColors.green, onTap: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip({required String icon, required String label, required Color color, required Function onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: InkWell(
        onTap: () => onTap(),
        child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
              color: color,
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  icon,
                  height: 18,
                  colorFilter: const ColorFilter.mode(
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
