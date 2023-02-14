part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class SignupSubmit extends SignupEvent {
  final String name;
  final String email;
  final String password;

  const SignupSubmit({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, password];
}

class ActivateEmail extends SignupEvent {
  final String token;
  final String otp;

  const ActivateEmail({
    required this.token,
    required this.otp,
  });

  @override
  List<Object> get props => [token, otp];
}

class ForgotPassword extends SignupEvent {
  final String email;

  const ForgotPassword({
    required this.email,
  });

  @override
  List<Object> get props => [email];
}

class ResetPassword extends SignupEvent {
  final String otp;
  final String token;
  final String newPassword;

  const ResetPassword({
    required this.otp,
    required this.token,
    required this.newPassword,
  });

  @override
  List<Object> get props => [otp, token, newPassword];
}
