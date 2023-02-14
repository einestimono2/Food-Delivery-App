import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository;

  CategoryBloc({required CategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository,
        super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategory>(_onAddCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<DeleteCategory>(_onDeleteCategory);
  }

  FutureOr<void> _onAddCategory(
    AddCategory event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      final state = this.state;

      if (state is CategoryLoaded) {
        // Loading
        emit(CategoryLoading());

        Response res = await _categoryRepository.addCategory(event.category);
        final json = jsonDecode(res.body);

        if (res.statusCode == 200) {
          Category category = Category.fromJson(
            jsonEncode(json['category']),
          );

          emit(
            CategoryLoaded(
              categories: List.from(state.categories)..add(category),
            ),
          );
        } else {
          emit(CategoryError(json['message']));
        }
      }
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  FutureOr<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      // Loading
      emit(CategoryLoading());
      //
      Response res = await _categoryRepository.getCategories();
      final json = jsonDecode(res.body);

      if (res.statusCode == 200) {
        List<Category> categories = [];

        for (int i = 0; i < json['categories'].length; i++) {
          categories.add(Category.fromJson(jsonEncode(json['categories'][i])));
        }

        emit(
          CategoryLoaded(
            categories: categories,
          ),
        );
      } else {
        emit(CategoryError(json['message']));
      }
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  FutureOr<void> _onDeleteCategory(
    DeleteCategory event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      final state = this.state;

      if (state is CategoryLoaded) {
        // Loading
        emit(CategoryLoading());

        Response res = await _categoryRepository.deleteCategory(event.category);

        if (res.statusCode == 200) {
          emit(
            CategoryLoaded(
              categories: List.from(state.categories)..remove(event.category),
            ),
          );
        } else {
          emit(CategoryError(jsonDecode(res.body)['message']));
        }
      }
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  FutureOr<void> _onUpdateCategory(
    UpdateCategory event,
    Emitter<CategoryState> emit,
  ) async {
    final state = this.state;

    try {
      if (state is CategoryLoaded) {
        // Loading
        emit(CategoryLoading());

        Response res = await _categoryRepository.updateCategory(event.category);
        final json = jsonDecode(res.body);

        if (res.statusCode == 200) {
          int index = state.categories.indexWhere(
            (element) => element.id == event.category.id,
          );

          state.categories[index] = Category.fromJson(
            jsonEncode(json['category']),
          );

          emit(
            CategoryLoaded(
              categories: state.categories,
            ),
          );
        } else {
          emit(CategoryError(json['message']));
        }
      }
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}
