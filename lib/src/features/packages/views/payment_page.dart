import 'package:auto_route/auto_route.dart';
import 'package:csm/gen/assets.gen.dart';
import 'package:csm/models/package_model.dart';
import 'package:csm/src/features/auth/cubit/auth_cubit.dart';
import 'package:csm/src/features/home/views/widgets/header_widget.dart';
import 'package:csm/src/features/packages/cubit/package_cubit.dart';
import 'package:csm/src/routes/app_router.dart';
import 'package:csm/src/widgets/add_status_bottom_sheet.dart';
import 'package:csm/src/widgets/button.dart';
import 'package:csm/src/widgets/card.dart';
import 'package:csm/src/widgets/package_card.dart';
import 'package:csm/src/widgets/status_tile.dart';
import 'package:csm/src/widgets/status_tile_edit_button.dart';
import 'package:csm/src/widgets/text.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

@RoutePage()
class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PackageDetailPageState();
}

class _PackageDetailPageState extends State<PaymentPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.background,
      body: BlocBuilder<PackageCubit, PackagesState>(
        builder: (context, state) {
          if (state.isLoading)
            return Center(
                child: CircularProgressIndicator(
              color: ColorTheme.blue,
            ));
          if (state.error != null) return Center(child: text(value: state.error!));

          final statuses = state.statuses ?? [];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Header(
                  icon: Assets.images.package.path,
                  title: "Төлбөр төлөх",
                  onTap: () => context.router.pop(),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: Column(
                    children: [
                      PackageCard(
                        trackCode: state.package!.trackCode,
                        date: state.package!.addedDate,
                        status: PackageStatus.values[state.package!.status],
                        id: state.package!.id,
                        description: state.package!.description,
                        amount: state.package!.amount,
                        isPaid: state.package!.isPaid,
                      ),
                      const SizedBox(height: 20),
                      // Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: text(value: "Төлбөрийн сонголтоо хийнэ үү"),
                      // ),
                      // const SizedBox(height: 12),
                      // MyCard(
                      //   child: Row(
                      //     children: [
                      //       InkWell(
                      //         child: Row(
                      //           children: [
                      //             Image.asset(
                      //               Assets.images.byl.path,
                      //               height: 50,
                      //               width: 50,
                      //             ),
                      //             const SizedBox(width: 10),
                      //             text(value: "Byl", fontWeight: FontWeight.bold)
                      //           ],
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      MyCard(
                        child: Row(
                          children: [
                            InkWell(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // const SizedBox(width: 10),
                                  // const SizedBox(width: 10),
                                  text(value: "Төлбөрийн дүн:", fontSize: 12),
                                  const SizedBox(width: 10),
                                  text(value: state.package!.amount.toString() + "₮", fontWeight: FontWeight.bold, fontSize: 25)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                MyButton(
                    title: "Төлбөр төлөх",
                    onTap: () {
                      context.read<PackageCubit>().payPackage(context: context, packageId: state.package!.id, amount: state.package!.amount, packageTrackCode: state.package!.trackCode);
                      context.router.push(PaymentSuccessfulRoute());
                      // Future.delayed(const Duration(seconds: 1), () {
                      //   context.router.popForced();
                      //   context.router.popAndPush(PackageDetailRoute(packageId: state.package!.id));
                      // });
                    }),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
