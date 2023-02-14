import 'package:http/http.dart';

import '../../models/models.dart';

abstract class BaseVoucherRepository {
  Future<Response> getVouchers();
  Future<Response> addVoucher(Voucher voucher);
  Future<Response> updateVoucher(Voucher voucher);
  Future<Response> deleteVoucher(Voucher voucher);
}
