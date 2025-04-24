import 'package:auto_route/auto_route.dart';
import 'package:csm/models/package_model.dart';
import 'package:csm/src/features/auth/views/login_page.dart';
import 'package:csm/src/features/auth/views/register_page.dart';
import 'package:csm/src/features/help/views/calculator_page.dart';
import 'package:csm/src/features/help/views/connect_address_page.dart';
import 'package:csm/src/features/help/views/contact_page.dart';
import 'package:csm/src/features/help/views/tutorial_page.dart';
import 'package:csm/src/features/home/views/home_page.dart';
import 'package:csm/src/features/home/views/home_tab.dart';
import 'package:csm/src/features/packages/views/package_detail.dart';
import 'package:csm/src/features/packages/views/packages_page.dart';
import 'package:csm/src/features/packages/views/payment_page.dart';
import 'package:csm/src/features/profile/views/address_info.dart';
import 'package:csm/src/features/profile/views/profile_page.dart';
import 'package:csm/src/features/profile/views/user_info.dart';
import 'package:csm/src/features/settings/views/settings_page.dart';
import 'package:flutter/material.dart';
part 'app_router.gr.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Page,Route',
)
class AppRouter extends _$AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();
  @override
  final List<AutoRoute> routes = [
    AutoRoute(page: HomeRoute.page, path: '/home'),
    AutoRoute(page: PackagesRoute.page, path: '/packages'),
    AutoRoute(page: ProfileRoute.page, path: '/profile'),
    AutoRoute(page: LoginRoute.page, path: '/login', initial: true),
    AutoRoute(page: RegisterRoute.page, path: '/register'),
    AutoRoute(page: PackageDetailRoute.page, path: '/package/detail'),
    AutoRoute(page: SettingsRoute.page, path: '/settings'),
    AutoRoute(page: PaymentRoute.page, path: '/payment'),
    AutoRoute(page: ConnectAddressRoute.page, path: '/connect-address'),
    AutoRoute(page: ContactRoute.page, path: '/contact'),
    AutoRoute(page: TutorialRoute.page, path: '/tutorial'),
    AutoRoute(page: CalculatorRoute.page, path: '/calculator'),
    AutoRoute(page: UserInfoRoute.page, path: '/user-info'),
    AutoRoute(page: AddressInfoRoute.page, path: '/address-info'),
  ];
}
