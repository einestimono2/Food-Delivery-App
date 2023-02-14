import 'package:http/http.dart';

abstract class BaseRestaurantRepository {
  Future<Response> getRestaurants();
}
