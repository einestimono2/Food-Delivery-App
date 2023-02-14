import 'package:http/http.dart';

import '../../constants/constants.dart';
import '../repositories.dart';

class DiscountRepository extends BaseDiscountRepository {
  
  @override
  Future<Response> getDiscounts() async {
    Response res = await get(
      Uri.parse('$url/discounts'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }

  
}
