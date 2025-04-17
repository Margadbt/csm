import 'package:auto_route/auto_route.dart';
import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/auth/cubit/auth_cubit.dart';
import 'package:csm/src/features/home/views/home_tab.dart';
import 'package:csm/src/features/packages/views/packages_page.dart';
import 'package:csm/src/features/profile/views/profile_page.dart';
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
      listenWhen: (previous, current) {
        return previous.userModel != current.userModel;
      },
      listener: (context, state) {
        if (state.userModel == null && !state.isLoading) {
          context.router.replaceAll([LoginRoute()]);
        }
      },
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          int currentIndex = state.homeScreenIndex ?? 0;

          return Scaffold(
            backgroundColor: AppColors.background,
            body: Stack(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: _getPageForIndex(currentIndex),
                ),
                buildBottomNavBar(context: context, state: state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _getPageForIndex(int index) {
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

  Widget buildBottomNavBar({required BuildContext context, required HomeState state}) {
    final role = context.read<AuthCubit>().state.userModel?.role;
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        margin: EdgeInsets.symmetric(vertical: 25, horizontal: role == 'employee' ? size.width / 2.8 : size.width / 3.5),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.cardStroke, width: 1),
          color: AppColors.secondaryBg,
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
            if (role != 'employee')
              NavButtonIcon(
                selected: state.homeScreenIndex == 1,
                icon: Assets.images.package.path,
                onTap: () {
                  context.read<HomeCubit>().changeHomeScreenIndex(1);
                },
              ),
            NavButtonIcon(
              selected: state.homeScreenIndex == 2,
              icon: Assets.images.profileIcon.path,
              onTap: () {
                context.read<HomeCubit>().changeHomeScreenIndex(2);
              },
            ),
          ],
        ),
      ),
    );
  }
}
