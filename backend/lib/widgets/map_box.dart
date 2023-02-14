import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/plugin_api.dart';
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';

import '../blocs/blocs.dart';
import '../models/models.dart';

class MapBox extends StatefulWidget {
  const MapBox({
    Key? key,
    this.setAddress,
  }) : super(key: key);

  final Function({
    String? name,
    required double lat,
    required double lon,
  })? setAddress;

  @override
  State<MapBox> createState() => _MapBoxState();
}

class _MapBoxState extends State<MapBox> {
  late MapController _mapController;
  Marker? position;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    BlocProvider.of<LocationBloc>(context).add(LoadMap());
  }

  @override
  void dispose() {
    super.dispose();
    _mapController.dispose();
  }

  _setCamera(Place place) {
    position = Marker(
      point: LatLng(
        place.lat,
        place.lon,
      ),
      builder: (context) => const Icon(
        Icons.location_pin,
        color: Colors.green,
        size: 48,
      ),
    );

    if (widget.setAddress != null) {
      widget.setAddress!(
        name: place.name,
        lat: place.lat,
        lon: place.lon,
      );
    }

    _mapController.move(
      LatLng(
        place.lat,
        place.lon,
      ),
      15,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(
        color: Colors.grey,
        width: 1,
      ),
    );

    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        if (state is LocationLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is LocationLoaded) {
          return Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    center: LatLng(state.place.lat, state.place.lon),
                    zoom: 15,
                    onTap: (tapPosition, point) => _setCamera(
                      Place(lat: point.latitude, lon: point.longitude),
                    ),
                  ),
                  nonRotatedChildren: [
                    AttributionWidget.defaultWidget(
                      source: 'OpenStreetMap contributors',
                      onSourceTapped: () {},
                    ),
                  ],
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(state.place.lat, state.place.lon),
                          builder: (context) => const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 42,
                          ),
                        ),
                        if (position != null) position!,
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 25, 50, 10),
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter the address to search",
                          enabledBorder: outlineInputBorder,
                          focusedBorder: outlineInputBorder,
                          border: outlineInputBorder,
                          suffixIcon: const Icon(Icons.search),
                        ),
                        onChanged: (value) async => context
                            .read<AutocompleteBloc>()
                            .add(LoadAutocomplete(searchInput: value)),
                      ),
                    ),
                    _buildSearchBoxSuggestions(),
                  ],
                ),
              ),
            ],
          );
        } else {
          return const Text('Something went wrong!');
        }
      },
    );
  }

  _buildSearchBoxSuggestions() =>
      BlocBuilder<AutocompleteBloc, AutocompleteState>(
        builder: (context, state) {
          if (state is AutocompleteLoading || state is AutocompleteInitial) {
            return const SizedBox();
          }
          if (state is AutocompleteLoaded) {
            return state.places.isEmpty
                ? const SizedBox()
                : Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: state.places.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.black.withOpacity(0.6),
                          child: ListTile(
                            title: Text(
                              state.places[index].name!,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(color: Colors.white),
                            ),
                            onTap: () {
                              _setCamera(state.places[index]);
                              context
                                  .read<AutocompleteBloc>()
                                  .add(ClearAutocomplete());
                            },
                          ),
                        );
                      },
                    ),
                  );
          } else {
            return const Text('Something went wrong!');
          }
        },
      );
}
