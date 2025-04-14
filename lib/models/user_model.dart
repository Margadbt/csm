import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String email;
  final String phone;
  final String address;
  final String username;
  final String profileImg;

  UserModel({
    required this.userId,
    required this.email,
    required this.phone,
    required this.address,
    required this.username,
    required this.profileImg,
  });

  // Factory constructor to create a UserModel from Firebase user and Firestore data
  factory UserModel.fromFirebase(User user, Map<String, dynamic> firestoreData) {
    return UserModel(
      userId: user.uid,
      email: user.email ?? '',
      phone: firestoreData['phone'] ?? '',
      address: firestoreData['address'] ?? '',
      username: firestoreData['username'] ?? '',
      profileImg: firestoreData['profile_img'] ?? '',
    );
  }

  // Method to convert the object to a map to store in Firestore
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'email': email,
      'phone': phone,
      'address': address,
      'username': username,
      'profile_img': profileImg,
    };
  }
}
