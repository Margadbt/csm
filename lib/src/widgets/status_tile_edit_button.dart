import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/widgets/icon_button.dart';
import 'package:csm/src/widgets/icon_circle.dart';
import 'package:csm/src/widgets/package_card.dart';
import 'package:csm/src/widgets/text.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatusTileEditButton extends StatelessWidget {
  final Function() onTap;

  const StatusTileEditButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ButtonIcon(
                width: 14,
                height: 14,
                color: ColorTheme.blue,
                iconColor: Colors.black,
                imagePath: Assets.images.plus.path,
                onTap: () {},
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text(value: "Төлөв нэмж оруулах", fontSize: 12, fontWeight: FontWeight.bold),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
