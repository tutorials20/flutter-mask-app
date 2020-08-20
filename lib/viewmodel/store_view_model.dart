import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stard1_mask_api/model/store.dart';
import 'package:stard1_mask_api/repository/location_repository.dart';
import 'package:stard1_mask_api/repository/store_repository.dart';

class StoreViewModel with ChangeNotifier {
  List<Store> stores = [];
  Position position;
  final _repository = StoreRepository();
  final _locationRepository = LocationRepository();

  StoreViewModel() {
    fetch();
  }

  Future fetch() async {
    this.stores = [];
    notifyListeners();
    this.position = await _locationRepository.getCurrentLocation();
    this.stores = await _repository.fetch(position);
    notifyListeners();
  }

  List<Store> filteredStores() => stores.where(_filterExists).toList();

  bool _filterExists(store) {
    switch (store.remainStat) {
      case 'plenty':
      case 'some':
      case 'few':
        return true;
    }
    return false;
  }

  isLoading() => stores.length == 0;
}
