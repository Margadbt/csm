import 'package:auto_route/auto_route.dart';
import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/auth/cubit/auth_cubit.dart';
import 'package:csm/src/features/home/views/employee_home_tab.dart';
import 'package:csm/src/features/home/views/home_tab.dart';
import 'package:csm/src/features/packages/views/packages_page.dart';
import 'package:csm/src/features/profile/views/profile_page.dart';
import 'package:csm/src/features/theme/cubit/theme_cubit.dart';
import 'package:csm/src/routes/app_router.dart';
import 'package:csm/src/widgets/bottom_nav_bar_button.dart';
import 'package:csm/theme/colors.dart';
import 'package:csm/utils/math_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/home_cubit.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) => previous.userModel != current.userModel,
      listener: (context, state) {
        // if (state.userModel == null && !state.isLoading) {
        //   context.router.replaceAll([LoginRoute()]);
        // }
      },
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDark) {
          ColorTheme.isDark = isDark;
          return BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              final role = context.read<AuthCubit>().state.userModel?.role;
              final isEmployee = role == 'employee';

              // Clamp index to 0-1 if employee
              int currentIndex = state.homeScreenIndex ?? 0;
              if (isEmployee && currentIndex > 1) {
                currentIndex = 0;
                context.read<HomeCubit>().changeHomeScreenIndex(0);
              }

              return Scaffold(
                backgroundColor: ColorTheme.background,
                body: Stack(
                  children: [
                    // AnimatedSwitcher(
                    //   duration: const Duration(milliseconds: 150),
                    //   transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                    //   child: _getPageForIndex(currentIndex, isEmployee),
                    // ),
                    _getPageForIndex(currentIndex, isEmployee),
                    _buildBottomNavBar(context: context, state: state, isEmployee: isEmployee),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _getPageForIndex(int index, bool isEmployee) {
    if (isEmployee) {
      switch (index) {
        case 0:
          return const EmployeeHomeTabPage(key: ValueKey(0));
        case 1:
          return const ProfilePage(key: ValueKey(1));
        default:
          return const HomeTabPage(key: ValueKey(0));
      }
    } else {
      switch (index) {
        case 0:
          return const HomeTabPage(key: ValueKey(0));
        case 1:
          return const PackagesPage(key: ValueKey(1));
        case 2:
          return const ProfilePage(key: ValueKey(2));
        default:
          return const HomeTabPage(key: ValueKey(0));
      }
    }
  }

  Widget _buildBottomNavBar({
    required BuildContext context,
    required HomeState state,
    required bool isEmployee,
  }) {
    final double navMargin = isEmployee ? size.width / 2.8 : size.width / 3.5;

    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        margin: EdgeInsets.symmetric(vertical: 25, horizontal: navMargin),
        decoration: BoxDecoration(
          border: Border.all(color: ColorTheme.cardStroke, width: 1),
          color: ColorTheme.secondaryBg,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NavButtonIcon(
              selected: state.homeScreenIndex == 0,
              icon: Assets.images.home.path,
              onTap: () {
                context.read<HomeCubit>().changeHomeScreenIndex(0);
              },
            ),
            if (!isEmployee)
              NavButtonIcon(
                selected: state.homeScreenIndex == 1,
                icon: Assets.images.package.path,
                onTap: () {
                  context.read<HomeCubit>().changeHomeScreenIndex(1);
                },
              ),
            NavButtonIcon(
              selected: isEmployee ? state.homeScreenIndex == 1 : state.homeScreenIndex == 2,
              icon: Assets.images.profileIcon.path,
              onTap: () {
                if (context.read<AuthCubit>().state.userModel != null) {
                  final newIndex = isEmployee ? 1 : 2;
                  context.read<HomeCubit>().changeHomeScreenIndex(newIndex);
                } else {
                  context.router.push(LoginRoute());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
