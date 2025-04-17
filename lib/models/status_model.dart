import 'package:cloud_firestore/cloud_firestore.dart';

class StatusModel {
  final DateTime date;
  final int status;
  final String imgUrl;
  final String packageId;

  StatusModel({
    required this.date,
    required this.status,
    required this.imgUrl,
    required this.packageId,
  });

  factory StatusModel.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;

    return StatusModel(
      date: (data['date'] as Timestamp).toDate(),
      status: data['status'] ?? 0,
      imgUrl: data['img_url'] ?? '',
      packageId: data['package_id'] ?? '',
    );
  }
}
