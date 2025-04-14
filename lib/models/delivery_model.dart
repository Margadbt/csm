import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryModel {
  final String id;
  final String description;
  final String trackCode;
  final DateTime addedDate;
  final String userId;
  final int amount;
  final bool isPaid;
  final int status;

  DeliveryModel({
    required this.id,
    required this.description,
    required this.trackCode,
    required this.addedDate,
    required this.userId,
    required this.amount,
    required this.isPaid,
    required this.status,
  });

  factory DeliveryModel.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return DeliveryModel(
      id: doc.id,
      description: data['description'] ?? '',
      trackCode: data['track_code'] ?? '',
      addedDate: (data['added_date'] as Timestamp).toDate(),
      userId: data['user_id'] ?? '',
      amount: data['amount'] ?? 0,
      isPaid: data['is_paid'] ?? false,
      status: data['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'track_code': trackCode,
      'added_date': addedDate,
      'user_id': userId,
      'amount': amount,
      'is_paid': isPaid,
      'status': status,
    };
  }
}
