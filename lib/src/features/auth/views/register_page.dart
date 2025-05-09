import 'package:auto_route/auto_route.dart';
import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/auth/cubit/auth_cubit.dart';
import 'package:csm/src/widgets/button.dart';
import 'package:csm/src/widgets/card.dart';
import 'package:csm/src/widgets/icon_circle.dart';
import 'package:csm/src/widgets/input_with_prefix_icon.dart';
import 'package:csm/src/widgets/text.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.background,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.userModel != null) {
            context.router.pushNamed('/home');
          } else if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconCircle(
                imagePath: Assets.images.profileIcon.path,
                size: 100,
                padding: 30,
              ),
              const SizedBox(height: 20),
              MyCard(
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: Column(
                  children: [
                    text(
                      value: "Бүртгүүлэх",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 20),
                    InputWithPrefixIcon(
                      hasBorder: true,
                      controller: _phoneController,
                      placeholder: "Утасны дугаар",
                      prefixIconPath: Assets.images.profileIcon.path,
                      onTap: () {},
                    ),
                    const SizedBox(height: 10),
                    InputWithPrefixIcon(
                      hasBorder: true,
                      controller: _emailController,
                      placeholder: "И-Мэйл хаяг",
                      prefixIconPath: Assets.images.profileIcon.path,
                      onTap: () {},
                    ),
                    const SizedBox(height: 10),
                    InputWithPrefixIcon(
                      hasBorder: true,
                      obscureText: true,
                      controller: _passwordController,
                      placeholder: "Нууц үг",
                      prefixIconPath: Assets.images.password.path,
                      onTap: () {},
                    ),
                    const SizedBox(height: 20),
                    MyButton(
                        color: ColorTheme.blue,
                        title: "Бүртгүүлэх",
                        onTap: () {
                          context.read<AuthCubit>().registerUser(
                                context: context,
                                email: _emailController.text,
                                password: _passwordController.text,
                                phone: _phoneController.text,
                              );
                        },
                        heightLimitSet: true),
                    TextButton(
                      onPressed: () {
                        context.router.maybePop();
                      },
                      child: Text("Буцах", style: TextStyle(color: ColorTheme.textColor)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
