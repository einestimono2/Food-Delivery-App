import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';

part 'voucher_event.dart';
part 'voucher_state.dart';

class VoucherBloc extends Bloc<VoucherEvent, VoucherState> {
  final VoucherRepository _voucherRepository;

  VoucherBloc({required VoucherRepository voucherRepository})
      : _voucherRepository = voucherRepository,
        super(VoucherInitial()) {
    on<LoadVouchers>(_onLoadVouchers);
    on<AddVoucher>(_onAddVoucher);
    on<UpdateVoucher>(_onUpdateVoucher);
    on<DeleteVoucher>(_onDeleteVoucher);
  }

  FutureOr<void> _onLoadVouchers(
    LoadVouchers event,
    Emitter<VoucherState> emit,
  ) async {
    try {
      // Loading
      emit(VoucherLoading());
      //
      Response res = await _voucherRepository.getVouchers();
      final json = jsonDecode(res.body);

      if (res.statusCode == 200) {
        List<Voucher> vouchers = [];

        for (int i = 0; i < json['vouchers'].length; i++) {
          vouchers.add(Voucher.fromJson(jsonEncode(json['vouchers'][i])));
        }

        emit(
          VoucherLoaded(
            vouchers: vouchers,
          ),
        );
      } else {
        emit(VoucherError(json['message']));
      }
    } catch (e) {
      emit(VoucherError(e.toString()));
    }
  }

  FutureOr<void> _onAddVoucher(
    AddVoucher event,
    Emitter<VoucherState> emit,
  ) async {
    try {
      final state = this.state;

      if (state is VoucherLoaded) {
        // Loading
        emit(VoucherLoading());

        Response res = await _voucherRepository.addVoucher(event.voucher);
        final json = jsonDecode(res.body);

        if (res.statusCode == 200) {
          Voucher voucher = Voucher.fromJson(
            jsonEncode(json['voucher']),
          );

          emit(
            VoucherLoaded(
              vouchers: List.from(state.vouchers)..add(voucher),
            ),
          );
        } else {
          emit(VoucherError(json['message']));
        }
      }
    } catch (e) {
      emit(VoucherError(e.toString()));
    }
  }

  FutureOr<void> _onUpdateVoucher(
    UpdateVoucher event,
    Emitter<VoucherState> emit,
  ) async {
    final state = this.state;

    try {
      if (state is VoucherLoaded) {
        // Loading
        emit(VoucherLoading());

        Response res = await _voucherRepository.updateVoucher(event.voucher);
        final json = jsonDecode(res.body);

        if (res.statusCode == 200) {
          int index = state.vouchers.indexWhere(
            (element) => element.id == event.voucher.id,
          );

          state.vouchers[index] = Voucher.fromJson(
            jsonEncode(json['voucher']),
          );

          emit(
            VoucherLoaded(
              vouchers: state.vouchers,
            ),
          );
        } else {
          emit(VoucherError(json['message']));
        }
      }
    } catch (e) {
      emit(VoucherError(e.toString()));
    }
  }

  FutureOr<void> _onDeleteVoucher(
    DeleteVoucher event,
    Emitter<VoucherState> emit,
  ) async {
    try {
      final state = this.state;

      if (state is VoucherLoaded) {
        // Loading
        emit(VoucherLoading());

        Response res = await _voucherRepository.deleteVoucher(event.voucher);

        if (res.statusCode == 200) {
          emit(
            VoucherLoaded(
              vouchers: List.from(state.vouchers)..remove(event.voucher),
            ),
          );
        } else {
          emit(VoucherError(jsonDecode(res.body)['message']));
        }
      }
    } catch (e) {
      emit(VoucherError(e.toString()));
    }
  }
}
