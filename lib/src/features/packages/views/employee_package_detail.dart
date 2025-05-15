import 'package:auto_route/auto_route.dart';
import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/packages/cubit/package_cubit.dart';
import 'package:csm/src/widgets/button.dart';
import 'package:csm/src/widgets/package_card.dart';
import 'package:csm/src/widgets/package_update_bottom_sheet.dart';
import 'package:csm/src/widgets/status_tile.dart';
import 'package:csm/src/widgets/status_tile_edit_button.dart';
import 'package:csm/src/widgets/text.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/views/widgets/header_widget.dart';
import '../../../widgets/add_status_bottom_sheet.dart';

@RoutePage()
class EmployeePackageDetailPage extends StatefulWidget {
  final String packageId;
  const EmployeePackageDetailPage({super.key, required this.packageId});

  @override
  State<EmployeePackageDetailPage> createState() => _EmployeePackageDetailPageState();
}

class _EmployeePackageDetailPageState extends State<EmployeePackageDetailPage> {
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
                                  return Dismissible(
                                    key: ValueKey(status.statusId),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (direction) {
                                      context.read<PackageCubit>().deleteStatusFromPackage(
                                            packageId: widget.packageId,
                                            statusId: status.statusId,
                                          );
                                    },
                                    background: Container(
                                      alignment: Alignment.center,
                                      color: Colors.red,
                                      child: const Icon(Icons.delete, color: Colors.white),
                                    ),
                                    child: StatusTile(
                                      status: PackageStatus.values[status.status],
                                      date: status.date,
                                      imgUrl: status.imgUrl,
                                    ),
                                  );
                                }).toList(),
                              ),
                            if (statuses.any((s) => s.status == 3) != true)
                              StatusTileEditButton(onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  enableDrag: true,
                                  showDragHandle: true,
                                  isScrollControlled: true,
                                  backgroundColor: ColorTheme.secondaryBg,
                                  builder: (context) {
                                    return AddStatusBottomSheet(
                                      trackCode: state.package!.trackCode,
                                      packageId: state.package!.id,
                                      statuses: state.statuses!,
                                    );
                                  },
                                );
                              })
                          ]),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                MyButton(
                  title: "Шинэчлэх",
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      enableDrag: true,
                      showDragHandle: true,
                      isScrollControlled: true,
                      backgroundColor: ColorTheme.secondaryBg,
                      builder: (context) {
                        return UpdatePackageBottomSheet(
                          package: state.package!,
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
