import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

import '../../repositories/repositories.dart';

part 'signout_event.dart';
part 'signout_state.dart';

class SignoutBloc extends Bloc<SignoutEvent, SignoutState> {
  final AuthRepository _authRepository;

  SignoutBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignoutInitial()) {
    on<SignoutSubmit>(_onSignoutSubmit);
  }

  FutureOr<void> _onSignoutSubmit(
    SignoutSubmit event,
    Emitter<SignoutState> emit,
  ) async {
    try {
      emit(SignoutLoading());

      Response res = await _authRepository.signOut();
      final json = jsonDecode(res.body);

      if (res.statusCode == 200) {
        emit(SignoutLoaded());
      } else {
        emit(SignoutFailed(message: json['message']));
      }
    } catch (e) {
      emit(SignoutFailed(message: e.toString()));
    }
  }
}
