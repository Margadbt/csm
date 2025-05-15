import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionsModel {
  final DateTime date;
  final int amount;
  final String userId;
  final String packageId;
  final String packageTrackCode;

  TransactionsModel({
    required this.date,
    required this.amount,
    required this.userId,
    required this.packageTrackCode,
    required this.packageId,
  });

  factory TransactionsModel.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;

    return TransactionsModel(
      date: (data['date'] as Timestamp).toDate(),
      amount: data['amount'] ?? 0,
      userId: data['user_id'] ?? '',
      packageId: data['package_id'] ?? '',
      packageTrackCode: data['package_track_code'] ?? '',
    );
  }
}
