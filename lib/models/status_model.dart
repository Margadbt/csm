import 'package:cloud_firestore/cloud_firestore.dart';

class StatusModel {
  final DateTime date;
  final int status;
  final String image;
  final String deliveryId;

  StatusModel({
    required this.date,
    required this.status,
    required this.image,
    required this.deliveryId,
  });

  factory StatusModel.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;

    return StatusModel(
      date: (data['date'] as Timestamp).toDate(),
      status: data['status'] ?? 0,
      image: data['image'] ?? '',
      deliveryId: data['delivery_id'] ?? '',
    );
  }
}
