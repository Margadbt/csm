import 'package:csm/src/features/home/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:csm/src/features/packages/cubit/package_cubit.dart';

class CreatePackageBottomSheet extends StatefulWidget {
  const CreatePackageBottomSheet({super.key});

  @override
  _CreatePackageBottomSheetState createState() => _CreatePackageBottomSheetState();
}

class _CreatePackageBottomSheetState extends State<CreatePackageBottomSheet> {
  final TextEditingController _trackCodeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Create a Package',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _trackCodeController,
            decoration: const InputDecoration(
              labelText: 'Track Code',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Create Button
          ElevatedButton(
            onPressed: () {
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
                  );

              Navigator.of(context).pop();
              context.read<HomeCubit>().getPackages();
            },
            child: const Text("Create Package"),
          ),
        ],
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
