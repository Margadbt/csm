import 'package:csm/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register user and save additional data in Firestore
  Future<UserModel> registerUser(String email, String password, String phone) async {
    try {
      // Create user with Firebase Authentication
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Save additional data to Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'user_id': user.uid,
          'email': user.email,
          'phone': phone,
          'address': '',
          'username': '',
          'profile_img': '',
        });

        // Fetch and return the complete user model
        DocumentSnapshot snapshot = await _firestore.collection('users').doc(user.uid).get();
        return UserModel.fromFirebase(user, snapshot.data() as Map<String, dynamic>);
      } else {
        throw Exception("Failed to register user.");
      }
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }

  // Login user and fetch additional data from Firestore
  Future<UserModel> loginUser(String email, String password) async {
    try {
      // Sign in user with Firebase Authentication
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Fetch additional data from Firestore
        DocumentSnapshot snapshot = await _firestore.collection('users').doc(user.uid).get();
        return UserModel.fromFirebase(user, snapshot.data() as Map<String, dynamic>);
      } else {
        throw Exception("Failed to login.");
      }
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  // Logout user
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  // Check if user is already logged in
  Future<UserModel?> getCurrentUser() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      // Fetch user data from Firestore
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(user.uid).get();
      return UserModel.fromFirebase(user, snapshot.data() as Map<String, dynamic>);
    }
    return null;
  }
}
