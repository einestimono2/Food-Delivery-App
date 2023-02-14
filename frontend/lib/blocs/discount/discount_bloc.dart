import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/repositories/discount/discount_repository.dart';
import 'package:http/http.dart';

import '../../models/models.dart';

part 'discount_event.dart';
part 'discount_state.dart';

class DiscountBloc extends Bloc<DiscountEvent, DiscountState> {
  final DiscountRepository _discountRepository;

  DiscountBloc({required DiscountRepository discountRepository})
      : _discountRepository = discountRepository,
        super(DiscountInitial()) {
    on<LoadDiscounts>(_onLoadDiscounts);
  }

  FutureOr<void> _onLoadDiscounts(
    LoadDiscounts event,
    Emitter<DiscountState> emit,
  ) async {
    try {
      emit(DiscountLoading());

      Response res = await _discountRepository.getDiscounts();
      final json = jsonDecode(res.body);

      if (res.statusCode == 200) {
        List<Discount> discounts = <Discount>[];

        for (int i = 0; i < json['discounts'].length; i++) {
          discounts.add(Discount.fromJson(jsonEncode(json['discounts'][i])));
        }

        emit(DiscountLoaded(
          discounts: discounts,
        ));
      } else {
        emit(DiscountError(message: json['message']));
      }
    } catch (e) {
      emit(DiscountError(message: e.toString()));
    }
  }
}
