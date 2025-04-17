import 'package:csm/gen/assets.gen.dart';
import 'package:csm/models/status_model.dart';
import 'package:csm/src/features/home/cubit/home_cubit.dart';
import 'package:csm/src/widgets/button.dart';
import 'package:csm/src/widgets/input_with_prefix_icon.dart';
import 'package:csm/src/widgets/selector_with_prefix_icon.dart';
import 'package:csm/src/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:csm/src/features/packages/cubit/package_cubit.dart';

class AddStatusBottomSheet extends StatefulWidget {
  final String packageId;
  final String trackCode;
  final List<StatusModel> statuses;
  const AddStatusBottomSheet({
    super.key,
    required this.packageId,
    required this.trackCode,
    required this.statuses,
  });

  @override
  _AddStatusBottomSheetState createState() => _AddStatusBottomSheetState();
}

class _AddStatusBottomSheetState extends State<AddStatusBottomSheet> {
  final TextEditingController _trackCodeController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  late List<String> items;

  @override
  void initState() {
    _trackCodeController.text = widget.trackCode;

    bool registered = widget.statuses.any((s) => s.status == 0);
    bool inWareHouse = widget.statuses.any((s) => s.status == 1);
    bool isDelivered = widget.statuses.any((s) => s.status == 2);

    _statusController.text = 'Бүртгэсэн';
    if (registered) _statusController.text = 'Агуулахад ирсэн';
    if (inWareHouse) _statusController.text = 'Хүргэлтэд гарсан';
    if (isDelivered) _statusController.text = 'Хүргэгдсэн';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          text(value: 'Create a Package', fontWeight: FontWeight.bold),
          const SizedBox(height: 16),

          InputWithPrefixIcon(
            controller: _trackCodeController,
            placeholder: "Status",
            prefixIconPath: Assets.images.package.path,
            onTap: () {},
          ),
          const SizedBox(height: 16),
          InputWithPrefixIcon(
            controller: _statusController,
            enabled: false,
            placeholder: "Track Code",
            prefixIconPath: Assets.images.package.path,
            onTap: () {},
          ),
          const SizedBox(height: 16),

          MyButton(
              title: "Нэмэх",
              onTap: () {
                int _getStatusCode() {
                  switch (_statusController.text) {
                    case 'Бүртгэсэн':
                      return 0;
                    case 'Агуулахад ирсэн':
                      return 1;
                    case 'Хүргэлтэд гарсан':
                      return 2;
                    case 'Хүргэгдсэн':
                      return 3;
                    default:
                      return 404;
                  }
                }

                if (_getStatusCode() != 404) {
                  context.read<PackageCubit>().addStatusToPackage(
                        packageId: widget.packageId,
                        status: _getStatusCode(),
                        imgUrl: '',
                      );
                }

                Navigator.of(context).pop();
              }),
          const SizedBox(height: 30),
          // Create Button
        ],
      ),
    );
  }

  @override
  void dispose() {
    _trackCodeController.dispose();
    super.dispose();
  }
}
