import 'dart:convert';

import 'package:stard1_mask_api/model/store.dart';
import 'package:http/http.dart' as http;

class StoreRepository {
  Future<List<Store>> fetch() async {
    final url =
        "https://gist.githubusercontent.com/junsuk5/bb7485d5f70974deee920b8f0cd1e2f0/raw/063f64d9b343120c2cb01a6555cf9b38761b1d94/sample.json";
    final response = await http.get(url);

    print('Response status: ${response.statusCode}');
    print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

    var jsonStores = jsonDecode(utf8.decode(response.bodyBytes))["stores"];
    var dynamics = jsonStores.map((json) => Store.fromJson(json));

    return dynamics.toList().cast<Store>();
  }
}
