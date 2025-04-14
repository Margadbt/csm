import 'package:auto_route/auto_route.dart';
import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/home/views/widgets/create_package_bottom_sheet.dart';
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
    context.read<HomeCubit>().getPackages();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return const CreatePackageBottomSheet();
                      },
                    );
                  },
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: text(value: "Ачааны төлөвүүд:", fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const StatusChips(),
                const SizedBox(height: 30),
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.errorMessage != null) {
                      print(state.errorMessage);
                      return Center(
                        child: text(
                          value: state.errorMessage!,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          maxLine: 5,
                          fontSize: 12,
                        ),
                      );
                    } else if (state.packages != null && state.packages!.isNotEmpty) {
                      return Column(
                        children: [
                          ...state.packages!.map((package) => Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: PackageCard(
                                  trackCode: package.trackCode,
                                  date: package.addedDate.toString(),
                                  description: package.description,
                                  status: PackageStatus.values[package.status],
                                  id: package.id,
                                ),
                              )),
                          const SizedBox(height: 100),
                        ],
                      );
                    }
                    return Center(child: text(value: 'Ачаа, бараа олдсонгүй.'));
                  },
                ),
              ],
            ),
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
