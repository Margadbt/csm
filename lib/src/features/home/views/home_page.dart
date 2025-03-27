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
        // Default to 0 if no HomeScreenIndexChanged state has been emitted
        int currentIndex = state.homeScreenIndex ?? 0;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              // Wrap the content with AnimatedSwitcher for smooth opacity transition
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 150), // Duration of the fade transition
                transitionBuilder: (Widget child, Animation<double> animation) {
                  // Create a fade transition
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: _getPageForIndex(currentIndex), // Display the correct page based on the current index
              ),
              buildBottomNavBar(context: context, state: state),
            ],
          ),
        );
      },
    );
  }

  // Method to return the correct page based on the index
  Widget _getPageForIndex(int index) {
    switch (index) {
      case 0:
        return const HomeTabPage(key: ValueKey(0)); // HomeTabPage
      case 1:
        return const PackagesPage(key: ValueKey(1)); // PackagesPage
      case 2:
        return const ProfilePage(key: ValueKey(2)); // ProfilePage
      default:
        return const HomeTabPage(key: ValueKey(0)); // Default fallback to HomeTabPage
    }
  }

  // Method to build the bottom navigation bar with navigation buttons
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
                context.read<HomeCubit>().changeHomeScreenIndex(0);
              },
            ),
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
                context.read<HomeCubit>().changeHomeScreenIndex(2); // Change to correct index
              },
            ),
          ],
        ),
      ),
    );
  }
}
