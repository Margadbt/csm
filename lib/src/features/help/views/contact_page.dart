import 'package:auto_route/auto_route.dart';
import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/home/views/widgets/header_widget.dart';
import 'package:csm/src/widgets/card.dart';
import 'package:csm/src/widgets/text.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Future<void> _launchFacebook() async {
    final Uri url = Uri.parse('https://facebook.com');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Facebook-ийг нээж чадсангүй: $url';
    }
  }

  Future<void> _callPhone() async {
    final Uri phoneUrl = Uri.parse('tel:+97688112233');
    if (await canLaunchUrl(phoneUrl)) {
      await launchUrl(phoneUrl);
    } else {
      throw 'Утасны дугаар нээгдсэнгүй: $phoneUrl';
    }
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
              title: "Холбоо барих",
              onTap: () => context.router.pop(),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: text(value: "Хэрэв танд асуух зүйл, санал хүсэлт байвал бидэнтэй доорх сувгуудаар холбогдоно уу.", color: ColorTheme.textColor, maxLine: 3),
            ),
            const SizedBox(height: 30),

            // Facebook
            InkWell(
              onTap: _launchFacebook,
              child: MyCard(
                child: Row(
                  children: [
                    const Icon(Icons.facebook, color: Colors.blue),
                    const SizedBox(width: 10),
                    Text("Facebook хуудас", style: TextStyle(color: ColorTheme.textColor)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Phone call
            InkWell(
              onTap: _callPhone,
              child: MyCard(
                child: Row(
                  children: [
                    const Icon(Icons.phone, color: Colors.green),
                    const SizedBox(width: 10),
                    Text("88112233 дугаартай холбогдох", style: TextStyle(color: ColorTheme.textColor)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
