import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/auth/cubit/auth_cubit.dart';
import 'package:csm/src/widgets/icon_button.dart';
import 'package:csm/src/widgets/icon_circle.dart';
import 'package:csm/src/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Header extends StatelessWidget {
  final bool? profile;
  final String? icon;
  final String? title;
  final bool? settings;
  final Function? onTap;

  const Header({
    super.key,
    this.profile = false,
    this.icon,
    this.title,
    this.settings,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (title != null && icon != null)
            Row(
              children: [
                if (onTap != null)
                  ButtonIcon(imagePath: Assets.images.leftArrow.path, onTap: () => onTap!())
                else
                  IconCircle(
                    imagePath: icon!,
                  ),
                const SizedBox(width: 10),
                text(value: title!, fontWeight: FontWeight.bold, fontSize: 15),
              ],
            ),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text(value: "Тавтай морил!", fontWeight: FontWeight.w900, fontSize: 15),
                        text(value: context.read<AuthCubit>().state.userModel?.phone ?? "", fontWeight: FontWeight.bold, fontSize: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(width: 10),
          if (settings == true) ButtonIcon(imagePath: Assets.images.settingsIcon.path, onTap: () {}),
        ],
      ),
    );
  }
}
