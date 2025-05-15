import 'package:auto_route/auto_route.dart';
import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/packages/cubit/package_cubit.dart';
import 'package:csm/src/widgets/card.dart';
import 'package:csm/src/widgets/icon_circle.dart';
import 'package:csm/src/widgets/text.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../home/views/widgets/header_widget.dart';

@RoutePage()
class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({super.key});

  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  @override
  void initState() {
    context.read<PackageCubit>().fetchTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.background,
      body: BlocBuilder<PackageCubit, PackagesState>(
        builder: (context, state) {
          if (state.isLoading) return Center(child: CircularProgressIndicator(color: ColorTheme.blue));

          if (state.error != null) {
            print("Error fetching transactions: \${state.error!}");
            return Center(child: Text(state.error!));
          }

          final transactions = state.transactions ?? [];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Header(
                  icon: Assets.images.package.path,
                  title: "Төлбөрийн түүх",
                  onTap: () => context.router.pop(),
                ),
                Expanded(
                  child: transactions.isEmpty
                      ? Center(child: text(value: "Төлбөрийн түүх алга."))
                      : ListView.separated(
                          itemCount: transactions.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final tx = transactions[index];
                            return paymentHistoryTile(
                              trackCode: tx.packageTrackCode,
                              date: tx.date,
                              amount: tx.amount,
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget paymentHistoryTile({
    required String trackCode,
    required DateTime date,
    required int amount,
  }) {
    final formattedDate = DateFormat('yyyy/MM/dd HH:mm').format(date);

    return MyCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconCircle(imagePath: Assets.images.transaction.path),
          const SizedBox(width: 10),
          Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              SizedBox(
                width: 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text(value: trackCode, fontWeight: FontWeight.bold),
                    text(value: formattedDate),
                  ],
                ),
              ),
              text(value: "$amount₮", fontSize: 18, color: Colors.green[700], fontWeight: FontWeight.bold),
            ]),
          ),
        ],
      ),
    );
  }
}
