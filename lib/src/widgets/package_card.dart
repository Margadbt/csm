import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/widgets/button.dart';
import 'package:csm/src/widgets/card.dart';
import 'package:csm/src/widgets/icon_circle.dart';
import 'package:csm/src/widgets/text.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    this.onTap,
  });

  final String trackCode;
  final DateTime date;
  final String? description;
  final PackageStatus status;
  final String? amount;
  final String id;
  final Function? onTap;

  /// Function to get icon and color based on status
  Map<String, dynamic> getStatusProperties() {
    switch (status) {
      case PackageStatus.inWarehouse:
        return {
          'icon': Assets.images.warehouse.path,
          'color': ColorTheme.blue,
          'buttonColor': ColorTheme.blue,
        };
      case PackageStatus.received:
        return {
          'icon': Assets.images.received.path,
          'color': ColorTheme.yellow,
          'buttonColor': ColorTheme.yellow,
        };
      case PackageStatus.delivery:
        return {
          'icon': Assets.images.delievery.path,
          'color': ColorTheme.orange,
          'buttonColor': ColorTheme.orange,
        };
      case PackageStatus.completed:
        return {
          'icon': Assets.images.completed.path,
          'color': ColorTheme.green,
          'buttonColor': ColorTheme.green,
        };
      default:
        return {
          'icon': Assets.images.warehouse.path,
          'color': ColorTheme.blue,
          'buttonColor': ColorTheme.blue,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final properties = getStatusProperties();
    final formattedDate = DateFormat('yyyy/MM/dd HH:mm').format(date);

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
                      text(value: formattedDate),
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
                      text(value: description ?? "Хоосон байна", fontWeight: FontWeight.bold),
                    ],
                  ),
                ),
              if (amount != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (amount != null && amount != "0") text(value: "Төлбөр", fontSize: 10),
                    if (amount != null && amount != "0") text(value: "${amount!}₮", fontWeight: FontWeight.bold),
                  ],
                ),
            ],
          ),
          if (onTap != null) const SizedBox(height: 20),
          if (onTap != null)
            MyButton(
              title: "Дэлгэрэнгүй",
              onTap: onTap!,
              color: properties['buttonColor'],
            ),
        ],
      ),
    );
  }
}
