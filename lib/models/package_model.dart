import 'package:cloud_firestore/cloud_firestore.dart';

class PackageModel {
  final String id;
  final String description;
  final String trackCode;
  final DateTime addedDate;
  final int amount;
  final bool isPaid;
  final int status;
  final String phone;
  final String img;

  PackageModel({
    required this.id,
    required this.description,
    required this.trackCode,
    required this.addedDate,
    required this.amount,
    required this.isPaid,
    required this.status,
    required this.phone,
    required this.img,
  });

  factory PackageModel.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return PackageModel(
      id: doc.id,
      description: data['description'] ?? '',
      trackCode: data['track_code'] ?? '',
      addedDate: (data['added_date'] as Timestamp).toDate(),
      amount: data['amount'] ?? 0,
      isPaid: data['is_paid'] ?? false,
      status: data['status'] ?? 0,
      phone: data['phone'] ?? 0,
      img: data['img'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'track_code': trackCode,
      'added_date': addedDate,
      'amount': amount,
      'is_paid': isPaid,
      'status': status,
      'img': img,
    };
  }

  static PackageModel empty() {
    return PackageModel(
      id: '',
      description: '',
      trackCode: '',
      addedDate: DateTime.now(),
      amount: 0,
      isPaid: false,
      status: 0,
      phone: '',
      img: '',
    );
  }
}
