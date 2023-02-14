part of 'signout_bloc.dart';

abstract class SignoutState extends Equatable {
  const SignoutState();
  
  @override
  List<Object> get props => [];
}

class SignoutInitial extends SignoutState {}

class SignoutLoading extends SignoutState {}

class SignoutLoaded extends SignoutState {}

class SignoutFailed extends SignoutState {
  final String message;

  const SignoutFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
