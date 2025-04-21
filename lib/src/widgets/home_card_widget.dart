import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/widgets/button.dart';
import 'package:csm/src/widgets/card.dart';
import 'package:csm/src/widgets/icon_circle.dart';
import 'package:csm/src/widgets/text.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  final String title;
  final String description;
  final String icon;
  final Color iconColor;
  final Function onTap;

  /// Function to get icon and color based on statu

  @override
  Widget build(BuildContext context) {
    return MyCard(
      hasBorder: false,
      padding: EdgeInsets.all(18),
      radius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                icon,
                height: 32,
                colorFilter: ColorFilter.mode(
                  iconColor, // Replace with your color
                  BlendMode.srcIn, // Ensures the color replaces the original SVG color
                ),
              ),
              SvgPicture.asset(
                Assets.images.simpleArrow.path,
                height: 12,
                width: 12,
                colorFilter: ColorFilter.mode(
                  ColorTheme.textColor,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          text(
            value: title,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          text(value: description, fontSize: 12, color: ColorTheme.textColor),
        ],
      ),
    );

    // Conditionally return InkWell only if onTap is not null
  }
}
