import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
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
  }

  FutureOr<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      emit(CategoryLoading());

      Response res = await _categoryRepository.getCategories();
      final json = jsonDecode(res.body);

      if (res.statusCode == 200) {
        List<Category> categories = <Category>[];

        for (int i = 0; i < json['categories'].length; i++) {
          categories.add(Category.fromJson(jsonEncode(json['categories'][i])));
        }

        emit(CategoryLoaded(
          categories: categories,
        ));
      } else {
        emit(CategoryError(message: json['message']));
      }
    } catch (e) {
      emit(CategoryError(message: e.toString()));
    }
  }
}
