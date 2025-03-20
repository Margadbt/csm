import 'package:auto_route/auto_route.dart';
import 'package:csm/src/features/home/views/home_page.dart';
import 'package:csm/src/features/home/views/home_tab.dart';
import 'package:csm/src/features/packages/views/packages_page.dart';
import 'package:csm/src/features/profile/views/profile_page.dart';
part 'app_router.gr.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Page,Route',
)
class AppRouter extends _$AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();
  @override
  final List<AutoRoute> routes = [
    AutoRoute(page: HomeRoute.page, initial: true, path: '/home'),
    AutoRoute(page: PackagesRoute.page, path: '/packages'),
    AutoRoute(page: ProfileRoute.page, path: '/profile'),
  ];
}
