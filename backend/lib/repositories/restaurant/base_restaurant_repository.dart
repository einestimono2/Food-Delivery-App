import 'package:http/http.dart';

import '../../models/models.dart';

abstract class BaseRestaurantRepository {
  Future<Response> getRestaurants();
  Future<Response> getRestaurant(String id);
  Future<Response> createRestaurant(Restaurant restaurant);
  Future<Response> updateRestaurant(Restaurant restaurant);
  Future<Response> deleteRestaurant(Restaurant restaurant);

  Future<Response> updatePopularRestaurant(String restaurantID);

  Future<Response> addCategory(String restaurantID, String categoryID);
  Future<Response> deleteCategory(String restaurantID, String categoryID);

  Future<Response> addProduct(Product product);
  Future<Response> deleteProduct(Product product);

  Future<Response> updateFeaturedProduct(String productID);

  Future<Response> updateOpeningHours(
      String restaurantID, List<OpeningHours> openingHours,);
}
