
import 'package:http/http.dart';

import '../../constants/constants.dart';
import '../../models/models.dart';
import '../repositories.dart';

class VoucherRepository extends BaseVoucherRepository {
  @override
  Future<Response> addVoucher(Voucher voucher) async {
    Response res = await post(
      Uri.parse('$url/voucher'),
      body: voucher.toJson(),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }

  @override
  Future<Response> getVouchers() async {
    Response res = await get(
      Uri.parse('$url/vouchers'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }

  @override
  Future<Response> deleteVoucher(Voucher voucher) async {
    Response res = await delete(
      Uri.parse('$url/voucher/${voucher.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }

  @override
  Future<Response> updateVoucher(Voucher voucher) async {
    Response res = await patch(
      Uri.parse('$url/voucher/${voucher.id}'),
      body: voucher.toJson(),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }
}
