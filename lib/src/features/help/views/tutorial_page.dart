import 'package:auto_route/auto_route.dart';
import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/auth/cubit/auth_cubit.dart';
import 'package:csm/src/features/home/views/widgets/header_widget.dart';
import 'package:csm/src/widgets/card.dart';
import 'package:csm/src/widgets/text.dart';
import 'package:csm/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  Widget sectionTitle(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: text(
            value: title,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            maxLine: 2,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.read<AuthCubit>().state.userModel?.role == "employee";

    final tutorialList = <Map<String, dynamic>>[
      {
        'title': 'Ачаа бүртгэх',
        'description': [
          "Нүүр хуудаснаас “Ачаа нэмэх” товч дарна.",
          "Ачааны илгээмжийн дугаарыг оруулан мэдээллийг бөглөнө.",
        ],
        'color': 'blue',
      },
      {
        'title': 'Ачааны статус шалгах',
        'description': [
          "Нүүр хуудасны жагсаалт дээр ачаанууд харагдана.",
          "Тухайн ачааг сонгож, дэлгэрэнгүй мэдээллийг болон хүргэлтийн явцыг харах боломжтой.",
        ],
        'color': 'green',
      },
      if (isAdmin)
        {
          'title': 'Админ эрхээр',
          'description': [
            "Ачааны статус шинэчлэх (жишээ нь: 'Хүргэлтэд гарсан', 'Хүлээж авсан').",
            "Ачааны төлөвийг шинэчлэх үед зургийг даран оруулах.",
          ],
          'color': 'orange',
        },
      {
        'title': 'Мэдэгдэл хүлээн авах',
        'description': [
          "Таны бүртгүүлсэн төхөөрөмжинд ачааны статус өөрчлөгдөх үед notification буюу мэдэгдэл ирнэ.",
        ],
        'color': 'yellow',
      },
      {
        'title': 'Анхаарах зүйлс',
        'description': [
          "Ачааны мэдээллийг бүрэн, үнэн зөв оруулах.",
          "Хэрэглэгчид зөвхөн өөрийн бүртгэлтэй ачаануудыг харах боломжтой.",
        ],
        'color': 'red',
        'fontSize': 14.0,
      },
    ];
    Color getColorFromString(String colorName) {
      switch (colorName.toLowerCase()) {
        case 'blue':
          return ColorTheme.blue;
        case 'green':
          return ColorTheme.green;
        case 'orange':
          return ColorTheme.orange;
        case 'yellow':
          return ColorTheme.yellow;
        case 'red':
          return Colors.red;
        default:
          return Colors.grey; // fallback
      }
    }

    return Scaffold(
      backgroundColor: ColorTheme.background,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Header(
                icon: Assets.images.package.path,
                title: "Заавар",
                onTap: () => context.router.pop(),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: text(
                  value: "Апп хэрхэн ашиглах заавар",
                  color: ColorTheme.textColor,
                  maxLine: 3,
                ),
              ),
              const SizedBox(height: 12),
              ...tutorialList.map((item) {
                final String title = item['title'] as String;
                final List<String> descriptionList = List<String>.from(item['description']);
                final String colorStr = item['color'] as String;
                final Color color = getColorFromString(colorStr);
                final double fontSize = item['fontSize'] as double? ?? 15.0;
                final FontWeight fontWeight = item['fontWeight'] as FontWeight? ?? FontWeight.normal;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MyCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionTitle(title, color),
                        const SizedBox(height: 6),
                        ...descriptionList.map((line) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: text(
                                value: "- $line",
                                maxLine: 10,
                                fontSize: fontSize,
                                fontWeight: fontWeight,
                              ),
                            )),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
