import 'package:csm/repository/package_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:csm/models/package_model.dart';

class PackageCubit extends Cubit<PackagesState> {
  final PackageRepository _repository;

  PackageCubit(this._repository) : super(PackagesState.initial());

  // Create a new package
  Future<void> createPackage({
    required String trackCode,
    String? description,
    int? amount,
    bool? isPaid,
    int? status,
  }) async {
    emit(PackagesState.loading());
    try {
      print("hi");
      // Create package in Firestore
      final package = await _repository.createPackage(
        trackCode: trackCode,
        description: description,
        amount: amount ?? 0,
        isPaid: isPaid ?? false,
        status: status ?? 0,
      );
      emit(PackagesState.packageCreated(package));
    } catch (e) {
      emit(PackagesState.error(e.toString()));
    }
  }
}

class PackagesState {
  final bool isLoading;
  final String? error;
  final PackageModel? package;

  PackagesState({
    this.isLoading = false,
    this.error,
    this.package,
  });

  // Initial state
  factory PackagesState.initial() {
    return PackagesState();
  }

  // Loading state
  factory PackagesState.loading() {
    return PackagesState(isLoading: true);
  }

  // Package created state
  factory PackagesState.packageCreated(PackageModel package) {
    return PackagesState(package: package);
  }

  // Error state
  factory PackagesState.error(String error) {
    return PackagesState(error: error);
  }
}
