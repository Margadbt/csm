import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

typedef HomeRouteCallback = void Function(bool);

@RoutePage()
class HomeRouteWrapper extends StatelessWidget {
  const HomeRouteWrapper({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
