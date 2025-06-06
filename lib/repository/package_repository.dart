import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csm/models/package_model.dart';
import 'package:csm/models/status_model.dart';
import 'package:csm/models/transactions_model.dart';
import 'package:csm/models/user_model.dart';
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
    String? img,
  }) async {
    // Search for user by phone number
    // final userSnapshot = await _firestore.collection('users').where('phone', isEqualTo: phone).limit(1).get();

    // if (userSnapshot.docs.isEmpty) {
    //   throw Exception("User not found with the given phone number");
    // }

    // Assuming there is only one user with that phone number
    // final userId = userSnapshot.docs.first.id;

    // Prepare package data
    final packageData = {
      'track_code': trackCode,
      'description': description ?? '',
      'added_date': DateTime.now(),
      'amount': amount,
      'is_paid': isPaid,
      'status': status,
      'phone': phone,
      'img': img ?? '',
    };

    // Create the package in Firestore
    final packageRef = await _firestore.collection('packages').add(packageData);

    return PackageModel(
      id: packageRef.id,
      description: description ?? '',
      trackCode: trackCode,
      addedDate: DateTime.now(),
      amount: amount,
      isPaid: isPaid,
      status: status,
      phone: phone,
      img: img ?? '',
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
      final querySnapshot = await _firestore.collection('packages').orderBy('added_date', descending: true).where('phone', isEqualTo: phoneNumber).get();

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
      final querySnapshot = await _firestore.collection('packages').orderBy('added_date', descending: true).get();

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

      await _firestore.collection("packages").doc(packageId).update({
        'img': imgUrl,
      });

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
      await FirebaseFirestore.instance.collection('packages').doc(packageId).update({
        'status': status,
      });
    } catch (e) {
      throw Exception("Failed to update package status: $e");
    }
  }

  Future<void> deleteStatus(String statusId) async {
    await FirebaseFirestore.instance.collection('statuses').doc(statusId).delete();
  }

  Future<void> updatePackageById({
    required String packageId,
    String? phone,
    int? amount,
    String? trackCode,
  }) async {
    final packageRef = FirebaseFirestore.instance.collection('packages').doc(packageId);

    Map<String, dynamic> updatedData = {};

    if (phone != null) updatedData['phone'] = phone;
    if (amount != null) updatedData['amount'] = amount;
    if (trackCode != null) updatedData['track_code'] = trackCode;

    print(">>>>>>>>> $updatedData");

    await packageRef.update(updatedData);
  }

  Future<void> payPackage({
    required String packageId,
    required String packageTrackCode,
    required int amount,
  }) async {
    final packageRef = FirebaseFirestore.instance.collection('packages').doc(packageId);

    Map<String, dynamic> updatedData = {};

    updatedData['is_paid'] = true;

    await packageRef.update(updatedData);

    final userId = await UserPrefs.getUserId();

    // Save to transactions collection
    await FirebaseFirestore.instance.collection('transactions').add({
      'package_id': packageId,
      'user_id': userId,
      'amount': amount,
      'package_track_code': packageTrackCode,
      'date': DateTime.now(),
    });
  }

  Future<List<TransactionsModel>> fetchTransaction() async {
    try {
      final userId = await UserPrefs.getUserId();

      final querySnapshot = await _firestore.collection('transactions').where('user_id', isEqualTo: userId).orderBy('date', descending: true).get();

      return querySnapshot.docs.map((doc) => TransactionsModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception("Error fetching transactions: $e");
    }
  }
}
