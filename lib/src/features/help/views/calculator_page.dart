import 'package:auto_route/auto_route.dart';
import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/home/views/widgets/header_widget.dart';
import 'package:csm/src/widgets/button.dart';
import 'package:csm/src/widgets/card.dart';
import 'package:csm/src/widgets/input_with_prefix_icon.dart';
import 'package:csm/src/widgets/text.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';

@RoutePage()
class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final TextEditingController _weightController = TextEditingController();
  double? _price = 0;

  void _calculatePrice() {
    final weight = double.tryParse(_weightController.text);
    if (weight != null) {
      setState(() {
        _price = weight * 2500;
      });
    } else {
      setState(() {
        _price = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Жинг зөв оруулна уу'),
          duration: Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.background,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Header(
              icon: Assets.images.package.path,
              title: "Тооцоолуур",
              onTap: () => context.router.pop(),
            ),
            const SizedBox(height: 15),

            // Description text in Mongolian
            Align(
              alignment: Alignment.centerLeft,
              child: text(value: "Жинг килограммаар оруулаад үнийн тооцооллыг хийнэ үү.", color: ColorTheme.textColor, maxLine: 3),
            ),
            const SizedBox(height: 10),

            // Input field for weight
            InputWithPrefixIcon(
              controller: _weightController,
              placeholder: "Жин (кг)",
              prefixIconPath: Assets.images.package.path,
              onTap: () {},
            ),
            const SizedBox(height: 16),

            MyCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text(value: "Нийт үнэ:"),
                  const SizedBox(height: 8),
                  text(
                    value: "${_price!.toStringAsFixed(0)}₮",
                    color: ColorTheme.textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            // Calculate button
            const SizedBox(height: 20),
            MyButton(
              title: "Тооцоолох",
              onTap: _calculatePrice,
            ),
            const SizedBox(height: 20),

            // Show result if price is calculated
          ],
        ),
      ),
    );
  }
}
