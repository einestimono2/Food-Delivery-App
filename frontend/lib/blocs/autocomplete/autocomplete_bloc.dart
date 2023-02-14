import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'autocomplete_event.dart';
part 'autocomplete_state.dart';

class AutocompleteBloc extends Bloc<AutocompleteEvent, AutocompleteState> {
  AutocompleteBloc() : super(AutocompleteInitial()) {
    on<AutocompleteEvent>((event, emit) {
      
    });
  }
}
