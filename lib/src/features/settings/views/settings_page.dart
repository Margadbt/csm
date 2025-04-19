import 'package:auto_route/auto_route.dart';
import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/home/views/widgets/header_widget.dart';
import 'package:csm/src/features/packages/cubit/package_cubit.dart';
import 'package:csm/src/features/theme/cubit/theme_cubit.dart';
import 'package:csm/src/widgets/card.dart';
import 'package:csm/src/widgets/text.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _PackageDetailPageState();
}

class _PackageDetailPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.background,
      body: BlocBuilder<PackageCubit, PackagesState>(
        builder: (context, state) {
          if (state.isLoading) return const Center(child: CircularProgressIndicator());
          if (state.error != null) return Center(child: text(value: state.error!));

          final statuses = state.statuses ?? [];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Header(
                  icon: Assets.images.package.path,
                  title: "Тохиргоо",
                  onTap: () => context.router.pop(),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: Column(
                    children: [
                      MyCard(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                text(value: "Шөнийн горим идэвхижүүлэх", fontWeight: FontWeight.bold),
                                Switch.adaptive(
                                    value: context.read<ThemeCubit>().state,
                                    onChanged: (value) {
                                      context.read<ThemeCubit>().toggleTheme();
                                      setState(() {});
                                    })
                              ],
                            )
                          ]))
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
