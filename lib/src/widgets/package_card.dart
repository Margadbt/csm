import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/widgets/button.dart';
import 'package:csm/src/widgets/card.dart';
import 'package:csm/src/widgets/icon_circle.dart';
import 'package:csm/src/widgets/text.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';

enum PackageStatus { inWarehouse, received, delivery, completed }

class PackageCard extends StatelessWidget {
  const PackageCard({
    super.key,
    required this.trackCode,
    required this.date,
    this.description,
    required this.status,
    this.amount,
    required this.id,
  });

  final String trackCode;
  final String date;
  final String? description;
  final PackageStatus status;
  final String? amount;
  final String id;

  /// Function to get icon and color based on status
  Map<String, dynamic> getStatusProperties() {
    switch (status) {
      case PackageStatus.inWarehouse:
        return {
          'icon': Assets.images.warehouse.path,
          'color': AppColors.blue,
          'buttonColor': AppColors.blue,
        };
      case PackageStatus.received:
        return {
          'icon': Assets.images.received.path,
          'color': AppColors.yellow,
          'buttonColor': AppColors.yellow,
        };
      case PackageStatus.delivery:
        return {
          'icon': Assets.images.delievery.path,
          'color': AppColors.orange,
          'buttonColor': AppColors.orange,
        };
      case PackageStatus.completed:
        return {
          'icon': Assets.images.completed.path,
          'color': AppColors.green,
          'buttonColor': AppColors.green,
        };
      default:
        return {
          'icon': Assets.images.warehouse.path,
          'color': AppColors.blue,
          'buttonColor': AppColors.blue,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final properties = getStatusProperties();

    return MyCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconCircle(imagePath: Assets.images.package.path),
                  const SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text(value: trackCode, fontWeight: FontWeight.bold),
                      text(value: date),
                    ],
                  ),
                ],
              ),
              IconCircle(
                imagePath: properties['icon'],
                color: properties['color'],
                iconColor: Colors.black,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (description != null)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text(value: "Тайлбар", fontSize: 10),
                      text(value: description!, fontWeight: FontWeight.bold),
                    ],
                  ),
                ),
              if (amount != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    text(value: "Төлбөр", fontSize: 10),
                    text(value: amount!, fontWeight: FontWeight.bold),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 20),
          MyButton(
            title: "Дэлгэрэнгүй",
            onTap: () {},
            color: properties['buttonColor'],
          ),
        ],
      ),
    );
  }
}
