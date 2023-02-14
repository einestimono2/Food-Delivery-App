import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/repositories/repositories.dart';
import 'package:http/http.dart';

import '../../models/models.dart';

part 'voucher_event.dart';
part 'voucher_state.dart';

class VoucherBloc extends Bloc<VoucherEvent, VoucherState> {
  final VoucherRepository _voucherRepository;

  VoucherBloc({required VoucherRepository voucherRepository})
      : _voucherRepository = voucherRepository,
        super(VoucherInitial()) {
    on<LoadVouchers>(_onLoadVouchers);
  }

  FutureOr<void> _onLoadVouchers(
    LoadVouchers event,
    Emitter<VoucherState> emit,
  ) async {
    try {
      emit(VoucherLoading());

      Response res = await _voucherRepository.getVouchers();
      final json = jsonDecode(res.body);

      if (res.statusCode == 200) {
        List<Voucher> vouchers = <Voucher>[];

        for (int i = 0; i < json['vouchers'].length; i++) {
          vouchers.add(Voucher.fromJson(jsonEncode(json['vouchers'][i])));
        }

        emit(VoucherLoaded(vouchers: vouchers));
      } else {
        emit(VoucherError(message: json['message']));
      }
    } catch (e) {
      emit(VoucherError(message: e.toString()));
    }
  }
}
