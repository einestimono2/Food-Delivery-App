part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class LoadCategories extends CategoryEvent {}

class AddCategory extends CategoryEvent {
  final Category category;

  const AddCategory({
    required this.category,
  });

  @override
  List<Object> get props => [category];
}

class UpdateCategory extends CategoryEvent {
  final Category category;

  const UpdateCategory({
    required this.category,
  });

  @override
  List<Object> get props => [category];
}

class DeleteCategory extends CategoryEvent {
  final Category category;

  const DeleteCategory({
    required this.category,
  });

  @override
  List<Object> get props => [category];
}
