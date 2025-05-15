import 'package:auto_route/auto_route.dart';
import 'package:csm/src/routes/app_router.dart';
import 'package:csm/src/widgets/button.dart';
import 'package:csm/src/widgets/text.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';

@RoutePage()
class PaymentSuccessfulPage extends StatefulWidget {
  const PaymentSuccessfulPage({super.key});

  @override
  State<PaymentSuccessfulPage> createState() => _PaymentSuccessfulPageState();
}

class _PaymentSuccessfulPageState extends State<PaymentSuccessfulPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onBackToHomePressed() {
    context.router.pop(); // Adjust this to your navigation logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.background,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _animation,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorTheme.green.withOpacity(0.3),
                ),
                padding: const EdgeInsets.all(24),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: ColorTheme.green,
                  size: 80,
                ),
              ),
            ),
            const SizedBox(height: 32),
            text(value: 'Төлбөр амжилттай төлөгдлөө!', fontSize: 24, fontWeight: FontWeight.bold, color: ColorTheme.textColor, maxLine: 2, align: TextAlign.center),
            const SizedBox(height: 12),
            text(
              value: 'Төлбөр төлсөнд баярлалаа.',
              align: TextAlign.center,
              fontSize: 16,
              color: ColorTheme.textColor.withOpacity(0.7),
            ),
            const SizedBox(height: 40),
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: _onBackToHomePressed,
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: ColorTheme.primary,
            //       padding: const EdgeInsets.symmetric(vertical: 16),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //     ),
            //     child: const Text(
            //       'Back to Home',
            //       style: TextStyle(fontSize: 16),
            //     ),
            //   ),
            // ),
            MyButton(
                title: "Нүүр хуудасруу буцах",
                onTap: () {
                  context.router.replaceAll([HomeRoute()]);
                })
          ],
        ),
      ),
    );
  }
}
