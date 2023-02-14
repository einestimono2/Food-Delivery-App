import 'dart:convert';

import 'package:http/http.dart';

import '../../constants/constants.dart';
import '../../models/models.dart';
import '../repositories.dart';

class RestaurantRepository extends BaseRestaurantRepository {
  @override
  Future<Response> createRestaurant(Restaurant restaurant) async {
    Response res = await post(
      Uri.parse('$url/restaurant'),
      body: restaurant.toJson(),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }

  @override
  Future<Response> deleteRestaurant(Restaurant restaurant) async {
    Response res = await delete(
      Uri.parse('$url/restaurant/${restaurant.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }

  @override
  Future<Response> getRestaurants() async {
    Response res = await get(
      Uri.parse('$url/restaurants'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }

  @override
  Future<Response> updateRestaurant(Restaurant restaurant) async {
    Response res = await patch(
      Uri.parse('$url/restaurant/${restaurant.id}'),
      body: restaurant.toJson(),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }

  @override
  Future<Response> getRestaurant(String id) async {
    Response res = await get(
      Uri.parse('$url/restaurant/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }

  @override
  Future<Response> addCategory(String restaurantID, String categoryID) async {
    Response res = await post(
      Uri.parse('$url/restaurant/category'),
      body: jsonEncode({
        'restaurantID': restaurantID,
        'categoryID': categoryID,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }

  @override
  Future<Response> deleteCategory(
    String restaurantID,
    String categoryID,
  ) async {
    Response res = await delete(
      Uri.parse('$url/restaurant/category'),
      body: jsonEncode({
        'restaurantID': restaurantID,
        'categoryID': categoryID,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }

  @override
  Future<Response> addProduct(Product product) async {
    Response res = await post(
      Uri.parse('$url/product'),
      body: product.toJson(),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }

  @override
  Future<Response> deleteProduct(Product product) async {
    Response res = await delete(
      Uri.parse('$url/product/${product.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }

  @override
  Future<Response> updateOpeningHours(
    String restaurantID,
    List<OpeningHours> openingHours,
  ) async {
    Response res = await patch(
      Uri.parse('$url/restaurant/hours'),
      body: jsonEncode({
        'restaurantID': restaurantID,
        'openingHours': openingHours.map((e) => e.toMap()).toList(),
      }),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }
  
  @override
  Future<Response> updatePopularRestaurant(String restaurantID) async {
    Response res = await patch(
      Uri.parse('$url/restaurant/popular'),
      body: jsonEncode({
        'restaurantID': restaurantID,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }
  
  @override
  Future<Response> updateFeaturedProduct(String productID) async {
    Response res = await patch(
      Uri.parse('$url/product/featured'),
      body: jsonEncode({
        'productID': productID,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }
}
