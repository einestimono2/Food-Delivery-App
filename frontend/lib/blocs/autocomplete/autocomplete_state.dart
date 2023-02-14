part of 'autocomplete_bloc.dart';

abstract class AutocompleteState extends Equatable {
  const AutocompleteState();
  
  @override
  List<Object> get props => [];
}

class AutocompleteInitial extends AutocompleteState {}
