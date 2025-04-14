import 'package:bloc/bloc.dart';
import 'package:csm/models/user_model.dart';
import 'package:csm/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Auth Cubit
class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthRepository _authRepository; // Declare the repository

  AuthCubit(this._firebaseAuth, this._authRepository) : super(AuthState.initial()) {
    _firebaseAuth.authStateChanges().listen((User? user) async {
      if (user != null) {
        await _loadUserData(user.uid);
      } else {
        emit(AuthState.initial());
      }
    });
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
      emit(AuthState.authenticated(userModel));
      print(">>>>>>>>> User logged in: ${userModel.email}");
    } catch (e) {
      emit(AuthState.error(e.toString()));
      print(">>>>>>>>> Login failed: $e");
    }
  }

  Future<void> logout() async {
    print(">>>>>>>>> Logging out...");
    await _firebaseAuth.signOut();
    emit(AuthState.initial());
    print(">>>>>>>>> User logged out.");
  }

  Future<void> _loadUserData(String uid) async {
    print(">>>>>>>>> Loading user data...");
    try {
      UserModel? userModel = await _authRepository.getCurrentUser();
      if (userModel != null) {
        emit(AuthState.authenticated(userModel));
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
