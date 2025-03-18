import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonIcon extends StatelessWidget {
  const ButtonIcon({super.key, required this.imagePath, required this.onTap, this.color});
  final String imagePath;
  final Function onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1000),
              color: color ?? const Color(0xFF0C0C1C),
              border: color == null ? Border.all(color: const Color(0x1affffff), width: 1) : null,
            ),
            child: SvgPicture.asset(
              imagePath,
              fit: BoxFit.none,
              height: 18,
              width: 18,
            )));
  }
}
