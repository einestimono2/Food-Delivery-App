import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';

part 'restaurant_details_event.dart';
part 'restaurant_details_state.dart';

class RestaurantDetailsBloc
    extends Bloc<RestaurantDetailsEvent, RestaurantDetailsState> {
  final RestaurantRepository _restaurantRepository;

  RestaurantDetailsBloc({required RestaurantRepository restaurantRepository})
      : _restaurantRepository = restaurantRepository,
        super(RestaurantDetailsInitial()) {
    on<LoadRestaurant>(_onLoadRestaurant);
    on<AddRestaurantCategory>(_onAddRestaurantCategory);
    on<DeleteRestaurantCategory>(_onDeleteRestaurantCategory);
    on<AddRestaurantProduct>(_onAddRestaurantProduct);
    on<DeleteRestaurantProduct>(_onDeleteRestaurantProduct);
    on<UpdateFeaturedProduct>(_onUpdateFeaturedProduct);
    on<UpdateRestaurantOpeningHours>(_onUpdateRestaurantOpeningHours);
  }

  FutureOr<void> _onLoadRestaurant(
    LoadRestaurant event,
    Emitter<RestaurantDetailsState> emit,
  ) async {
    try {
      // Loading
      emit(RestaurantDetailsLoading());
      //
      Response res =
          await _restaurantRepository.getRestaurant(event.restaurantID);
      final json = jsonDecode(res.body);

      if (res.statusCode == 200) {
        Restaurant restaurant = Restaurant.fromJson(
          jsonEncode(json['restaurant']),
        );
        emit(
          RestaurantDetailsLoaded(
            currentRestaurant: restaurant,
          ),
        );
      } else {
        emit(RestaurantDetailsError(json['message']));
      }
    } catch (e) {
      emit(RestaurantDetailsError(e.toString()));
    }
  }

  FutureOr<void> _onAddRestaurantCategory(
    AddRestaurantCategory event,
    Emitter<RestaurantDetailsState> emit,
  ) async {
    try {
      final state = this.state;

      if (state is RestaurantDetailsLoaded) {
        // Loading
        emit(RestaurantDetailsLoading());

        Response res = await _restaurantRepository.addCategory(
          state.currentRestaurant.id!,
          event.category.id!,
        );
        final json = jsonDecode(res.body);

        if (res.statusCode == 200) {
          Restaurant restaurant = Restaurant.fromJson(
            jsonEncode(json['restaurant']),
          );

          emit(
            RestaurantDetailsLoaded(currentRestaurant: restaurant),
          );
        } else {
          emit(RestaurantDetailsError(json['message']));
        }
      }
    } catch (e) {
      emit(RestaurantDetailsError(e.toString()));
    }
  }

  FutureOr<void> _onDeleteRestaurantCategory(
    DeleteRestaurantCategory event,
    Emitter<RestaurantDetailsState> emit,
  ) async {
    try {
      final state = this.state;

      if (state is RestaurantDetailsLoaded) {
        // Loading
        emit(RestaurantDetailsLoading());

        Response res = await _restaurantRepository.deleteCategory(
          state.currentRestaurant.id!,
          event.category.id!,
        );
        final json = jsonDecode(res.body);

        if (res.statusCode == 200) {
          Restaurant restaurant = Restaurant.fromJson(
            jsonEncode(json['restaurant']),
          );

          emit(
            RestaurantDetailsLoaded(currentRestaurant: restaurant),
          );
        } else {
          emit(RestaurantDetailsError(json['message']));
        }
      }
    } catch (e) {
      emit(RestaurantDetailsError(e.toString()));
    }
  }

  FutureOr<void> _onAddRestaurantProduct(
    AddRestaurantProduct event,
    Emitter<RestaurantDetailsState> emit,
  ) async {
    try {
      final state = this.state;

      if (state is RestaurantDetailsLoaded) {
        // Loading
        emit(RestaurantDetailsLoading());

        Response res = await _restaurantRepository.addProduct(
          event.product,
        );
        final json = jsonDecode(res.body);

        if (res.statusCode == 200) {
          Product product = Product.fromJson(
            jsonEncode(json['product']),
          );

          Restaurant restaurant = state.currentRestaurant;

          if (restaurant.products == null) {
            restaurant = restaurant.copyWith(
              products: [product],
            );
          } else {
            restaurant.products!.add(product);
          }

          emit(
            RestaurantDetailsLoaded(currentRestaurant: restaurant),
          );
        } else {
          emit(RestaurantDetailsError(json['message']));
        }
      }
    } catch (e) {
      emit(RestaurantDetailsError(e.toString()));
    }
  }

  FutureOr<void> _onDeleteRestaurantProduct(
    DeleteRestaurantProduct event,
    Emitter<RestaurantDetailsState> emit,
  ) async {
    final state = this.state;

    try {
      if (state is RestaurantDetailsLoaded) {
        // Loading
        emit(RestaurantDetailsLoading());

        Response res = await _restaurantRepository.deleteProduct(event.product);
        final json = jsonDecode(res.body);

        if (res.statusCode == 200) {
          Restaurant restaurant = state.currentRestaurant;

          int index = restaurant.products!
              .indexWhere((element) => element.id == event.product.id);

          restaurant.products!.removeAt(index);

          emit(
            RestaurantDetailsLoaded(currentRestaurant: restaurant),
          );
        } else {
          emit(RestaurantDetailsError(json['message']));
        }
      }
    } catch (e) {
      emit(RestaurantDetailsError(e.toString()));
    }
  }

  FutureOr<void> _onUpdateRestaurantOpeningHours(
    UpdateRestaurantOpeningHours event,
    Emitter<RestaurantDetailsState> emit,
  ) async {
    final state = this.state;

    try {
      if (state is RestaurantDetailsLoaded) {
        // Loading
        emit(RestaurantDetailsLoading());

        Response res = await _restaurantRepository.updateOpeningHours(
          state.currentRestaurant.id!,
          event.openingHours,
        );
        final json = jsonDecode(res.body);

        if (res.statusCode == 200) {
          Restaurant restaurant = Restaurant.fromJson(
            jsonEncode(json['restaurant']),
          );

          emit(
            RestaurantDetailsLoaded(currentRestaurant: restaurant),
          );
        } else {
          emit(RestaurantDetailsError(json['message']));
        }
      }
    } catch (e) {
      emit(RestaurantDetailsError(e.toString()));
    }
  }

  FutureOr<void> _onUpdateFeaturedProduct(
    UpdateFeaturedProduct event,
    Emitter<RestaurantDetailsState> emit,
  ) async {
    final state = this.state;

    try {
      if (state is RestaurantDetailsLoaded) {
        // Loading
        emit(RestaurantDetailsLoading());

        Response res = await _restaurantRepository.updateFeaturedProduct(
          event.productID,
        );
        final json = jsonDecode(res.body);

        if (res.statusCode == 200) {
          Product product = Product.fromJson(
            jsonEncode(json['product']),
          );

          Restaurant restaurant = state.currentRestaurant;

          int index = restaurant.products!
              .indexWhere((element) => element.id == event.productID);

          restaurant.products![index] = product;

          emit(
            RestaurantDetailsLoaded(currentRestaurant: restaurant),
          );
        } else {
          emit(RestaurantDetailsError(json['message']));
        }
      }
    } catch (e) {
      emit(RestaurantDetailsError(e.toString()));
    }
  }
}
