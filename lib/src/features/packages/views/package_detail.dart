import 'package:auto_route/auto_route.dart';
import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/packages/cubit/package_cubit.dart';
import 'package:csm/src/features/packages/views/payment_page.dart';
import 'package:csm/src/routes/app_router.dart';
import 'package:csm/src/widgets/button.dart';
import 'package:csm/src/widgets/package_card.dart';
import 'package:csm/src/widgets/status_tile.dart';
import 'package:csm/src/widgets/text.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/views/widgets/header_widget.dart';

@RoutePage()
class PackageDetailPage extends StatefulWidget {
  final String packageId;
  const PackageDetailPage({super.key, required this.packageId});

  @override
  State<PackageDetailPage> createState() => _PackageDetailPageState();
}

class _PackageDetailPageState extends State<PackageDetailPage> {
  @override
  void initState() {
    context.read<PackageCubit>().fetchPackageById(widget.packageId);
    context.read<PackageCubit>().fetchPackageStatuses(widget.packageId);
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
            print("Error of package detail: ${state.error!}");
            return Center(child: Text(state.error!));
          }

          final statuses = state.statuses ?? [];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Header(
                  icon: Assets.images.package.path,
                  title: "Ачааны дэлгэрэнгүй",
                  onTap: () => context.router.pop(),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: Column(
                    children: [
                      PackageCard(
                        isPaid: state.package!.isPaid,
                        trackCode: state.package!.trackCode,
                        date: state.package!.addedDate,
                        status: PackageStatus.values[state.package!.status],
                        id: state.package!.id,
                        description: state.package!.description,
                        amount: state.package!.amount,
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(children: [
                            if (statuses.isNotEmpty)
                              Column(
                                children: statuses.map((status) {
                                  return StatusTile(
                                    status: PackageStatus.values[status.status],
                                    date: status.date,
                                    imgUrl: status.imgUrl,
                                  );
                                }).toList(),
                              )
                          ]),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (state.package!.amount > 0 && state.package!.isPaid != true) ...[
                  MyButton(
                    title: "Төлбөр төлөх",
                    onTap: () {
                      context.router.push(PaymentRoute());
                    },
                  ),
                  const SizedBox(height: 20),
                ]
              ],
            ),
          );
        },
      ),
    );
  }
}
