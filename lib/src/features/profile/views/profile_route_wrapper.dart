import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

typedef ProfileRouteCallback = void Function(bool);

@RoutePage()
class ProfileRouteWrapper extends StatelessWidget {
  const ProfileRouteWrapper({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
