import 'package:csm/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> registerUser(String email, String password, String phone) async {
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;
    if (user != null) {
      String? fcmToken = await FirebaseMessaging.instance.getToken();

      await _firestore.collection('users').doc(user.uid).set({
        'user_id': user.uid,
        'email': user.email,
        'phone': phone,
        'fcm_token': fcmToken,
        'address': '',
        'username': '',
        'profile_img': '',
      });

      DocumentSnapshot snapshot = await _firestore.collection('users').doc(user.uid).get();
      return UserModel.fromFirebase(user, snapshot.data() as Map<String, dynamic>);
    } else {
      throw Exception("Failed to register user.");
    }
  }

  Future<UserModel> loginUser(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;
    if (user != null) {
      String? fcmToken = await FirebaseMessaging.instance.getToken();

      // Update FCM token
      await _firestore.collection('users').doc(user.uid).update({
        'fcm_token': fcmToken,
      });

      DocumentSnapshot snapshot = await _firestore.collection('users').doc(user.uid).get();
      return UserModel.fromFirebase(user, snapshot.data() as Map<String, dynamic>);
    } else {
      throw Exception("Failed to login.");
    }
  }

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
}
