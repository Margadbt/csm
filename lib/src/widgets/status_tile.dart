import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/widgets/icon_circle.dart';
import 'package:csm/src/widgets/package_card.dart';
import 'package:csm/src/widgets/text.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatusTile extends StatelessWidget {
  final PackageStatus status;
  final DateTime date;
  final String? imgUrl;

  const StatusTile({
    super.key,
    required this.status,
    required this.date,
    this.imgUrl,
  });

  Map<String, dynamic> getStatusProperties() {
    switch (status) {
      case PackageStatus.inWarehouse:
        return {
          'icon': Assets.images.warehouse.path,
          'text': "Бүртгэсэн",
        };
      case PackageStatus.received:
        return {
          'icon': Assets.images.received.path,
          'text': "Агуулахад ирсэн",
        };
      case PackageStatus.delivery:
        return {
          'icon': Assets.images.delievery.path,
          'text': "Хүргэлтэд гарсан",
        };
      case PackageStatus.completed:
        return {
          'icon': Assets.images.completed.path,
          'text': "Хүлээж авсан",
        };
      default:
        return {
          'icon': Assets.images.warehouse.path,
          'text': "",
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final properties = getStatusProperties();
    final formattedDate = DateFormat('yyyy/MM/dd HH:mm').format(date);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconCircle(
              imagePath: properties['icon'],
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text(value: properties['text'], fontSize: 14, fontWeight: FontWeight.w600),
                const SizedBox(height: 2),
                text(value: formattedDate, fontSize: 14),
              ],
            ),
          ],
        ),
        if (imgUrl != null && imgUrl! != "") ...[
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imgUrl!,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
        const SizedBox(height: 20),
      ],
    );
  }
}
