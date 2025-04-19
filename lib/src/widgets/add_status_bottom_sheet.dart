import 'dart:io';

import 'package:csm/gen/assets.gen.dart';
import 'package:csm/models/status_model.dart';
import 'package:csm/src/features/packages/cubit/package_cubit.dart';
import 'package:csm/src/widgets/button.dart';
import 'package:csm/src/widgets/input_with_prefix_icon.dart';
import 'package:csm/theme/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

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
  File? _imageFile;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _trackCodeController.text = widget.trackCode;

    bool registered = widget.statuses.any((s) => s.status == 0);
    bool inWareHouse = widget.statuses.any((s) => s.status == 1);
    bool isDelivered = widget.statuses.any((s) => s.status == 2);

    _statusController.text = 'Бүртгэсэн';
    if (registered) _statusController.text = 'Агуулахад ирсэн';
    if (inWareHouse) _statusController.text = 'Хүргэлтэд гарсан';
    if (isDelivered) _statusController.text = 'Хүргэгдсэн';
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final fileName = path.basename(image.path);
      final ref = FirebaseStorage.instance.ref().child('statuses/$fileName');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Image upload error: $e');
      return null;
    }
  }

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

  void _onSubmit() async {
    final statusCode = _getStatusCode();
    if (statusCode == 404) return;

    String imgUrl = '';
    if (_imageFile != null) {
      setState(() => _isUploading = true);
      final uploadedUrl = await _uploadImage(_imageFile!);
      setState(() => _isUploading = false);

      if (uploadedUrl != null) {
        imgUrl = uploadedUrl;
      }
    }

    context.read<PackageCubit>().addStatusToPackage(
          packageId: widget.packageId,
          status: statusCode,
          imgUrl: imgUrl,
        );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Create a Package', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            InputWithPrefixIcon(
              controller: _trackCodeController,
              placeholder: "Track Code",
              prefixIconPath: Assets.images.package.path,
              onTap: () {},
            ),
            const SizedBox(height: 16),
            InputWithPrefixIcon(
              controller: _statusController,
              enabled: false,
              placeholder: "Status",
              prefixIconPath: Assets.images.package.path,
              onTap: () {},
            ),
            const SizedBox(height: 16),
            if (_imageFile == null)
              MyButton(
                title: "Зураг оруулах",
                onTap: _pickImage,
                color: ColorTheme.primary,
              )
            else ...[
              Image.file(_imageFile!, height: 200),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 16),
            MyButton(
              title: _isUploading ? "Хадгалж байна..." : "Нэмэх",
              onTap: () {
                _isUploading ? null : _onSubmit();
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _trackCodeController.dispose();
    _statusController.dispose();
    super.dispose();
  }
}
