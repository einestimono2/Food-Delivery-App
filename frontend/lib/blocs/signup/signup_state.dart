part of 'signup_bloc.dart';

abstract class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object?> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupLoaded extends SignupState {
  final String? message;
  final String? token;
  final String? name;
  final String? email;
  final String? password;

  const SignupLoaded({
    this.message,
    this.token,
    this.name,
    this.email,
    this.password,
  });

  @override
  List<Object?> get props => [message, token, name, email, password];
}

class SignupFailed extends SignupState {
  final String message;

  const SignupFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
