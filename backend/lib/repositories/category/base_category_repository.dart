import 'package:http/http.dart';

import '../../models/models.dart';

abstract class BaseCategoryRepository {
  Future<Response> getCategories();
  Future<Response> addCategory(Category category);
  Future<Response> updateCategory(Category category);
  Future<Response> deleteCategory(Category category);
}
