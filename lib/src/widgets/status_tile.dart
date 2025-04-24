import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/packages/cubit/package_cubit.dart';
import 'package:csm/src/widgets/icon_circle.dart';
import 'package:csm/src/widgets/package_card.dart';
import 'package:csm/src/widgets/text.dart';
import 'package:csm/theme/colors.dart';
import 'package:csm/utils/math_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                if (imgUrl != null && imgUrl! != "") ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imgUrl!,
                      width: size.width - 110,
                      height: 280,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 280,
                          width: size.width - 110,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            color: ColorTheme.blue,
                            strokeWidth: 2,
                            value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1) : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 75,
                          height: 75,
                          color: Colors.grey[300],
                          alignment: Alignment.center,
                          child: Icon(Icons.broken_image, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
            // IconButton(
            //     onPressed: () async {
            //       final confirm = await showDialog<bool>(
            //         context: context,
            //         builder: (context) => AlertDialog(
            //           title: Text('Confirm Deletion'),
            //           content: Text('Are you sure you want to delete this status?'),
            //           actions: [
            //             TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
            //             TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Delete')),
            //           ],
            //         ),
            //       );

            //       if (confirm == true) {
            //         context.read<PackageCubit>().deleteStatusFromPackage(
            //               packageId: 'yourPackageId',
            //               statusId: 'statusIdToDelete',
            //             );
            //       }
            //     },
            //     icon: Icon(Icons.delete))
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
