import 'package:cloud_firestore/cloud_firestore.dart';

class StatusModel {
  final DateTime date;
  final int status;
  final String image;
  final String packageId;

  StatusModel({
    required this.date,
    required this.status,
    required this.image,
    required this.packageId,
  });

  factory StatusModel.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;

    return StatusModel(
      date: (data['date'] as Timestamp).toDate(),
      status: data['status'] ?? 0,
      image: data['image'] ?? '',
      packageId: data['package_id'] ?? '',
    );
  }
}
