import 'package:auto_route/auto_route.dart';
import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/home/views/widgets/header_widget.dart';
import 'package:csm/src/widgets/input_with_button.dart';
import 'package:csm/src/widgets/package_card.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/home_cubit.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _trackCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BlocBuilder<HomeCubit, int>(
            builder: (context, count) => Column(children: [
              const Header(
                profile: true,
                settings: true,
              ),
              const SizedBox(
                height: 14,
              ),
              InputWithButton(
                controller: _trackCodeController,
                placeholder: 'Track Code...',
                prefixIconPath: Assets.images.package.path,
                buttonIconPath: Assets.images.plus.path,
                onTap: () {},
              ),
              const SizedBox(height: 30),
              const PackageCard(
                trackCode: 'J1123123123',
                date: '2025/02/14',
                description: "Blue shirt",
                status: PackageStatus.inWarehouse,
                id: '1',
              ),
              const SizedBox(height: 30),
              const PackageCard(
                trackCode: 'J1123123123',
                date: '2025/02/14',
                description: "Blue pants",
                amount: "12,000₮",
                status: PackageStatus.delivery,
                id: '1',
              ),
            ]),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _trackCodeController.dispose(); // Dispose of the controller when the widget is disposed
    super.dispose();
  }
}
