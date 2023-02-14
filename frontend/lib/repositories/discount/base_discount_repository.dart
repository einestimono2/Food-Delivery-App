import 'package:http/http.dart';

abstract class BaseDiscountRepository {
  Future<Response> getDiscounts();
}
