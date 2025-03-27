import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthCubit() : super(AuthState.initial());

  Future<void> registerUser(String email, String password) async {
    print(">>>>>>>>> Registering user...");
    emit(AuthState.loading());
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(AuthState.authenticated(userCredential.user!));
      print(">>>>>>>>> User registered successfully: ${userCredential.user!.email}");
    } catch (e) {
      emit(AuthState.error(e.toString()));
      print(">>>>>>>>> Registration failed: $e");
    }
  }

  Future<void> loginUser(String email, String password) async {
    print(">>>>>>>>> Logging in...");
    emit(AuthState.loading());
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(AuthState.authenticated(userCredential.user!));
      print(">>>>>>>>> User logged in successfully: ${userCredential.user!.email}");
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
}

class AuthState {
  final User? user;
  final String? error;
  final bool isLoading;

  AuthState({this.user, this.error, this.isLoading = false});

  // Factory constructors for different states

  // Initial state
  factory AuthState.initial() {
    return AuthState(user: null, error: null, isLoading: false);
  }

  // Loading state
  factory AuthState.loading() {
    return AuthState(user: null, error: null, isLoading: true);
  }

  // Authenticated state
  factory AuthState.authenticated(User user) {
    return AuthState(user: user, error: null, isLoading: false);
  }

  // Error state
  factory AuthState.error(String error) {
    return AuthState(user: null, error: error, isLoading: false);
  }

  @override
  String toString() {
    if (isLoading) {
      return "AuthLoading";
    } else if (user != null) {
      return "AuthAuthenticated: ${user!.email}";
    } else if (error != null) {
      return "AuthError: $error";
    } else {
      return "AuthInitial";
    }
  }
}
