
import 'package:http/http.dart';

import '../../constants/constants.dart';
import '../repositories.dart';

class CategoryRepository extends BaseCategoryRepository {
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
}
