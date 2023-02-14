part of 'voucher_bloc.dart';

abstract class VoucherEvent extends Equatable {
  const VoucherEvent();

  @override
  List<Object> get props => [];
}

class LoadVouchers extends VoucherEvent {}

class AddVoucher extends VoucherEvent {
  final Voucher voucher;

  const AddVoucher({
    required this.voucher,
  });

  @override
  List<Object> get props => [voucher];
}

class UpdateVoucher extends VoucherEvent {
  final Voucher voucher;

  const UpdateVoucher({
    required this.voucher,
  });

  @override
  List<Object> get props => [voucher];
}

class DeleteVoucher extends VoucherEvent {
  final Voucher voucher;

  const DeleteVoucher({
    required this.voucher,
  });

  @override
  List<Object> get props => [voucher];
}
