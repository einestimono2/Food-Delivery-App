import 'package:http/http.dart';

abstract class BaseVoucherRepository {
  Future<Response> getVouchers();
}
