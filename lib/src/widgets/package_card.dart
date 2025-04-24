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
    this.phone,
    required this.id,
    this.onTap,
  });

  final String trackCode;
  final DateTime date;
  final String? description;
  final PackageStatus status;
  final String? amount;
  final String? phone;
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

    final cardContent = MyCard(
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
                      if (phone != null)
                        Row(
                          children: [
                            text(value: "${phone!} -", fontWeight: FontWeight.bold),
                            const SizedBox(width: 6),
                            text(value: trackCode, fontWeight: FontWeight.bold),
                          ],
                        )
                      else
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
          if (description != null && description != "") ...[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text(value: "Тайлбар", fontSize: 10),
                      text(value: description!, fontWeight: FontWeight.bold),
                    ],
                  ),
                ),
                if (amount != null && amount != "0")
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      text(value: "Төлбөр", fontSize: 10),
                      text(value: "${amount!}₮", fontWeight: FontWeight.bold),
                    ],
                  ),
              ],
            ),
          ],
        ],
      ),
    );

    // Conditionally return InkWell only if onTap is not null
    return onTap != null
        ? Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onTap?.call(),
              splashColor: properties['color'].withOpacity(0.2),
              highlightColor: properties['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(10), // match MyCard radius
              child: cardContent,
            ),
          )
        : cardContent;
  }
}
