import 'package:http/http.dart';

abstract class BaseCategoryRepository {
  Future<Response> getCategories();
}
