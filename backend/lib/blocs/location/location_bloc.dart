import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository _locationRepository;
  
  LocationBloc({required LocationRepository locationRepository})
      : _locationRepository = locationRepository,
        super(LocationInitial()) {
    on<LoadMap>(_onLoadMap);
    
  }

  FutureOr<void> _onLoadMap(LoadMap event, Emitter<LocationState> emit) async {
    emit(LocationLoading());

    Position? position = await _locationRepository.getCurrentLocation();

    if (position == null) {
      emit(
        const LocationLoaded(
          place: Place(lat: 21.028511, lon: 105.804817),
        ),
      );
    } else {
      emit(
        LocationLoaded(
          place: Place(lat: position.latitude, lon: position.longitude),
        ),
      );
    }
  }
}
