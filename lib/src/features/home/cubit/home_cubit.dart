import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csm/models/delievery_model.dart';
import 'package:csm/models/status_model.dart';
import 'package:flutter/material.dart';

class HomeCubit extends Cubit<HomeState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  HomeCubit() : super(HomeState.initial(homeScreenIndex: 0));

  Future<void> getDeliveries() async {
    try {
      emit(HomeState.loading(homeScreenIndex: 0));

      QuerySnapshot deliveriesSnapshot = await _firestore.collection('deliveries').get();

      List<DeliveryModel> deliveries = deliveriesSnapshot.docs.map((doc) => DeliveryModel.fromFirestore(doc)).toList();

      for (var delivery in deliveries) {
        QuerySnapshot statusSnapshot = await _firestore.collection('statuses').where('delivery_id', isEqualTo: delivery.id).orderBy('date', descending: true).limit(1).get();

        if (statusSnapshot.docs.isNotEmpty) {
          StatusModel status = StatusModel.fromFirestore(statusSnapshot.docs.first);
          delivery.status = status.status;
        }
      }

      emit(HomeState.deliveriesLoaded(deliveries, homeScreenIndex: 0));
      print("Deliveries loaded: ${deliveries.length}");
    } catch (e) {
      emit(HomeState.error("Failed to load deliveries: $e", homeScreenIndex: 0));
    }
  }

  // Change the current screen index
  void changeHomeScreenIndex(int index) {
    emit(HomeState(homeScreenIndex: index)); // Emit HomeState with the new index
  }
}

// HomeState class with all states as a single class
class HomeState {
  final int? homeScreenIndex; // homeScreenIndex field
  final List<DeliveryModel>? deliveries; // Used in the deliveriesLoaded state
  final String? errorMessage; // Used in the error state
  final bool isLoading; // Indicates whether it's in loading state

  // Constructor to initialize the state
  HomeState({
    this.homeScreenIndex,
    this.deliveries,
    this.errorMessage,
    this.isLoading = false,
  });

  // Factory constructor for the initial state
  factory HomeState.initial({int? homeScreenIndex}) {
    return HomeState(homeScreenIndex: homeScreenIndex);
  }

  // Factory constructor for the loading state
  factory HomeState.loading({int? homeScreenIndex}) {
    return HomeState(homeScreenIndex: homeScreenIndex, isLoading: true);
  }

  // Factory constructor for when deliveries are loaded successfully
  factory HomeState.deliveriesLoaded(List<DeliveryModel> deliveries, {int? homeScreenIndex}) {
    return HomeState(homeScreenIndex: homeScreenIndex, deliveries: deliveries);
  }

  // Factory constructor for when an error occurs
  factory HomeState.error(String errorMessage, {int? homeScreenIndex}) {
    return HomeState(homeScreenIndex: homeScreenIndex, errorMessage: errorMessage);
  }
}
