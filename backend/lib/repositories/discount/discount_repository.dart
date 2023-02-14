import 'package:http/http.dart';

import '../../constants/constants.dart';
import '../../models/models.dart';
import '../repositories.dart';

class DiscountRepository extends BaseDiscountRepository {
  @override
  Future<Response> addDiscount(Discount discount) async {
    Response res = await post(
      Uri.parse('$url/discount'),
      body: discount.toJson(),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }

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

  @override
  Future<Response> deleteDiscount(Discount discount) async {
    Response res = await delete(
      Uri.parse('$url/discount/${discount.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }

  @override
  Future<Response> updateDiscount(Discount discount) async {
    Response res = await patch(
      Uri.parse('$url/discount/${discount.id}'),
      body: discount.toJson(),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }
}
