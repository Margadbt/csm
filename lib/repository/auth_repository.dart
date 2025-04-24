import 'package:csm/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csm/utils/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> registerUser(String email, String password, String phone) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'user_id': user.uid,
          'email': user.email,
          'phone': phone,
          'address': '',
          'username': '',
          'profile_img': '',
          'role': '',
          'fcm_token': '', // optional: default blank or null
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

  Future<UserModel> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
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

  Future<UserModel?> getCurrentUser() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(user.uid).get();
      return UserModel.fromFirebase(user, snapshot.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateUserProfile({
    String? username,
    String? phone,
    String? password,
  }) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final uid = user.uid;

    // Update Firestore (for username and phone)
    if (username != null || phone != null) {
      final userDoc = _firestore.collection('users').doc(uid);
      final Map<String, dynamic> updates = {};
      if (username != null) updates['username'] = username;
      if (phone != null) updates['phone'] = phone;
      await userDoc.update(updates);
    }

    // Update Firebase Auth password
    if (password != null && password.isNotEmpty) {
      await user.updatePassword(password);
    }
  }

  Future<void> updateUserAddress({
    String? address,
  }) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final uid = user.uid;

    // Update Firestore (for username and phone)
    if (address != null) {
      final userDoc = _firestore.collection('users').doc(uid);
      final Map<String, dynamic> updates = {};
      if (address != null) updates['address'] = address;
      await userDoc.update(updates);
    }

    // Update Firebase Auth password
  }
}
