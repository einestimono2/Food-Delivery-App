import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';

abstract class BaseLocationRepository {
  Future<Position?> getCurrentLocation();
  Future<Response> getAutocomplete(String searchInput);
}