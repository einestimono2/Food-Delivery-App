part of 'signin_bloc.dart';

abstract class SigninState extends Equatable {
  const SigninState();

  @override
  List<Object> get props => [];
}

class SigninInitial extends SigninState {}

class SigninLoading extends SigninState {}

class SigninLoaded extends SigninState {
  final User user;
  final String token;

  const SigninLoaded({
    required this.user,
    required this.token,
  });

  @override
  List<Object> get props => [user, token];
}

class SigninFailed extends SigninState {
  final String message;

  const SigninFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
