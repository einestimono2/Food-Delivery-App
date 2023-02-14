part of 'discount_bloc.dart';

abstract class DiscountState extends Equatable {
  const DiscountState();

  @override
  List<Object> get props => [];
}

class DiscountInitial extends DiscountState {}

class DiscountLoading extends DiscountState {}

class DiscountLoaded extends DiscountState {
  final List<Discount> discounts;

  const DiscountLoaded({
    required this.discounts,
  });

  @override
  List<Object> get props => [discounts];
}

class DiscountError extends DiscountState {
  final String message;

  const DiscountError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
