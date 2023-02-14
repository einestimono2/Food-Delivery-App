import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final AuthRepository _authRepository;

  SigninBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SigninInitial()) {
    on<SigninSubmit>(_onSigninSubmit);
  }

  FutureOr<void> _onSigninSubmit(
    SigninSubmit event,
    Emitter<SigninState> emit,
  ) async {
    try {
      emit(SigninLoading());

      Response res = await _authRepository.signIn(
        email: event.email,
        password: event.password,
      );
      final json = jsonDecode(res.body);

      if (res.statusCode == 200) {
        emit(SigninLoaded(
          user: User.fromJson(jsonEncode(json['user'])),
          token: json['token'],
        ));
      } else {
        emit(SigninFailed(message: json['message']));
      }
    } catch (e) {
      emit(SigninFailed(message: e.toString()));
    }
  }
}
