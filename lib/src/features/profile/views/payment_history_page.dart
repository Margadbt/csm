import 'package:auto_route/auto_route.dart';
import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/home/views/widgets/header_widget.dart';
import 'package:csm/src/widgets/card.dart';
import 'package:csm/src/widgets/icon_circle.dart';
import 'package:csm/src/widgets/text.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

@RoutePage()
class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({super.key});

  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
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
              title: "Төлбөрийн түүх",
              onTap: () => context.router.pop(),
            ),
            const SizedBox(height: 12),
            paymentHistoryTile(
              trackCode: "123456789",
              date: DateTime.now(),
              amount: 100,
            ),
            const SizedBox(height: 12),
            paymentHistoryTile(
              trackCode: "123456789",
              date: DateTime.now(),
              amount: 100,
            ),
          ],
        ),
      ),
    );
  }

  Widget paymentHistoryTile({
    required String trackCode,
    required DateTime date,
    required double amount,
  }) {
    final formattedDate = DateFormat('yyyy/MM/dd HH:mm').format(date);

    return MyCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconCircle(imagePath: Assets.images.transaction.path),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            text(value: trackCode, fontWeight: FontWeight.bold),
                            text(value: formattedDate),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
