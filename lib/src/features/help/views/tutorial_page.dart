import 'package:auto_route/auto_route.dart';
import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/home/views/widgets/header_widget.dart';
import 'package:csm/src/widgets/in_development.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';

@RoutePage()
class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.background,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Header(
              icon: Assets.images.package.path,
              title: "Заавар",
              onTap: () => context.router.pop(),
            ),
            const SizedBox(height: 15),
            InDevelopment()
          ],
        ),
      ),
    );
  }
}
