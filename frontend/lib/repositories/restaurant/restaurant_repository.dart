import 'package:http/http.dart';

import '../../constants/constants.dart';
import '../repositories.dart';

class RestaurantRepository extends BaseRestaurantRepository {
  @override
  Future<Response> getRestaurants() async {
    Response res = await get(
      Uri.parse('$url/restaurants'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }
}
