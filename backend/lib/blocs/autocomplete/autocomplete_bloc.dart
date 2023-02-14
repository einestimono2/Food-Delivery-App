import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';

part 'autocomplete_event.dart';
part 'autocomplete_state.dart';

class AutocompleteBloc extends Bloc<AutocompleteEvent, AutocompleteState> {
  final LocationRepository _locationRepository;

  AutocompleteBloc({required LocationRepository locationRepository})
      : _locationRepository = locationRepository,
        super(AutocompleteInitial()) {
    on<LoadAutocomplete>(_onLoadAutocomplete);
    on<ClearAutocomplete>(_onClearAutocomplete);
  }

  FutureOr<void> _onLoadAutocomplete(
    LoadAutocomplete event,
    Emitter<AutocompleteState> emit,
  ) async {
    emit(AutocompleteLoading());

    Response res = await _locationRepository.getAutocomplete(event.searchInput);

    List<Place> places = [];

    jsonDecode(res.body).forEach(
      (place) => places.add(Place(
        name: place['display_name'],
        lat: double.parse(place['lat']),
        lon: double.parse(place['lon']),
      )),
    );

    emit(AutocompleteLoaded(places: places));
  }

  FutureOr<void> _onClearAutocomplete(
    ClearAutocomplete event,
    Emitter<AutocompleteState> emit,
  ) {
    emit(AutocompleteLoaded(places: List.empty()));
  }
}
