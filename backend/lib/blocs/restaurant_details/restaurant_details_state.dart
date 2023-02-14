part of 'restaurant_details_bloc.dart';

abstract class RestaurantDetailsState extends Equatable {
  const RestaurantDetailsState();
  
  @override
  List<Object> get props => [];
}

class RestaurantDetailsInitial extends RestaurantDetailsState {}

class RestaurantDetailsLoading extends RestaurantDetailsState {}

class RestaurantDetailsLoaded extends RestaurantDetailsState {
  final Restaurant currentRestaurant;
  
  const RestaurantDetailsLoaded({
    required this.currentRestaurant,
  });
  
  @override
  List<Object> get props => [currentRestaurant];
}

class RestaurantDetailsError extends RestaurantDetailsState {
  final String message;

  const RestaurantDetailsError(this.message);

  @override
  List<Object> get props => [message];
}
