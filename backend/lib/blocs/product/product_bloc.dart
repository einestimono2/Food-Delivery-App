import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

import '../../constants/constants.dart';
import '../../models/models.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
  }

  FutureOr<void> _onLoadProducts(
      LoadProducts event, Emitter<ProductState> emit) async {
    try {
      // Loading
      emit(ProductLoading());
      //
      Response res = await get(
        Uri.parse('$url/products'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      final json = jsonDecode(res.body);

      if (res.statusCode == 200) {
        List<Product> products = [];

        for (int i = 0; i < json['products'].length; i++) {
          products.add(
            Product.fromJson(jsonEncode(json['products'][i])),
          );
        }

        emit(
          ProductLoaded(products: products),
        );
      } else {
        print(json['message']);
        emit(ProductError(json['message']));
      }
    } catch (e) {
      print(e.toString());
      emit(ProductError(e.toString()));
    }
  }
}
