import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/widgets/icon_button.dart';
import 'package:csm/src/widgets/icon_circle.dart';
import 'package:csm/src/widgets/text.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final bool? profile;
  final String? icon;
  final String? title;
  final bool? settings;

  const Header({
    super.key,
    this.profile = false,
    this.icon,
    this.title,
    this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10), // Add padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensure proper spacing
        children: [
          if (title != null && icon != null)
            Row(
              children: [
                IconCircle(
                  imagePath: icon!,
                ),
                const SizedBox(width: 10),
                text(value: title!, fontWeight: FontWeight.bold, fontSize: 15),
              ],
            ),
          // Profile Section
          if (profile == true)
            Flexible(
              child: Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      fit: BoxFit.cover,
                      Assets.images.profile.path,
                      height: 50,
                      width: 50,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    // Ensures text does not overflow
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text(value: "Тавтай морил!", fontWeight: FontWeight.w900, fontSize: 15),
                        text(value: "Margad", fontWeight: FontWeight.bold, fontSize: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(width: 10),

          // Settings Icon
          if (settings == true) // Ensures space between elements
            ButtonIcon(imagePath: Assets.images.settingsIcon.path, onTap: () {}),
        ],
      ),
    );
  }
}
