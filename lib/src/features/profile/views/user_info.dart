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
class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final userModel = context.read<AuthCubit>().state.userModel;
    if (userModel != null) {
      _usernameController.text = userModel.username ?? '';
      _phoneController.text = userModel.phone ?? '';
    }
  }

  void _saveUserInfo() {
    // TODO: Call update function (e.g. via cubit or repository)
    print("Username: ${_usernameController.text}");
    print("Phone: ${_phoneController.text}");
    print("Password: ${_passwordController.text}");
  }

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
              title: "Хэрэглэгчийн бүртгэл",
              onTap: () => context.router.pop(),
            ),
            const SizedBox(height: 15),
            InputWithPrefixIcon(
              controller: _usernameController,
              placeholder: "Хэрэглэгчийн нэр",
              prefixIconPath: Assets.images.profileIcon.path,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            InputWithPrefixIcon(
              controller: _phoneController,
              placeholder: "Утасны дугаар",
              prefixIconPath: Assets.images.profileIcon.path,
              onTap: () {},
            ),
            // const SizedBox(height: 12),
            // InputWithPrefixIcon(
            //   controller: _passwordController,
            //   placeholder: "Нууц үг",
            //   prefixIconPath: Assets.images.password.path,
            //   obscureText: true,
            //   onTap: () {},
            // ),
            const SizedBox(height: 20),
            MyButton(
                title: "Хадгалах",
                onTap: () {
                  print("ha");
                  context.read<AuthCubit>().updateUserInfo(
                        username: _usernameController.text.trim(),
                        phone: _phoneController.text.trim(),
                        password: _passwordController.text.trim(),
                      );
                })
          ],
        ),
      ),
    );
  }
}
