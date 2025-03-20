import 'package:auto_route/auto_route.dart';
import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/home/views/home_tab.dart';
import 'package:csm/src/features/packages/views/packages_page.dart';
import 'package:csm/src/features/profile/views/profile_page.dart';
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
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              // Wrap the content with AnimatedSwitcher for smooth opacity transition
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 150), // Adjust duration to control the speed of the fade
                transitionBuilder: (Widget child, Animation<double> animation) {
                  // Create a fade transition
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: state.homeScreenIndex == 0
                    ? const HomeTabPage(key: ValueKey(0)) // Use ValueKey for smooth transition
                    : state.homeScreenIndex == 1
                        ? const PackagesPage(key: ValueKey(1)) // Same for PackagesPage
                        : const ProfilePage(key: ValueKey(2)),
              ),
              buildBottomNavBar(context: context, state: state),
            ],
          ),
        );
      },
    );
  }

  Widget buildBottomNavBar({required BuildContext context, required HomeState state}) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        margin: EdgeInsets.symmetric(vertical: 25, horizontal: size.width / 3.5),
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
                context.read<HomeCubit>().changeHomeScreenIndex(context, 0);
              },
            ),
            NavButtonIcon(
              selected: state.homeScreenIndex == 1,
              icon: Assets.images.package.path,
              onTap: () {
                context.read<HomeCubit>().changeHomeScreenIndex(context, 1);
              },
            ),
            NavButtonIcon(
              selected: state.homeScreenIndex == 2,
              icon: Assets.images.profileIcon.path,
              onTap: () {
                context.read<HomeCubit>().changeHomeScreenIndex(context, 2); // Change to correct index
              },
            ),
          ],
        ),
      ),
    );
  }
}
