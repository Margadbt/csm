import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csm/models/delivery_model.dart';

class DeliveryRepository {
  final CollectionReference _deliveriesCollection = FirebaseFirestore.instance.collection('deliveries');

  Stream<List<DeliveryModel>> getDeliveries() {
    return _deliveriesCollection.snapshots().map((snapshot) => snapshot.docs.map((doc) => DeliveryModel.fromFirestore(doc)).toList());
  }
}
