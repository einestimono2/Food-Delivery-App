part of 'restaurant_details_bloc.dart';

abstract class RestaurantDetailsEvent extends Equatable {
  const RestaurantDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadRestaurant extends RestaurantDetailsEvent {
  final String restaurantID;

  const LoadRestaurant({
    required this.restaurantID,
  });

  @override
  List<Object> get props => [restaurantID];
}

class AddRestaurantCategory extends RestaurantDetailsEvent {
  final Category category;

  const AddRestaurantCategory({
    required this.category,
  });

  @override
  List<Object> get props => [category];
}

class DeleteRestaurantCategory extends RestaurantDetailsEvent {
  final Category category;

  const DeleteRestaurantCategory({
    required this.category,
  });

  @override
  List<Object> get props => [category];
}

class AddRestaurantProduct extends RestaurantDetailsEvent {
  final Product product;

  const AddRestaurantProduct({
    required this.product,
  });

  @override
  List<Object> get props => [product];
}

class DeleteRestaurantProduct extends RestaurantDetailsEvent {
  final Product product;

  const DeleteRestaurantProduct({
    required this.product,
  });

  @override
  List<Object> get props => [product];
}

class UpdateRestaurantOpeningHours extends RestaurantDetailsEvent {
  final List<OpeningHours> openingHours;

  const UpdateRestaurantOpeningHours({
    required this.openingHours,
  });

  @override
  List<Object> get props => [openingHours];
}

class UpdateFeaturedProduct extends RestaurantDetailsEvent {
  final String productID;

  const UpdateFeaturedProduct({
    required this.productID,
  });

  @override
  List<Object> get props => [productID];
}
