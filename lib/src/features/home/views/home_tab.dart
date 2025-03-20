import 'package:auto_route/auto_route.dart';
import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/home/views/widgets/header_widget.dart';
import 'package:csm/src/widgets/input_with_button.dart';
import 'package:csm/src/widgets/package_card.dart';
import 'package:csm/src/widgets/status_chips.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widgets/text.dart';
import '../cubit/home_cubit.dart';

@RoutePage()
class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  final TextEditingController _trackCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, count) => SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: [
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
                Align(alignment: Alignment.centerLeft, child: text(value: "Ачааны төлөвүүд:", fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                const StatusChips(),
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
                const SizedBox(height: 30),
                const PackageCard(
                  trackCode: 'J1123123123',
                  date: '2025/02/14',
                  description: "Blue pants",
                  amount: "12,000₮",
                  status: PackageStatus.completed,
                  id: '1',
                ),
                const SizedBox(height: 100),
              ]),
            ),
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
