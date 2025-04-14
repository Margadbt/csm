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
  void initState() {
    super.initState();
    context.read<HomeCubit>().getDeliveries(); // Fetch deliveries when the page is loaded
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              // Handle Loading State
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              // Handle Error State
              else if (state.errorMessage != null) {
                return Center(child: text(value: state.errorMessage!, color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20)); // Display error message(state.errorMessage!));
              }
              // Handle Deliveries Loaded State
              else if (state.deliveries != null && state.deliveries!.isNotEmpty) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const Header(
                        profile: true,
                        settings: true,
                      ),
                      const SizedBox(height: 12),
                      InputWithButton(
                        controller: _trackCodeController,
                        placeholder: 'Track Code...',
                        prefixIconPath: Assets.images.package.path,
                        buttonIconPath: Assets.images.plus.path,
                        onTap: () {},
                      ),
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: text(value: "Ачааны төлөвүүд:", fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      const StatusChips(),
                      const SizedBox(height: 30),
                      // Map over deliveries and display PackageCard widgets
                      ...state.deliveries!.map((delivery) => PackageCard(
                            trackCode: delivery.trackCode,
                            date: delivery.addedDate.toString(),
                            description: delivery.description,
                            status: PackageStatus.values[delivery.status], // Convert status to enum
                            id: delivery.id,
                          )),
                      const SizedBox(height: 100),
                    ],
                  ),
                );
              }
              // Handle case when there are no deliveries
              return const Center(child: Text('No deliveries found.'));
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _trackCodeController.dispose();
    super.dispose();
  }
}
