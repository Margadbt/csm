import 'package:bloc/bloc.dart';
import 'package:csm/models/delivery_model.dart';
import 'package:csm/repository/delivery_repository.dart';

class HomeCubit extends Cubit<HomeState> {
  final DeliveryRepository _repository = DeliveryRepository();

  HomeCubit() : super(HomeState.initial(homeScreenIndex: 0)) {
    getDeliveries();
  }

  Future<void> getDeliveries() async {
    emit(HomeState.loading(homeScreenIndex: state.homeScreenIndex));
    try {
      _repository.getDeliveries().listen(
            (deliveries) => emit(HomeState.deliveriesLoaded(deliveries, homeScreenIndex: state.homeScreenIndex)),
            onError: (error) => emit(HomeState.error(error.toString(), homeScreenIndex: state.homeScreenIndex)),
          );
    } catch (e) {
      emit(HomeState.error(e.toString(), homeScreenIndex: state.homeScreenIndex));
    }
  }

  void changeHomeScreenIndex(int index) {
    emit(HomeState(homeScreenIndex: index, deliveries: state.deliveries, errorMessage: state.errorMessage, isLoading: state.isLoading));
  }
}

class HomeState {
  final int? homeScreenIndex;
  final List<DeliveryModel>? deliveries;
  final String? errorMessage;
  final bool isLoading;

  HomeState({
    this.homeScreenIndex,
    this.deliveries,
    this.errorMessage,
    this.isLoading = false,
  });

  factory HomeState.initial({int? homeScreenIndex}) {
    return HomeState(homeScreenIndex: homeScreenIndex);
  }

  factory HomeState.loading({int? homeScreenIndex}) {
    return HomeState(homeScreenIndex: homeScreenIndex, isLoading: true);
  }

  factory HomeState.deliveriesLoaded(List<DeliveryModel> deliveries, {int? homeScreenIndex}) {
    return HomeState(homeScreenIndex: homeScreenIndex, deliveries: deliveries);
  }

  factory HomeState.error(String errorMessage, {int? homeScreenIndex}) {
    return HomeState(homeScreenIndex: homeScreenIndex, errorMessage: errorMessage);
  }
}
