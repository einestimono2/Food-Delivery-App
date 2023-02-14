part of 'discount_bloc.dart';

abstract class DiscountEvent extends Equatable {
  const DiscountEvent();

  @override
  List<Object> get props => [];
}

class LoadDiscounts extends DiscountEvent {}

class AddDiscount extends DiscountEvent {
  final Discount discount;

  const AddDiscount({
    required this.discount,
  });

  @override
  List<Object> get props => [discount];
}

class UpdateDiscount extends DiscountEvent {
  final Discount discount;

  const UpdateDiscount({
    required this.discount,
  });

  @override
  List<Object> get props => [discount];
}

class DeleteDiscount extends DiscountEvent {
  final Discount discount;

  const DeleteDiscount({
    required this.discount,
  });

  @override
  List<Object> get props => [discount];
}
