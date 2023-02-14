import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';

part 'discount_event.dart';
part 'discount_state.dart';

class DiscountBloc extends Bloc<DiscountEvent, DiscountState> {
  final DiscountRepository _discountRepository;

  DiscountBloc({required DiscountRepository discountRepository})
      : _discountRepository = discountRepository,
        super(DiscountInitial()) {
    on<LoadDiscounts>(_onLoadDiscounts);
    on<AddDiscount>(_onAddDiscount);
    on<UpdateDiscount>(_onUpdateDiscount);
    on<DeleteDiscount>(_onDeleteDiscount);
  }

  FutureOr<void> _onLoadDiscounts(
    LoadDiscounts event,
    Emitter<DiscountState> emit,
  ) async {
    try {
      // Loading
      emit(DiscountLoading());
      //
      Response res = await _discountRepository.getDiscounts();
      final json = jsonDecode(res.body);

      if (res.statusCode == 200) {
        List<Discount> discounts = [];

        for (int i = 0; i < json['discounts'].length; i++) {
          discounts.add(Discount.fromJson(jsonEncode(json['discounts'][i])));
        }

        emit(
          DiscountLoaded(
            discounts: discounts,
          ),
        );
      } else {
        emit(DiscountError(json['message']));
      }
    } catch (e) {
      emit(DiscountError(e.toString()));
    }
  }

  FutureOr<void> _onAddDiscount(
    AddDiscount event,
    Emitter<DiscountState> emit,
  ) async {
    try {
      final state = this.state;

      if (state is DiscountLoaded) {
        // Loading
        emit(DiscountLoading());

        Response res = await _discountRepository.addDiscount(event.discount);
        final json = jsonDecode(res.body);

        if (res.statusCode == 200) {
          Discount discount = Discount.fromJson(
            jsonEncode(json['discount']),
          );

          emit(
            DiscountLoaded(
              discounts: List.from(state.discounts)..add(discount),
            ),
          );
        } else {
          emit(DiscountError(json['message']));
        }
      }
    } catch (e) {
      emit(DiscountError(e.toString()));
    }
  }

  FutureOr<void> _onUpdateDiscount(
    UpdateDiscount event,
    Emitter<DiscountState> emit,
  ) async {
    try {
      final state = this.state;

      if (state is DiscountLoaded) {
        // Loading
        emit(DiscountLoading());

        Response res = await _discountRepository.updateDiscount(event.discount);
        final json = jsonDecode(res.body);

        if (res.statusCode == 200) {
          int index = state.discounts.indexWhere(
            (element) => element.id == event.discount.id,
          );

          state.discounts[index] = Discount.fromJson(
            jsonEncode(json['discount']),
          );

          emit(
            DiscountLoaded(
              discounts: state.discounts,
            ),
          );
        } else {
          emit(DiscountError(jsonDecode(res.body)['message']));
        }
      }
    } catch (e) {
      emit(DiscountError(e.toString()));
    }
  }

  FutureOr<void> _onDeleteDiscount(
    DeleteDiscount event,
    Emitter<DiscountState> emit,
  ) async {
    final state = this.state;

    try {
      if (state is DiscountLoaded) {
        // Loading
        emit(DiscountLoading());

        Response res = await _discountRepository.deleteDiscount(event.discount);
        final json = jsonDecode(res.body);

        if (res.statusCode == 200) {
          emit(
            DiscountLoaded(
              discounts: List.from(state.discounts)..remove(event.discount),
            ),
          );
        } else {
          emit(DiscountError(json['message']));
        }
      }
    } catch (e) {
      emit(DiscountError(e.toString()));
    }
  }
}
