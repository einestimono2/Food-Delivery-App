part of 'restaurant_bloc.dart';

abstract class RestaurantEvent extends Equatable {
  const RestaurantEvent();

  @override
  List<Object> get props => [];
}

class LoadRestaurants extends RestaurantEvent {}

class CreateRestaurant extends RestaurantEvent {
  final Restaurant restaurant;

  const CreateRestaurant({
    required this.restaurant,
  });

  @override
  List<Object> get props => [restaurant];
}

class UpdateRestaurant extends RestaurantEvent {
  final Restaurant restaurant;

  const UpdateRestaurant({
    required this.restaurant,
  });

  @override
  List<Object> get props => [restaurant];
}

class DeleteRestaurant extends RestaurantEvent {
  final Restaurant restaurant;

  const DeleteRestaurant({
    required this.restaurant,
  });

  @override
  List<Object> get props => [restaurant];
}

class UpdatePopular extends RestaurantEvent {
  final String restaurantID;

  const UpdatePopular({
    required this.restaurantID,
  });

  @override
  List<Object> get props => [restaurantID];
}
