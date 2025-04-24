import 'package:auto_route/auto_route.dart';
import 'package:csm/gen/assets.gen.dart';
import 'package:csm/src/features/home/views/widgets/header_widget.dart';
import 'package:csm/src/widgets/card.dart';
import 'package:csm/theme/colors.dart';
import 'package:csm/src/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@RoutePage()
class ConnectAddressPage extends StatefulWidget {
  const ConnectAddressPage({super.key});

  @override
  State<ConnectAddressPage> createState() => _ConnectAddressPageState();
}

class _ConnectAddressPageState extends State<ConnectAddressPage> {
  final List<Map<String, String>> addresses = [
    {"title": "收件人 (Хүлээн авагч)", "value": "烸嵪 (Өөрийн утасны дугаар)"},
    {"title": "电话 (Утас)", "value": "15847901990"},
    {"title": "所在地区 (Бүс нутаг)", "value": "内蒙古自治区 锡林郭勒盟 二连浩特市社区建设管理局"},
    {"title": "街道地址 (Хаяг)", "value": "浩特汇通物流园区C05号 (Өөрийн утасны дугаар)"},
    {"title": "邮编 (Зип код)", "value": "011100"},
  ];

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Амжилттай хуулагдлаа!'),
        duration: Duration(milliseconds: 500),
      ),
    );
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
              title: "Хаяг холбох",
              onTap: () => context.router.pop(),
            ),
            const SizedBox(height: 15),
            text(value: "Доорх хаягуудыг Taobao, Pinduodo, Poizon гэх мэт хятад захиалгад ашиглан холбогдох байршлуудаа сонгон хуулж ашиглаарай.", fontSize: 14, maxLine: 10),
            const SizedBox(height: 20),
            ...addresses.map((address) => Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    children: [
                      Align(alignment: Alignment.centerLeft, child: text(value: address['title']!, fontWeight: FontWeight.bold, fontSize: 12, align: TextAlign.start)),
                      const SizedBox(height: 4),
                      MyCard(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                text(value: address['value']!, fontSize: 14, maxLine: 3),
                              ]),
                            ),
                            IconButton(
                              onPressed: () => copyToClipboard(address['value']!),
                              icon: const Icon(Icons.copy),
                              tooltip: 'Хаяг хуулах',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
