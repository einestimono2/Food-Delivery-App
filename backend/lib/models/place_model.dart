import 'dart:convert';

import 'package:equatable/equatable.dart';

class Place extends Equatable {
  final String? name;
  final double lat;
  final double lon;

  const Place({
    this.name,
    required this.lat,
    required this.lon,
  });

  @override
  List<Object?> get props => [name, lat, lon];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lat': lat,
      'lon': lon,
    };
  }

  factory Place.fromMap(Map<String, dynamic> map) {
    return Place(
      name: map['name'],
      lat: map['lat'].toDouble(),
      lon: map['lon'].toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Place.fromJson(String source) => Place.fromMap(json.decode(source));
}
