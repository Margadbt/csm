import 'package:csm/gen/assets.gen.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SquareImageIcon extends StatelessWidget {
  final String? imagePath;
  final double size;
  final Color? borderColor;
  final Color? backgroundColor;

  const SquareImageIcon({
    super.key,
    this.imagePath,
    this.size = 40,
    this.borderColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    print("imgPath: $imagePath");
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: imagePath != null && imagePath!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imagePath!,
                width: 75,
                height: 75,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorTheme.cardStroke),
                      borderRadius: BorderRadius.circular(8),
                    ),
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
            )
          : Container(
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                border: Border.all(color: ColorTheme.cardStroke),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.asset(
                Assets.images.package.path,
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(ColorTheme.textColor, BlendMode.srcIn),
              ),
            ),
    );
  }
}
