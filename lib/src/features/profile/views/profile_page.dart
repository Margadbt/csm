import 'package:auto_route/auto_route.dart';
import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/auth/cubit/auth_cubit.dart';
import 'package:csm/src/features/home/views/widgets/header_widget.dart';
import 'package:csm/src/routes/app_router.dart';
import 'package:csm/src/widgets/card.dart';
import 'package:csm/src/widgets/text.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _trackCodeController = TextEditingController();

  final List<Map<String, dynamic>> profileItems = [
    {"title": "Хэрэглэгчийн бүртгэл", "onTap": () {}},
    {"title": "Холбоо барих", "onTap": () {}},
    {"title": "Хаягийн жагсаалт", "onTap": () {}},
    {"title": "Карго холбох", "onTap": () {}},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: ColorTheme.background,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Header(
                  icon: Assets.images.profileIcon.path,
                  title: "Хэрэглэгч",
                ),
                const SizedBox(height: 12),
                MyCard(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: List.generate(profileItems.length, (index) {
                      return Column(
                        children: [
                          buildRow(
                            value: profileItems[index]["title"] as String,
                            onTap: profileItems[index]["onTap"] as VoidCallback,
                          ),
                          if (index < profileItems.length - 1) const SizedBox(height: 12),
                          if (index < profileItems.length - 1) Divider(color: ColorTheme.cardStroke),
                          if (index < profileItems.length - 1) const SizedBox(height: 12),
                        ],
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 18),
                MyCard(
                    padding: EdgeInsets.all(20),
                    child: buildRow(
                        value: "Гарах",
                        onTap: () {
                          context.read<AuthCubit>().logout();
                          context.pushRoute(LoginRoute());
                        })),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRow({required String value, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          text(value: value),
          SvgPicture.asset(
            Assets.images.rightArrow.path,
            height: 12,
            width: 12,
            colorFilter: ColorFilter.mode(
              ColorTheme.iconColor,
              BlendMode.srcIn,
            ),
          ),
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
