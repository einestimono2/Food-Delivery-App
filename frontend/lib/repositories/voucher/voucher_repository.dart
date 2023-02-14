
import 'package:http/http.dart';

import '../../constants/constants.dart';
import '../repositories.dart';

class VoucherRepository extends BaseVoucherRepository {
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

  
}
