import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  final String userId;
  final String email;
  final String phone;
  final String address;
  final String username;
  final String profileImg;
  final String role;
  final String? fcmToken;

  UserModel({
    required this.userId,
    required this.email,
    required this.phone,
    required this.address,
    required this.username,
    required this.profileImg,
    required this.role,
    this.fcmToken,
  });

  factory UserModel.fromFirebase(User user, Map<String, dynamic> firestoreData) {
    return UserModel(
      userId: user.uid,
      email: user.email ?? '',
      phone: firestoreData['phone'] ?? '',
      address: firestoreData['address'] ?? '',
      username: firestoreData['username'] ?? '',
      profileImg: firestoreData['profile_img'] ?? '',
      role: firestoreData['role'] ?? '',
      fcmToken: firestoreData['fcmToken'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'email': email,
      'phone': phone,
      'address': address,
      'username': username,
      'profile_img': profileImg,
      'role': role,
      'fcmToken': fcmToken,
    };
  }
}

class UserPrefs {
  static const String _keyUserId = 'userId';
  static const String _keyUserEmail = 'userEmail';
  static const String _keyUserPhone = 'userPhone';
  static const String _keyUserRole = 'userRole';

  // Set User Info
  static Future<void> setUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, userId);
  }

  static Future<void> setUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserEmail, email);
  }

  static Future<void> setUserPhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserPhone, phone);
  }

  static Future<void> setUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserRole, role);
  }

  // Get User Info
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail);
  }

  static Future<String?> getUserPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserPhone);
  }

  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserRole);
  }

  // Clear User Info
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyUserPhone);
  }

  // Optional: Check if the user is logged in by checking userId
  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyUserId);
  }
}
