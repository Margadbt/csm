import 'package:csm/gen/assets.gen.dart';
import 'package:csm/models/package_model.dart';
import 'package:csm/src/features/auth/cubit/auth_cubit.dart';
import 'package:csm/src/features/home/cubit/home_cubit.dart';
import 'package:csm/src/widgets/button.dart';
import 'package:csm/src/widgets/input_with_prefix_icon.dart';
import 'package:csm/src/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:csm/src/features/packages/cubit/package_cubit.dart';

class UpdatePackageBottomSheet extends StatefulWidget {
  const UpdatePackageBottomSheet({super.key, required this.package});
  final PackageModel package;

  @override
  _UpdatePackageBottomSheetState createState() => _UpdatePackageBottomSheetState();
}

class _UpdatePackageBottomSheetState extends State<UpdatePackageBottomSheet> {
  final TextEditingController _trackCodeController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  @override
  void initState() {
    _trackCodeController.text = widget.package.trackCode;
    _amountController.text = widget.package.amount.toString();
    _phoneController.text = widget.package.phone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            text(value: 'Ачаа барааны мэдээлэл шинэчлэх', fontWeight: FontWeight.bold),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: text(value: "Ачааны дугаар", fontSize: 12),
            ),
            const SizedBox(height: 4),
            InputWithPrefixIcon(
              hasBorder: true,
              controller: _trackCodeController,
              placeholder: "Ачааны дугаар...",
              prefixIconPath: Assets.images.package.path,
              onTap: () {},
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: text(value: "Утасны дугаар", fontSize: 12),
            ),
            const SizedBox(height: 4),
            InputWithPrefixIcon(
              hasBorder: true,
              controller: _phoneController,
              placeholder: "Утасны дугаар",
              prefixIconPath: Assets.images.package.path,
              onTap: () {},
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: text(value: "Тээврийн төлбөр", fontSize: 12),
            ),
            const SizedBox(height: 4),
            InputWithPrefixIcon(
              hasBorder: true,
              controller: _amountController,
              placeholder: "Тээврийн төлбөр",
              prefixIconPath: Assets.images.package.path,
              onTap: () {},
            ),
            const SizedBox(height: 16),
            MyButton(
                title: "Шинэчлэх",
                onTap: () {
                  String trackCode = _trackCodeController.text.trim();
                  String phone = _phoneController.text.trim();
                  int amount = int.parse(_amountController.text.trim());

                  context.read<PackageCubit>().updatePackage(
                        packageId: widget.package.id,
                        phone: phone,
                        trackCode: trackCode,
                        amount: amount,
                      );

                  Navigator.of(context).pop();
                  context.read<HomeCubit>().getAllPackages();
                }),
            const SizedBox(height: 30),
            // Create Button
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _trackCodeController.dispose();
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
