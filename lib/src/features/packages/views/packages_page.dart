import 'package:auto_route/auto_route.dart';
import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/home/cubit/home_cubit.dart';
import 'package:csm/src/features/home/views/widgets/header_widget.dart';
import 'package:csm/src/widgets/input_with_button.dart';
import 'package:csm/src/widgets/input_with_prefix_icon.dart';
import 'package:csm/src/widgets/package_card.dart';
import 'package:csm/src/widgets/text.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/home/views/widgets/header_widget.dart';
import 'package:csm/src/widgets/input_with_button.dart';
import 'package:csm/src/widgets/package_card.dart';
import 'package:csm/src/widgets/text.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class PackagesPage extends StatefulWidget {
  const PackagesPage({super.key});

  @override
  State<PackagesPage> createState() => _PackagesPageState();
}

class _PackagesPageState extends State<PackagesPage> {
  final TextEditingController _trackCodeController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  int _selectedStatusIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getPackages(); // Fetch packages
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Header(
                icon: Assets.images.package.path,
                title: "Ачаанууд",
              ),
              const SizedBox(height: 12),

              _buildStatusTabBar(),
              const SizedBox(height: 16),

              // Search field
              InputWithButton(
                controller: _searchController,
                placeholder: 'Track Code...',
                prefixIconPath: Assets.images.package.path,
                buttonIconPath: Assets.images.search.path,
                onTap: () {
                  // Optional: trigger a search
                },
              ),
              const SizedBox(height: 16),

              // BlocBuilder to show packages
              Expanded(
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ));
                    } else if (state.errorMessage != null) {
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
                      final filtered = state.packages!.where((p) => p.status == _selectedStatusIndex).toList();

                      if (filtered.isEmpty) {
                        return Center(child: text(value: 'Хоосон байна.'));
                      }

                      return ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final p = filtered[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: PackageCard(
                              trackCode: p.trackCode,
                              date: p.addedDate.toString(),
                              description: p.description,
                              amount: p.amount.toString(),
                              status: PackageStatus.values[p.status],
                              id: p.id,
                            ),
                          );
                        },
                      );
                    }
                    return Center(child: text(value: 'Ачаа, бараа олдсонгүй.'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusTabBar() {
    final labels = ['Агуулах', 'Ирсэн', 'Хүргэлт', 'Авсан'];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.secondaryBg,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: AppColors.cardStroke, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(labels.length, (index) {
          final isSelected = _selectedStatusIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedStatusIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFE7C9F9) : Colors.transparent,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: text(
                    value: labels[index],
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    _trackCodeController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
