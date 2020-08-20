import 'package:flutter/foundation.dart';
import 'package:stard1_mask_api/model/store.dart';
import 'package:stard1_mask_api/repository/store_repository.dart';

class StoreViewModel with ChangeNotifier {
  List<Store> stores = [];
  final _repository = StoreRepository();

  Future fetch() async {
    stores = await _repository.fetch();
    notifyListeners();
  }
}
