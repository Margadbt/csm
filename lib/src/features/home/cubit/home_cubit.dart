import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_cubit.freezed.dart';
part 'home_cubit.g.dart';
// My part files
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.initial());

  void changeHomeScreenIndex(BuildContext context, int index) async {
    emit(state.copyWith(homeScreenIndex: index));
  }
}
