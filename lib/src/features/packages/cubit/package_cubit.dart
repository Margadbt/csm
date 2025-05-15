import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csm/models/status_model.dart';
import 'package:csm/models/transactions_model.dart';
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
      emit(state.copyWith(package: package, isLoading: false, error: null));
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

  Future<void> deleteAllDocumentsInCollection(String collectionPath) async {
    try {
      final collectionRef = FirebaseFirestore.instance.collection(collectionPath);
      final querySnapshot = await collectionRef.get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      print('✅ All documents in $collectionPath have been deleted.');
    } catch (e) {
      print('❌ Error deleting documents in $collectionPath: $e');
    }
  }

  Future<void> updatePackage({
    required String packageId,
    String? phone,
    int? amount,
    String? trackCode,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _repository.updatePackageById(
        packageId: packageId,
        phone: phone,
        amount: amount,
        trackCode: trackCode,
      );
      print(">>>>>>>>> $trackCode");

      // Optionally, re-fetch the updated package
      await fetchPackageById(packageId);
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> payPackage({
    required BuildContext context,
    required String packageId,
    required String packageTrackCode,
    required int amount,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _repository.payPackage(packageId: packageId, amount: amount, packageTrackCode: packageTrackCode);
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> clearPackageCubit() async {
    emit(PackagesState.initial());
  }

  Future<void> fetchTransactions() async {
    try {
      final transactions = await _repository.fetchTransaction();
      emit(state.copyWith(transactions: transactions, isLoading: false, error: null));
      print(" >>> Transactions loaded: ${state.transactions?.length}");
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
  final List<TransactionsModel>? transactions;

  PackagesState({
    this.isLoading = false,
    this.error,
    this.package,
    this.statuses,
    this.transactions,
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
    List<TransactionsModel>? transactions,
  }) {
    return PackagesState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      package: package ?? this.package,
      statuses: statuses ?? this.statuses,
      index: index ?? this.index,
      transactions: transactions ?? this.transactions,
    );
  }
}
