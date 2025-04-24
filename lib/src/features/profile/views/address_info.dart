import 'package:auto_route/auto_route.dart';
import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/auth/cubit/auth_cubit.dart';
import 'package:csm/src/features/home/views/widgets/header_widget.dart';
import 'package:csm/src/widgets/button.dart';
import 'package:csm/src/widgets/in_development.dart';
import 'package:csm/src/widgets/input_with_prefix_icon.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class AddressInfoPage extends StatefulWidget {
  const AddressInfoPage({super.key});

  @override
  State<AddressInfoPage> createState() => _AddressInfoPageState();
}

class _AddressInfoPageState extends State<AddressInfoPage> {
  final _addressController = TextEditingController();

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
              title: "Хүргэлт авах хаяг",
              onTap: () => context.router.pop(),
            ),
            const SizedBox(height: 15),
            InputWithPrefixIcon(
              controller: _addressController,
              placeholder: "Хүргэлт авах хаяг...",
              prefixIconPath: Assets.images.location.path,
              onTap: () {},
            ),
            const SizedBox(height: 20),
            MyButton(
                title: "Хадгалах",
                onTap: () {
                  print("ha");
                  context.read<AuthCubit>().updateUserAddress(
                        address: _addressController.text.trim(),
                      );
                })
          ],
        ),
      ),
    );
  }
}
