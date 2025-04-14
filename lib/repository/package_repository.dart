import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csm/models/package_model.dart';
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
}
