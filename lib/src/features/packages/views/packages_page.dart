import 'package:auto_route/auto_route.dart';
import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/home/cubit/home_cubit.dart';
import 'package:csm/src/features/home/views/widgets/header_widget.dart';
import 'package:csm/src/features/packages/cubit/package_cubit.dart';
import 'package:csm/src/features/theme/cubit/theme_cubit.dart';
import 'package:csm/src/routes/app_router.dart';
import 'package:csm/src/widgets/input_with_button.dart';
import 'package:csm/src/widgets/package_card.dart';
import 'package:csm/src/widgets/text.dart';
import 'package:csm/theme/colors.dart';
import 'package:csm/utils/math_utils.dart';
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
  late Color _notSelectedColor;

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getPackages(); // Fetch packages
    _notSelectedColor = context.read<ThemeCubit>().state ? Colors.white : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: ColorTheme.background,
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
              Container(
                width: size.width,
                child: InputWithButton(
                  controller: _searchController,
                  placeholder: 'Track Code эсвэл Тайлбар...',
                  prefixIconPath: Assets.images.package.path,
                  buttonIconPath: Assets.images.search.path,
                  onTap: () {
                    setState(() {}); // Rebuild to trigger search filter
                  },
                ),
              ),
              const SizedBox(height: 16),

              // BlocBuilder to show packages
              Expanded(
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: ColorTheme.blue,
                        ),
                      );
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
                      final searchTerm = _searchController.text.toLowerCase();

                      final filtered = state.packages!
                          .where((p) => p.status == _selectedStatusIndex)
                          .where((p) => p.trackCode.toLowerCase().contains(searchTerm) || (p.description?.toLowerCase().contains(searchTerm) ?? false))
                          .toList();

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
                              date: p.addedDate,
                              description: p.description,
                              amount: p.amount.toString(),
                              status: PackageStatus.values[p.status],
                              onTap: () {
                                context.router.push(PackageDetailRoute(packageId: p.id));
                              },
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
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusTabBar() {
    final labels = ['Бүртгэсэн', 'Ирсэн', 'Хүргэлт', 'Авсан'];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: context.read<ThemeCubit>().state ? ColorTheme.blue.withOpacity(0) : Colors.black.withOpacity(0.03), // Customize as needed
            blurRadius: 5,
            offset: const Offset(0, 5),
          )
        ],
        color: ColorTheme.secondaryBg,
        borderRadius: BorderRadius.circular(40),
        border: context.read<ThemeCubit>().state ? Border.all(color: ColorTheme.cardStroke, width: 1) : null,
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
                  color: isSelected ? ColorTheme.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: text(
                    fontSize: 12,
                    value: labels[index],
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.black : _notSelectedColor,
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
