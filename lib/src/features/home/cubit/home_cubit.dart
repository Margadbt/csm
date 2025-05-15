import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csm/models/package_model.dart';
import 'package:csm/models/user_model.dart';
import 'package:csm/repository/package_repository.dart';
import 'package:csm/src/routes/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final PackageRepository _packageRepository = PackageRepository(FirebaseFirestore.instance, FirebaseAuth.instance);

  HomeCubit() : super(HomeState.initial(homeScreenIndex: 0)) {}

  Future<void> getPackages() async {
    // emit(HomeState.loading(homeScreenIndex: state.homeScreenIndex));

    // try {
    //   String? userId = await UserPrefs.getUserId();
    //   print("getPackages userId: $userId");

    //   if (userId != null && userId.isNotEmpty) {
    //     final packages = await _packageRepository.getPackagesForUser(userId);
    //     emit(HomeState.packagesLoaded(packages, homeScreenIndex: state.homeScreenIndex));
    //   } else {
    //     emit(HomeState.error("User ID not found", homeScreenIndex: state.homeScreenIndex));
    //   }
    // } catch (e) {
    //   emit(HomeState.error(e.toString(), homeScreenIndex: state.homeScreenIndex));
    // }
    String? userPhone = await UserPrefs.getUserPhone();
    print("getPackages userId: $userPhone");
    if (userPhone == null) return;
    await fetchPackagesByPhoneNumber(userPhone!);
  }

  Future<void> getAllPackages() async {
    emit(HomeState.loading(homeScreenIndex: state.homeScreenIndex, packageScreenIndex: state.packageScreenIndex));
    try {
      final packages = await _packageRepository.fetchAll();

      emit(HomeState.packagesLoaded(packages, homeScreenIndex: state.homeScreenIndex, packageScreenIndex: state.packageScreenIndex));
    } catch (e) {
      emit(HomeState.error(e.toString(), homeScreenIndex: state.homeScreenIndex, packageScreenIndex: state.packageScreenIndex));
    }
  }

  Future<void> fetchPackagesByPhoneNumber(String phoneNumber) async {
    emit(HomeState.loading(homeScreenIndex: state.homeScreenIndex, packageScreenIndex: state.packageScreenIndex));
    try {
      // Fetch packages using the repository
      final packages = await _packageRepository.getPackagesByPhoneNumber(phoneNumber);

      // Update the state with the fetched packages
      emit(HomeState.packagesLoaded(packages, homeScreenIndex: state.homeScreenIndex, packageScreenIndex: state.packageScreenIndex));
    } catch (e) {
      emit(HomeState.error(e.toString(), homeScreenIndex: state.homeScreenIndex, packageScreenIndex: state.packageScreenIndex));
    }
  }

  void changeHomeScreenIndex(int index) async {
    String? userPhone = await UserPrefs.getUserPhone();
    if (index == 0 && userPhone != null) {
      getPackages();
    }
    emit(HomeState(
      homeScreenIndex: index,
      packageScreenIndex: state.packageScreenIndex,
      packages: state.packages,
      errorMessage: state.errorMessage,
      isLoading: state.isLoading,
    ));
  }

  void changePackageScreenIndex(int index) {
    emit(HomeState(
      homeScreenIndex: state.homeScreenIndex,
      packageScreenIndex: index,
      packages: state.packages,
      errorMessage: state.errorMessage,
      isLoading: state.isLoading,
    ));
  }
}

class HomeState {
  final int? homeScreenIndex;
  final int? packageScreenIndex;
  final List<PackageModel>? packages;
  final String? errorMessage;
  final bool isLoading;

  HomeState({
    this.homeScreenIndex = 0,
    this.packageScreenIndex,
    this.packages,
    this.errorMessage,
    this.isLoading = false,
  });

  factory HomeState.initial({int? homeScreenIndex, int? packageScreenIndex}) {
    return HomeState(homeScreenIndex: homeScreenIndex, packageScreenIndex: packageScreenIndex);
  }

  factory HomeState.loading({int? homeScreenIndex, int? packageScreenIndex}) {
    return HomeState(homeScreenIndex: homeScreenIndex, isLoading: true);
  }

  factory HomeState.packagesLoaded(List<PackageModel> packages, {int? homeScreenIndex, int? packageScreenIndex}) {
    return HomeState(homeScreenIndex: homeScreenIndex, packages: packages);
  }

  factory HomeState.error(String errorMessage, {int? homeScreenIndex, int? packageScreenIndex}) {
    return HomeState(homeScreenIndex: homeScreenIndex, errorMessage: errorMessage);
  }
}
