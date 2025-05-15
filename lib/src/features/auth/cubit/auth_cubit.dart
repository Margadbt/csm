import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:csm/models/user_model.dart';
import 'package:csm/repository/auth_repository.dart';
import 'package:csm/src/features/packages/cubit/package_cubit.dart';
import 'package:csm/src/routes/app_router.dart';
import 'package:csm/utils/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Auth Cubit
class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _firebaseAuth;
  final AuthRepository _authRepository; // Declare the repository

  AuthCubit(this._firebaseAuth, this._authRepository) : super(AuthState.initial()) {
    _firebaseAuth.authStateChanges().listen((User? user) async {
      if (await UserPrefs.getUserId() != "" && user != null) {
        await _loadUserData(user.uid);
      }
    });
  }

  Future<void> _saveUserToPrefs(UserModel userModel) async {
    final prefs = await SharedPreferences.getInstance();
    print("><><><><><><> ${userModel.phone}");
    await prefs.setString('userId', userModel.userId ?? '');
    await prefs.setString('userEmail', userModel.email ?? '');
    await prefs.setString('userPhone', userModel.phone ?? '');
  }

// Clear user info
  Future<void> _clearUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userEmail');
    await prefs.remove('userPhone');
  }

  Future<void> registerUser({
    required BuildContext context,
    required String email,
    required String password,
    required String phone,
  }) async {
    print(">>>>>>>>> Registering user...");
    emit(AuthState.loading());
    try {
      UserModel userModel = await _authRepository.registerUser(email, password, phone);
      emit(AuthState.authenticated(userModel));
      print(">>>>>>>>> User registered: ${userModel.email}");
      print(">>>>>>>>> User registered: ${userModel.phone}");
      await _saveUserToPrefs(userModel);
      if (Platform.isAndroid) {
        await NotificationService.updateToken();
      }
      context.router.replaceAll([LoginRoute()]);
    } catch (e) {
      emit(AuthState.error(e.toString()));
      print(">>>>>>>>> Registration failed: $e");
    }
  }

  Future<void> loginUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    print(">>>>>>>>> Logging in...");
    emit(AuthState.loading());
    try {
      UserModel userModel = await _authRepository.loginUser(email, password);
      print(">>>>>>>>> User logged in: ${userModel.email}");
      await _saveUserToPrefs(userModel);
      emit(AuthState.authenticated(userModel));
      if (Platform.isAndroid) {
        await NotificationService.updateToken();
      }
    } catch (e) {
      emit(AuthState.error(e.toString()));
      print(">>>>>>>>> Login failed: $e");
    }
  }

  Future<void> logout(BuildContext context) async {
    print(">>>>>>>>> Logging out...");
    emit(AuthState.initial());
    await _firebaseAuth.signOut();
    await _clearUserFromPrefs();
    print(">>>>>>>>> User logged out.");
  }

  Future<void> _loadUserData(String uid) async {
    print(">>>>>>>>> Loading user data...");
    try {
      UserModel? userModel = await _authRepository.getCurrentUser();
      if (userModel != null) {
        emit(AuthState.authenticated(userModel));
        _saveUserToPrefs(userModel);
        print(">>>>>>>>> User data loaded: ${userModel.email}");
        print(">>>>>>>>> User data loaded: ${userModel.phone}");
      } else {
        emit(AuthState.error("User data not found"));
        print(">>>>>>>>> User data not found.");
      }
    } catch (e) {
      emit(AuthState.error(e.toString()));
      print(">>>>>>>>> Failed to load user data: $e");
    }
  }

  Future<void> updateUserInfo({
    String? username,
    String? phone,
    String? password,
  }) async {
    try {
      await _authRepository.updateUserProfile(
        username: username,
        phone: phone,
        password: password,
      );
      UserModel? userModel = await _authRepository.getCurrentUser();
      if (userModel != null) {
        emit(AuthState.authenticated(userModel));
        _saveUserToPrefs(userModel);
        print(">>>>>>>>> User data loaded: ${userModel.email}");
        print(">>>>>>>>> User data loaded: ${userModel.phone}");
      } else {
        emit(AuthState.error("User data not found"));
        print(">>>>>>>>> User data not found.");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUserAddress({
    String? address,
  }) async {
    try {
      await _authRepository.updateUserAddress(address: address);
    } catch (e) {
      print(e);
    }
  }
}

// Auth State
class AuthState {
  final UserModel? userModel;
  final String? error;
  final bool isLoading;

  AuthState({
    this.userModel,
    this.error,
    this.isLoading = false,
  });

  // Initial state
  factory AuthState.initial() {
    return AuthState(userModel: null, error: null, isLoading: false);
  }

  // Loading state
  factory AuthState.loading() {
    return AuthState(userModel: null, error: null, isLoading: true);
  }

  factory AuthState.loadingStop() {
    return AuthState(userModel: null, error: null, isLoading: true);
  }

  // Authenticated state
  factory AuthState.authenticated(UserModel userModel) {
    return AuthState(userModel: userModel, error: null, isLoading: false);
  }

  // Error state
  factory AuthState.error(String error) {
    return AuthState(userModel: null, error: error, isLoading: false);
  }

  @override
  String toString() {
    if (isLoading) {
      return "AuthLoading";
    } else if (userModel != null) {
      return "AuthAuthenticated: ${userModel!.email}";
    } else if (error != null) {
      return "AuthError: $error";
    } else {
      return "AuthInitial";
    }
  }
}
