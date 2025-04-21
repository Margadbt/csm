import 'package:auto_route/auto_route.dart';
import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/auth/cubit/auth_cubit.dart';
import 'package:csm/src/features/home/views/widgets/create_package_bottom_sheet.dart';
import 'package:csm/src/features/home/views/widgets/employee_create.dart';
import 'package:csm/src/features/home/views/widgets/header_widget.dart';
import 'package:csm/src/features/packages/cubit/package_cubit.dart';
import 'package:csm/src/features/theme/cubit/theme_cubit.dart';
import 'package:csm/src/routes/app_router.dart';
import 'package:csm/src/widgets/button.dart';
import 'package:csm/src/widgets/home_card_widget.dart';
import 'package:csm/src/widgets/icon_button.dart';
import 'package:csm/src/widgets/input_with_button.dart';
import 'package:csm/src/widgets/package_card.dart';
import 'package:csm/src/widgets/status_chips.dart';
import 'package:csm/theme/colors.dart';
import 'package:csm/utils/math_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
    if (userRole != 'employee') {
      print(">>>>>> user role - home_tab ${userRole}");
      context.read<HomeCubit>().getPackages();
    } else {
      print(">>>>>> user role - home_tab ${userRole}");

      context.read<HomeCubit>().getAllPackages();
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('🔔 Foreground notification: ${message.notification?.title}');
      // You can show a dialog, snackbar, or local notification
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, state) {
        ColorTheme.isDark = state;
        return SafeArea(
          bottom: false,
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return Scaffold(
                backgroundColor: ColorTheme.background,
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Header(
                          profile: true,
                          settings: true,
                        ),
                        const SizedBox(height: 12),
                        if (state.userModel!.role != "employee") ...[
                          Container(
                            width: size.width,
                            child: InputWithButton(
                              controller: _trackCodeController,
                              placeholder: 'Ачааны дугаар...',
                              prefixIconPath: Assets.images.package.path,
                              buttonIconPath: Assets.images.plus.path,
                              onTap: () {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  enableDrag: true,
                                  showDragHandle: true,
                                  backgroundColor: ColorTheme.secondaryBg,
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
                                      builder: (context) {
                                        return EmployeeCreatePackageBottomSheet();
                                      },
                                    );
                                  })
                            ]),
                          ),
                        ],
                        const SizedBox(height: 20),
                        _buildHomeCards(),
                        if (state.userModel!.role != "employee") ...[
                          const SizedBox(height: 30),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: text(value: "Ачааны төлөвүүд:", fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          const StatusChips(),
                        ],
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: text(value: state.userModel!.role != "employee" ? "Сүүлд нэмэгдсэн тээвэрүүд:" : "Бүх тээврүүд:", fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        BlocBuilder<HomeCubit, HomeState>(
                          builder: (context, state) {
                            if (state.isLoading) {
                              return Center(
                                  child: CircularProgressIndicator(
                                color: ColorTheme.blue,
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
                                  ...state.packages!.take(3).map((package) => Container(
                                        padding: const EdgeInsets.symmetric(vertical: 6),
                                        child: PackageCard(
                                          trackCode: package.trackCode,
                                          date: package.addedDate,
                                          description: package.description,
                                          phone: userRole != 'employee' ? null : package.phone,
                                          status: PackageStatus.values[package.status],
                                          id: package.id,
                                          onTap: () {
                                            context.router.push(PackageDetailRoute(packageId: package.id));
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
                                          isScrollControlled: true,
                                          showDragHandle: true,
                                          backgroundColor: ColorTheme.secondaryBg,
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
      },
    );
  }

  Widget _buildHomeCards() {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: HomeCard(
                title: "Хаяг холбох",
                description: "Каргоны хаяг",
                icon: Assets.images.location.path,
                iconColor: ColorTheme.blue,
                onTap: () {
                  context.router.push(ConnectAddressRoute());
                },
              )),
              const SizedBox(width: 10),
              Expanded(
                  child: HomeCard(
                title: "Заавар",
                description: "Ашиглах заавар",
                icon: Assets.images.bulb.path,
                iconColor: ColorTheme.green,
                onTap: () {
                  context.router.push(TutorialRoute());
                },
              ))
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: HomeCard(
                title: "Тооцоолуур",
                description: "Тээврийн зардал",
                icon: Assets.images.calculator.path,
                iconColor: ColorTheme.orange,
                onTap: () {
                  context.router.push(CalculatorRoute());
                },
              )),
              const SizedBox(width: 10),
              Expanded(
                  child: HomeCard(
                title: "Холбоо барих",
                description: "Мэдээлэл авах",
                icon: Assets.images.contact.path,
                iconColor: ColorTheme.yellow,
                onTap: () {
                  context.router.push(ContactRoute());
                },
              ))
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _trackCodeController.dispose();
    super.dispose();
  }
}
