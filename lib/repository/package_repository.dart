import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csm/models/package_model.dart';
import 'package:csm/models/status_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PackageRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  PackageRepository(this._firestore, this._firebaseAuth);

  Future<PackageModel> createPackage({
    required String trackCode,
    String? description,
    required int amount,
    required bool isPaid,
    required int status,
    required String phone,
  }) async {
    final userId = _firebaseAuth.currentUser?.uid;
    if (userId == null) {
      throw Exception("User not logged in");
    }

    // Prepare package data
    final packageData = {
      'track_code': trackCode,
      'description': description ?? '',
      'added_date': DateTime.now(),
      'user_id': userId,
      'amount': amount,
      'is_paid': isPaid,
      'status': status,
      'phone': phone,
    };

    final packageRef = await _firestore.collection('packages').add(packageData);

    return PackageModel(
      id: packageRef.id,
      description: description ?? '',
      trackCode: trackCode,
      addedDate: DateTime.now(),
      userId: userId,
      amount: amount,
      isPaid: isPaid,
      status: status,
      phone: phone,
    );
  }

  // Optionally: Add method to fetch packages if needed
  Future<List<PackageModel>> getPackagesForUser(String userId) async {
    try {
      // Fetch the packages from Firestore for the specific user
      final querySnapshot = await _firestore.collection('packages').where('user_id', isEqualTo: userId).get();

      // Map the documents into PackageModel and return them
      return querySnapshot.docs.map((doc) {
        return PackageModel.fromFirestore(doc);
      }).toList();
    } catch (e) {
      throw Exception("Error fetching packages: $e");
    }
  }

  Future<PackageModel> getPackageById(String packageId) async {
    try {
      final doc = await _firestore.collection('packages').doc(packageId).get();

      if (!doc.exists) {
        throw Exception("Package not found");
      }

      return PackageModel.fromFirestore(doc);
    } catch (e) {
      throw Exception("Failed to get package: $e");
    }
  }

  Future<List<PackageModel>> getPackagesByPhoneNumber(String phoneNumber) async {
    try {
      // Now, fetch all packages for that user ID
      final querySnapshot = await _firestore.collection('packages').where('phone', isEqualTo: phoneNumber).get();

      // Map the documents into PackageModel and return them
      return querySnapshot.docs.map((doc) {
        return PackageModel.fromFirestore(doc);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching packages by phone number: $e');
    }
  }

  Future<List<PackageModel>> fetchAll() async {
    try {
      // Now, fetch all packages for that user ID
      final querySnapshot = await _firestore.collection('packages').get();

      // Map the documents into PackageModel and return them
      return querySnapshot.docs.map((doc) {
        return PackageModel.fromFirestore(doc);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching packages by phone number: $e');
    }
  }

  Future<List<StatusModel>> getStatusesByPackageId(String packageId) async {
    try {
      // final querySnapshot = await _firestore.collection("statuses").where("package_id", isEqualTo: packageId).orderBy("status").get();

      // return querySnapshot.docs.map((doc) => StatusModel.fromFirestore(doc)).toList();
      final querySnapshot = await _firestore.collection("statuses").where("package_id", isEqualTo: packageId).orderBy("status").get();
      final statuses = querySnapshot.docs.map((doc) => StatusModel.fromFirestore(doc)).toList();

      // print("Fetched statuses:");

      return statuses;
    } catch (e) {
      print(">>> $e");
      throw Exception("Error fetching statuses: $e");
    }
  }

  Future<void> addPackageStatus({
    required String packageId,
    required int status,
    required String imgUrl,
  }) async {
    try {
      final statusData = {
        'package_id': packageId,
        'status': status,
        'img_url': imgUrl,
        'date': DateTime.now(),
      };

      await _firestore.collection("statuses").add(statusData);
    } catch (e) {
      throw Exception("Error adding package status: $e");
    }
  }

  Future<void> updatePackageStatus({
    required String packageId,
    required int status,
  }) async {
    try {
      await _firestore.collection('packages').doc(packageId).update({
        'status': status,
      });
    } catch (e) {
      throw Exception("Failed to update package status: $e");
    }
  }
}
