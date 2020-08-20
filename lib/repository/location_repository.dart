import 'package:geolocator/geolocator.dart';

class LocationRepository {
  Future<Position> getCurrentLocation() async =>
      Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
}
