import 'package:csm/src/features/theme/cubit/theme_cubit.dart';
import 'package:csm/src/widgets/text.dart';
import 'package:csm/theme/colors.dart';
import 'package:csm/utils/math_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InDevelopment extends StatelessWidget {
  const InDevelopment();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(alignment: Alignment.center, child: text(value: "Хөгжүүлэгдэж байна...")),
    );
  }
}
