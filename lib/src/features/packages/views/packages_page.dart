import 'package:auto_route/auto_route.dart';
import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/home/views/widgets/header_widget.dart';
import 'package:csm/src/widgets/bottom_nav_bar_button.dart';
import 'package:csm/src/widgets/package_card.dart';
import 'package:csm/src/widgets/status_chips.dart';
import 'package:csm/theme/colors.dart';
import 'package:csm/utils/math_utils.dart';
import 'package:flutter/material.dart';
import '../../../widgets/text.dart';

@RoutePage()
class PackagesPage extends StatefulWidget {
  const PackagesPage({super.key});

  @override
  State<PackagesPage> createState() => _PackagesPageState();
}

class _PackagesPageState extends State<PackagesPage> {
  final TextEditingController _trackCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: [
                Header(
                  icon: Assets.images.package.path,
                  title: "Ачаанууд",
                ),
                const SizedBox(height: 12),
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
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _trackCodeController.dispose(); // Dispose of the controller when the widget is disposed
    super.dispose();
  }
}
