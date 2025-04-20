import 'package:csm/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Register user and store FCM token
  Future<UserModel> registerUser(String email, String password, String phone) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Get FCM token
        String? fcmToken = await _firebaseMessaging.getToken();

        // Store user data along with FCM token
        await _firestore.collection('users').doc(user.uid).set({
          'user_id': user.uid,
          'email': user.email,
          'phone': phone,
          'address': '',
          'username': '',
          'profile_img': '',
          'fcmToken': fcmToken, // Store FCM token here
        });

        DocumentSnapshot snapshot = await _firestore.collection('users').doc(user.uid).get();
        return UserModel.fromFirebase(user, snapshot.data() as Map<String, dynamic>);
      } else {
        throw Exception("Failed to register user.");
      }
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }

  // Login user and retrieve FCM token
  Future<UserModel> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Get FCM token
        String? fcmToken = await _firebaseMessaging.getToken();

        // Store or update FCM token in Firestore
        await _firestore.collection('users').doc(user.uid).update({
          'fcmToken': fcmToken, // Update the FCM token
        });

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

  // Get current user and their data
  Future<UserModel?> getCurrentUser() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(user.uid).get();
      return UserModel.fromFirebase(user, snapshot.data() as Map<String, dynamic>);
    }
    return null;
  }
}
