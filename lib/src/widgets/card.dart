import 'package:csm/theme/colors.dart';
import 'package:flutter/widgets.dart';

class MyCard extends StatelessWidget {
  const MyCard({super.key, this.padding = 16, this.child, this.radius = 30});
  final double padding;
  final Widget? child;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.cardStroke, width: 1),
          color: AppColors.secondaryBg, // Background color
          borderRadius: BorderRadius.circular(radius)),
      child: child,
    );
  }
}
