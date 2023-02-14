part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {}

class AuthChanged extends AuthEvent {
  final User? user;

  const AuthChanged({this.user});

  @override
  List<Object?> get props => [user];
}
