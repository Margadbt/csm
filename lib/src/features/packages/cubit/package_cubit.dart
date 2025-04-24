import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csm/models/status_model.dart';
import 'package:csm/repository/package_repository.dart';
import 'package:csm/src/features/auth/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:csm/models/package_model.dart';
import 'package:http/http.dart' as http;

class PackageCubit extends Cubit<PackagesState> {
  final PackageRepository _repository;

  PackageCubit(this._repository) : super(PackagesState.initial());

  Future<void> changeIndex(int index) async {
    emit(state.copyWith(index: index));
  }

  Future<void> createPackage({
    required BuildContext context,
    required String trackCode,
    String? description,
    String? phone,
    int? amount,
    bool? isPaid,
    int? status,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      final package = await _repository.createPackage(
        trackCode: trackCode,
        description: description,
        amount: amount ?? 0,
        isPaid: isPaid ?? false,
        status: status ?? 0,
        phone: phone ?? context.read<AuthCubit>().state.userModel!.phone,
      );
      emit(state.copyWith(package: package));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> fetchPackageById(String id) async {
    emit(state.copyWith(isLoading: true));
    try {
      final package = await _repository.getPackageById(id);
      emit(state.copyWith(package: package, isLoading: false));
      print("Package loaded: ${state.package?.trackCode}");
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> fetchPackageStatuses(String packageId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final statuses = await _repository.getStatusesByPackageId(packageId);
      emit(state.copyWith(statuses: statuses, isLoading: false));
      print("Statuses loaded: ${state.statuses?.length}");
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> addStatusToPackage({
    required String packageId,
    required int status,
    required String imgUrl,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _repository.addPackageStatus(
        packageId: packageId,
        status: status,
        imgUrl: imgUrl,
      );

      await _repository.updatePackageStatus(packageId: packageId, status: status);

      // Refresh statuses after adding
      await fetchPackageStatuses(packageId);
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> deleteStatusFromPackage({
    required String packageId,
    required String statusId,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _repository.deleteStatus(statusId);
      await fetchPackageStatuses(packageId); // Refresh status list
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}

class PackagesState {
  final bool isLoading;
  final String? error;
  final int? index;
  final PackageModel? package;
  final List<StatusModel>? statuses;

  PackagesState({
    this.isLoading = false,
    this.error,
    this.package,
    this.statuses,
    this.index = 0,
  });

  factory PackagesState.initial() {
    return PackagesState(package: PackageModel.empty(), statuses: []);
  }

  factory PackagesState.loading() {
    return PackagesState(isLoading: true);
  }

  factory PackagesState.statusesLoaded(List<StatusModel> statuses) {
    return PackagesState(statuses: statuses);
  }

  factory PackagesState.packageCreated(PackageModel package) {
    return PackagesState(package: package);
  }

  factory PackagesState.error(String error) {
    return PackagesState(error: error);
  }

  factory PackagesState.index(int index) {
    return PackagesState(index: index);
  }

  PackagesState copyWith({
    bool? isLoading,
    String? error,
    int? index,
    PackageModel? package,
    List<StatusModel>? statuses,
  }) {
    return PackagesState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      package: package ?? this.package,
      statuses: statuses ?? this.statuses,
      index: index ?? this.index,
    );
  }
}
