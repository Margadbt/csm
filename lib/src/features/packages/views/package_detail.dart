import 'package:auto_route/auto_route.dart';
import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/home/views/widgets/header_widget.dart';
import 'package:csm/src/features/packages/cubit/package_cubit.dart';
import 'package:csm/src/widgets/package_card.dart';
import 'package:csm/src/widgets/status_tile.dart';
import 'package:csm/src/widgets/text.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class PackageDetailPage extends StatefulWidget {
  const PackageDetailPage({super.key});

  @override
  State<PackageDetailPage> createState() => _PackageDetailPageState();
}

class _PackageDetailPageState extends State<PackageDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<PackageCubit, PackagesState>(
        builder: (context, state) {
          if (state.isLoading) return const Center(child: CircularProgressIndicator());
          if (state.error != null) return Center(child: text(value: state.error!));

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
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      PackageCard(
                        trackCode: state.package!.trackCode,
                        date: state.package!.addedDate,
                        status: PackageStatus.values[state.package!.status],
                        id: state.package!.id,
                        description: state.package!.description,
                        amount: state.package!.amount.toString(),
                      ),
                      const SizedBox(height: 24),
                      if (statuses.isEmpty)
                        StatusTile(
                          status: PackageStatus.values[0],
                          date: state.package!.addedDate,
                        )
                      else
                        Column(
                          children: statuses.map((status) {
                            return StatusTile(
                              status: PackageStatus.values[status.status],
                              date: status.date,
                              imgUrl: status.imgUrl,
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
