import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

typedef PackagesRouteCallback = void Function(bool);

@RoutePage()
class PackagesRouteWrapper extends StatelessWidget {
  const PackagesRouteWrapper({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
