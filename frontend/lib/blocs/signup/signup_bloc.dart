import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/repositories/auth/auth_repository.dart';
import 'package:http/http.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthRepository _authRepository;

  SignupBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignupInitial()) {
    on<SignupSubmit>(_onSignupSubmit);
    on<ActivateEmail>(_onActivateEmail);
    on<ForgotPassword>(_onForgotPassword);
    on<ResetPassword>(_onResetPassword);
  }

  FutureOr<void> _onSignupSubmit(
    SignupSubmit event,
    Emitter<SignupState> emit,
  ) async {
    try {
      emit(SignupLoading());

      Response res = await _authRepository.signUp(
        email: event.email,
        password: event.password,
        name: event.name,
      );
      final json = jsonDecode(res.body);

      if (res.statusCode == 200) {
        emit(SignupLoaded(
          message: json['message'],
          token: json['activationToken'],
          email: event.email,
          password: event.password,
          name: event.name,
        ));
      } else {
        emit(SignupFailed(message: json['message']));
      }
    } catch (e) {
      emit(SignupFailed(message: e.toString()));
    }
  }

  FutureOr<void> _onActivateEmail(
    ActivateEmail event,
    Emitter<SignupState> emit,
  ) async {
    try {
      emit(SignupLoading());

      Response res = await _authRepository.activateEmail(
        token: event.token,
        otp: event.otp,
      );
      final json = jsonDecode(res.body);

      if (res.statusCode == 200) {
        emit(SignupLoaded(message: json['message'], token: event.token));
      } else {
        emit(SignupFailed(message: json['message']));
      }
    } catch (e) {
      emit(SignupFailed(message: e.toString()));
    }
  }

  FutureOr<void> _onForgotPassword(
    ForgotPassword event,
    Emitter<SignupState> emit,
  ) async {
    try {
      emit(SignupLoading());

      Response res = await _authRepository.forgotPassword(
        email: event.email,
      );
      final json = jsonDecode(res.body);

      if (res.statusCode == 200) {
        emit(SignupLoaded(
          email: event.email,
          message: json['message'],
          token: json['resetPasswordToken'],
        ));
      } else {
        emit(SignupFailed(message: json['message']));
      }
    } catch (e) {
      emit(SignupFailed(message: e.toString()));
    }
  }

  FutureOr<void> _onResetPassword(
    ResetPassword event,
    Emitter<SignupState> emit,
  ) async {
    try {
      emit(SignupLoading());

      Response res = await _authRepository.resetPassword(
        token: event.token,
        newPassword: event.newPassword,
        otp: event.otp,
      );
      final json = jsonDecode(res.body);

      if (res.statusCode == 200) {
        emit(SignupLoaded(
          message: json['message'],
          token: event.token,
        ));
      } else {
        emit(SignupFailed(message: json['message']));
      }
    } catch (e) {
      emit(SignupFailed(message: e.toString()));
    }
  }
}
