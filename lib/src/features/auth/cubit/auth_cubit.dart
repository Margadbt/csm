import 'package:auto_route/auto_route.dart';
import 'package:csm/models/user_model.dart';
import 'package:csm/repository/auth_repository.dart';
import 'package:csm/src/routes/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Auth Cubit
class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _firebaseAuth;
  final AuthRepository _authRepository; // Declare the repository

  Future<void> saveFcmToken(String userId) async {
    try {
      // Get the FCM token for the current device
      String? token = await FirebaseMessaging.instance.getToken();

      if (token != null) {
        // Save the token to Firestore under the user's document
        await FirebaseFirestore.instance.collection('users').doc(userId).update({
          'fcmToken': token,
        });
        print("FCM Token saved for user: $userId");
      } else {
        print("FCM Token is null for user: $userId");
      }
    } catch (e) {
      print('Error saving FCM token: $e');
    }
  }

  Future<void> setupFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request notification permissions
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("✅ Notifications authorized");

      // Wait for APNs token to be available (for iOS)
      String? apnsToken;
      int retry = 0;
      while (retry < 5) {
        apnsToken = await messaging.getAPNSToken();
        if (apnsToken != null) break;
        await Future.delayed(const Duration(seconds: 1));
        retry++;
      }

      if (apnsToken == null) {
        print("❌ APNs token still not available after retrying.");
        return;
      }

      print("✅ APNs Token: $apnsToken");

      // Now fetch the FCM token
      String? fcmToken = await messaging.getToken();
      print("✅ FCM Token: $fcmToken");
    } else {
      print("❌ Notifications permission not granted");
    }
  }

  AuthCubit(this._firebaseAuth, this._authRepository) : super(AuthState.initial()) {
    _firebaseAuth.authStateChanges().listen((User? user) async {
      if (await UserPrefs.getUserId() != "" && user != null) {
        await _loadUserData(user.uid);
      }
    });
  }

  Future<void> _saveUserToPrefs(UserModel userModel) async {
    final prefs = await SharedPreferences.getInstance();
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
      await saveFcmToken(userModel.userId!);
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
      await setupFCM();
      await saveFcmToken(userModel.userId!);

      await saveFcmToken(userModel.userId!);
      emit(AuthState.authenticated(userModel));
    } catch (e) {
      emit(AuthState.error(e.toString()));
      print(">>>>>>>>> Login failed: $e");
    }
  }

  Future<void> logout() async {
    print(">>>>>>>>> Logging out...");
    await _firebaseAuth.signOut();
    await _clearUserFromPrefs();
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
