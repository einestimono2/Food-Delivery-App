import 'package:http/http.dart';

import '../../models/models.dart';

abstract class BaseDiscountRepository {
  Future<Response> getDiscounts();
  Future<Response> addDiscount(Discount discount);
  Future<Response> updateDiscount(Discount discount);
  Future<Response> deleteDiscount(Discount discount);
}
