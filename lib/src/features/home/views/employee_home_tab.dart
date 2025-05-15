import 'package:auto_route/auto_route.dart';
import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/home/views/widgets/employee_create.dart';
import 'package:csm/src/features/home/views/widgets/header_widget.dart';
import 'package:csm/src/features/theme/cubit/theme_cubit.dart';
import 'package:csm/src/routes/app_router.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widgets/button.dart';
import '../../../widgets/icon_button.dart';
import '../../../widgets/input_with_button.dart';
import '../../../widgets/package_card.dart';
import '../../../widgets/text.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../cubit/home_cubit.dart';
import '../../packages/cubit/package_cubit.dart';

@RoutePage()
class EmployeeHomeTabPage extends StatefulWidget {
  const EmployeeHomeTabPage({super.key});

  @override
  State<EmployeeHomeTabPage> createState() => _EmployeeHomeTabPageState();
}

class _EmployeeHomeTabPageState extends State<EmployeeHomeTabPage> {
  final TextEditingController _trackCodeController = TextEditingController();

  @override
  void initState() {
    context.read<HomeCubit>().getAllPackages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, state) {
        ColorTheme.isDark = state;
        return SafeArea(
          bottom: false,
          child: Scaffold(
            backgroundColor: ColorTheme.background,
            body: RefreshIndicator(
              onRefresh: () async {
                await context.read<HomeCubit>().getAllPackages();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const Header(profile: true, settings: true),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: InputWithButton(
                              controller: _trackCodeController,
                              placeholder: 'Утасны дугаар',
                              prefixIconPath: Assets.images.package.path,
                              buttonIconPath: Assets.images.search.path,
                              onTap: () {
                                final phone = _trackCodeController.text.trim();
                                if (phone.isNotEmpty) {
                                  context.read<HomeCubit>().fetchPackagesByPhoneNumber(phone);
                                } else {
                                  context.read<HomeCubit>().getAllPackages();
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          ButtonIcon(
                            imagePath: Assets.images.plus.path,
                            color: ColorTheme.primary,
                            iconColor: Colors.black,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                enableDrag: true,
                                showDragHandle: true,
                                backgroundColor: ColorTheme.secondaryBg,
                                builder: (context) => EmployeeCreatePackageBottomSheet(),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: text(value: "Бүх тээврүүд:", fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) {
                          if (state.isLoading) {
                            return Center(child: CircularProgressIndicator(color: ColorTheme.blue));
                          } else if (state.errorMessage != null) {
                            return Center(child: text(value: state.errorMessage!, color: Colors.red));
                          } else if (state.packages != null && state.packages!.isNotEmpty) {
                            return Column(
                              children: state.packages!
                                  .take(20)
                                  .map((package) => Container(
                                        padding: const EdgeInsets.symmetric(vertical: 6),
                                        child: PackageCard(
                                          isPaid: package.isPaid,
                                          trackCode: package.trackCode,
                                          date: package.addedDate,
                                          amount: package.amount,
                                          img: package.img,
                                          description: package.description,
                                          phone: package.phone,
                                          status: PackageStatus.values[package.status],
                                          id: package.id,
                                          onTap: () {
                                            context.router.push(EmployeePackageDetailRoute(packageId: package.id));
                                          },
                                        ),
                                      ))
                                  .toList(),
                            );
                          } else {
                            return Column(
                              children: [
                                const SizedBox(height: 100),
                                text(value: "Ачаа, бараа олдсонгүй.", fontWeight: FontWeight.bold),
                                const SizedBox(height: 12),
                                MyButton(
                                  title: "Ачаа нэмэх",
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      enableDrag: true,
                                      isScrollControlled: true,
                                      showDragHandle: true,
                                      backgroundColor: ColorTheme.secondaryBg,
                                      builder: (context) => EmployeeCreatePackageBottomSheet(),
                                    );
                                  },
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _trackCodeController.dispose();
    super.dispose();
  }
}
