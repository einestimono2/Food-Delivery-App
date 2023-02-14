
import 'package:http/http.dart';

import '../../constants/constants.dart';
import '../../models/models.dart';
import '../repositories.dart';

class CategoryRepository extends BaseCategoryRepository {
  @override
  Future<Response> addCategory(Category category) async {
    Response res = await post(
      Uri.parse('$url/category'),
      body: category.toJson(),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }

  @override
  Future<Response> getCategories() async {
    Response res = await get(
      Uri.parse('$url/categories'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }

  @override
  Future<Response> deleteCategory(Category category) async {
    Response res = await delete(
      Uri.parse('$url/category/${category.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }

  @override
  Future<Response> updateCategory(Category category) async {
    Response res = await patch(
      Uri.parse('$url/category/${category.id}'),
      body: category.toJson(),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }
}
