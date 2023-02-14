import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';

part 'restaurant_event.dart';
part 'restaurant_state.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final RestaurantRepository _restaurantRepository;

  RestaurantBloc({required RestaurantRepository restaurantRepository})
      : _restaurantRepository = restaurantRepository,
        super(RestaurantInitial()) {
    on<LoadRestaurants>(_onLoadRestaurants);
  }

  FutureOr<void> _onLoadRestaurants(
    LoadRestaurants event,
    Emitter<RestaurantState> emit,
  ) async {
    try {
      emit(RestaurantLoading());

      Response res = await _restaurantRepository.getRestaurants();
      final json = jsonDecode(res.body);

      if (res.statusCode == 200) {
        List<Restaurant> restaurants = <Restaurant>[];

        for (int i = 0; i < json['restaurants'].length; i++) {
          restaurants
              .add(Restaurant.fromJson(jsonEncode(json['restaurants'][i])));
        }

        emit(RestaurantLoaded(
          restaurants: restaurants,
        ));
      } else {
        emit(RestaurantError(message: json['message']));
      }
    } catch (e) {
      emit(RestaurantError(message: e.toString()));
    }
  }
}
