import 'package:auto_route/auto_route.dart';
import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/auth/cubit/auth_cubit.dart';
import 'package:csm/src/features/home/views/widgets/create_package_bottom_sheet.dart';
import 'package:csm/src/features/home/views/widgets/employee_create.dart';
import 'package:csm/src/features/home/views/widgets/header_widget.dart';
import 'package:csm/src/features/packages/cubit/package_cubit.dart';
import 'package:csm/src/routes/app_router.dart';
import 'package:csm/src/widgets/button.dart';
import 'package:csm/src/widgets/icon_button.dart';
import 'package:csm/src/widgets/input_with_button.dart';
import 'package:csm/src/widgets/package_card.dart';
import 'package:csm/src/widgets/status_chips.dart';
import 'package:csm/theme/colors.dart';
import 'package:csm/utils/math_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widgets/text.dart';
import '../cubit/home_cubit.dart';

@RoutePage()
class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  final TextEditingController _trackCodeController = TextEditingController();
  late String? userRole;

  @override
  void initState() {
    userRole = context.read<AuthCubit>().state.userModel?.role;
    if (userRole != 'employee') context.read<HomeCubit>().getPackages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const Header(
                      profile: true,
                      settings: true,
                    ),
                    const SizedBox(height: 12),
                    if (state.userModel!.role != "employee") ...[
                      Container(
                        width: size.width,
                        child: InputWithButton(
                          controller: _trackCodeController,
                          placeholder: 'Track Code...',
                          prefixIconPath: Assets.images.package.path,
                          buttonIconPath: Assets.images.plus.path,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              enableDrag: true,
                              showDragHandle: true,
                              backgroundColor: AppColors.secondaryBg,
                              builder: (context) {
                                return CreatePackageBottomSheet(
                                  trackCode: _trackCodeController.text,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ] else ...[
                      Container(
                        width: size.width,
                        child: Row(children: [
                          InputWithButton(
                            controller: _trackCodeController,
                            placeholder: 'Утасны дугаар',
                            prefixIconPath: Assets.images.package.path,
                            buttonIconPath: Assets.images.search.path,
                            onTap: () {},
                          ),
                          const SizedBox(width: 12),
                          ButtonIcon(
                              imagePath: Assets.images.plus.path,
                              color: AppColors.blue,
                              iconColor: Colors.black,
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  enableDrag: true,
                                  showDragHandle: true,
                                  backgroundColor: AppColors.secondaryBg,
                                  builder: (context) {
                                    return EmployeeCreatePackageBottomSheet();
                                  },
                                );
                              })
                        ]),
                      ),
                    ],
                    if (state.userModel!.role != "employee") ...[
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: text(value: "Ачааны төлөвүүд:", fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      const StatusChips(),
                    ],
                    const SizedBox(height: 20),
                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        if (state.isLoading) {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ));
                        } else if (state.errorMessage != null) {
                          return Center(
                            child: text(
                              value: state.errorMessage!,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              maxLine: 5,
                              fontSize: 12,
                            ),
                          );
                        } else if (state.packages != null && state.packages!.isNotEmpty) {
                          return Column(
                            children: [
                              ...state.packages!.map((package) => Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: PackageCard(
                                      trackCode: package.trackCode,
                                      date: package.addedDate,
                                      description: package.description,
                                      status: PackageStatus.values[package.status],
                                      id: package.id,
                                      onTap: () {
                                        context.read<PackageCubit>().navigateToPackageDetail(context: context, packageId: package.id);
                                      },
                                    ),
                                  )),
                              const SizedBox(height: 100),
                            ],
                          );
                        }
                        if (userRole != 'employee')
                          return Center(child: text(value: 'Ачаа, бараа олдсонгүй.'));
                        else {
                          return Center(
                              child: Column(
                            children: [
                              SizedBox(height: 100),
                              text(value: "Ачаа, бараа олдсонгүй.", fontWeight: FontWeight.bold),
                              SizedBox(height: 12),
                              MyButton(
                                  title: "Ачаа нэмэх",
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      enableDrag: true,
                                      showDragHandle: true,
                                      backgroundColor: AppColors.secondaryBg,
                                      builder: (context) {
                                        return EmployeeCreatePackageBottomSheet();
                                      },
                                    );
                                  }),
                            ],
                          ));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _trackCodeController.dispose();
    super.dispose();
  }
}
