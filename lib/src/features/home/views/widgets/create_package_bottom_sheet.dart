import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/auth/cubit/auth_cubit.dart';
import 'package:csm/src/features/home/cubit/home_cubit.dart';
import 'package:csm/src/widgets/button.dart';
import 'package:csm/src/widgets/input_with_prefix_icon.dart';
import 'package:csm/src/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:csm/src/features/packages/cubit/package_cubit.dart';

class CreatePackageBottomSheet extends StatefulWidget {
  const CreatePackageBottomSheet({super.key, this.trackCode = ""});
  final String trackCode;

  @override
  _CreatePackageBottomSheetState createState() => _CreatePackageBottomSheetState();
}

class _CreatePackageBottomSheetState extends State<CreatePackageBottomSheet> {
  final TextEditingController _trackCodeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late String? userRole;
  @override
  void initState() {
    _trackCodeController.text = widget.trackCode;
    userRole = context.read<AuthCubit>().state.userModel?.role;
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
            text(value: 'Ачаа бараа, илгээмж нэмэх', fontWeight: FontWeight.bold),
            const SizedBox(height: 16),

            InputWithPrefixIcon(
              hasBorder: true,
              controller: _trackCodeController,
              placeholder: "Ачааны дугаар...",
              prefixIconPath: Assets.images.package.path,
              onTap: () {},
            ),
            const SizedBox(height: 16),
            if (userRole != "employee") ...[
              InputWithPrefixIcon(
                hasBorder: true,
                controller: _descriptionController,
                placeholder: "Тайлбар",
                prefixIconPath: Assets.images.package.path,
                onTap: () {},
              ),
              const SizedBox(height: 16),
            ] else ...[
              InputWithPrefixIcon(
                hasBorder: true,
                controller: _descriptionController,
                placeholder: "Утасны дугаар",
                prefixIconPath: Assets.images.package.path,
                onTap: () {},
              ),
              const SizedBox(height: 16),
            ],
            MyButton(
                title: "Нэмэх",
                onTap: () {
                  String trackCode = _trackCodeController.text.trim();
                  String description = _descriptionController.text.trim();

                  if (trackCode.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Track Code cannot be empty')),
                    );
                    return;
                  }

                  context.read<PackageCubit>().createPackage(
                        trackCode: trackCode,
                        description: description,
                        context: context,
                      );

                  Navigator.of(context).pop();
                  context.read<HomeCubit>().getPackages();
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
    _descriptionController.dispose();
    super.dispose();
  }
}
