import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
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
    on<CreateRestaurant>(_onCreateRestaurant);
    on<UpdateRestaurant>(_onUpdateRestaurant);
    on<DeleteRestaurant>(_onDeleteRestaurant);
    on<UpdatePopular>(_onUpdatePopular);
  }

  FutureOr<void> _onLoadRestaurants(
    LoadRestaurants event,
    Emitter<RestaurantState> emit,
  ) async {
    try {
      // Loading
      emit(RestaurantLoading());
      //
      Response res = await _restaurantRepository.getRestaurants();
      final json = jsonDecode(res.body);

      if (res.statusCode == 200) {
        List<Restaurant> restaurants = [];

        for (int i = 0; i < json['restaurants'].length; i++) {
          restaurants
              .add(Restaurant.fromJson(jsonEncode(json['restaurants'][i])));
        }

        emit(
          RestaurantLoaded(
            restaurants: restaurants,
          ),
        );
      } else {
        emit(RestaurantError(json['message']));
      }
    } catch (e) {
      emit(RestaurantError(e.toString()));
    }
  }

  FutureOr<void> _onCreateRestaurant(
    CreateRestaurant event,
    Emitter<RestaurantState> emit,
  ) async {
    try {
      final state = this.state;

      if (state is RestaurantLoaded) {
        // Loading
        emit(RestaurantLoading());

        Response res =
            await _restaurantRepository.createRestaurant(event.restaurant);
        final json = jsonDecode(res.body);

        if (res.statusCode == 200) {
          Restaurant restaurant = Restaurant.fromJson(
            jsonEncode(json['restaurant']),
          );

          emit(
            RestaurantLoaded(
              restaurants: List.from(state.restaurants)..add(restaurant),
            ),
          );
        } else {
          emit(RestaurantError(json['message']));
        }
      }
    } catch (e) {
      emit(RestaurantError(e.toString()));
    }
  }

  FutureOr<void> _onUpdateRestaurant(
    UpdateRestaurant event,
    Emitter<RestaurantState> emit,
  ) async {
    final state = this.state;

    try {
      if (state is RestaurantLoaded) {
        // Loading
        emit(RestaurantLoading());

        Response res =
            await _restaurantRepository.updateRestaurant(event.restaurant);
        final json = jsonDecode(res.body);

        if (res.statusCode == 200) {
          int index = state.restaurants.indexWhere(
            (element) => element.id == event.restaurant.id,
          );

          state.restaurants[index] = Restaurant.fromJson(
            jsonEncode(json['restaurant']),
          );

          emit(
            RestaurantLoaded(
              restaurants: state.restaurants,
            ),
          );
        } else {
          emit(RestaurantError(json['message']));
        }
      }
    } catch (e) {
      emit(RestaurantError(e.toString()));
    }
  }

  FutureOr<void> _onDeleteRestaurant(
    DeleteRestaurant event,
    Emitter<RestaurantState> emit,
  ) async {
    try {
      final state = this.state;

      if (state is RestaurantLoaded) {
        // Loading
        emit(RestaurantLoading());

        Response res =
            await _restaurantRepository.deleteRestaurant(event.restaurant);

        if (res.statusCode == 200) {
          emit(
            RestaurantLoaded(
              restaurants: List.from(state.restaurants)
                ..remove(event.restaurant),
            ),
          );
        } else {
          emit(RestaurantError(jsonDecode(res.body)['message']));
        }
      }
    } catch (e) {
      emit(RestaurantError(e.toString()));
    }
  }

  FutureOr<void> _onUpdatePopular(
    UpdatePopular event,
    Emitter<RestaurantState> emit,
  ) async {
    final state = this.state;

    try {
      if (state is RestaurantLoaded) {
        // Loading
        emit(RestaurantLoading());

        Response res = await _restaurantRepository.updatePopularRestaurant(
          event.restaurantID,
        );
        final json = jsonDecode(res.body);

        if (res.statusCode == 200) {
          int index = state.restaurants.indexWhere(
            (element) => element.id == event.restaurantID,
          );

          state.restaurants[index] = Restaurant.fromJson(
            jsonEncode(json['restaurant']),
          );

          emit(
            RestaurantLoaded(
              restaurants: state.restaurants,
            ),
          );
        } else {
          emit(RestaurantError(json['message']));
        }
      }
    } catch (e) {
      emit(RestaurantError(e.toString()));
    }
  }
}
