import 'dart:convert';

import 'package:equatable/equatable.dart';

class Discount extends Equatable {
  final String? id;
  final String title;
  final String description;
  final String? image;

  const Discount({
    this.id,
    required this.title,
    required this.description,
    this.image,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        image,
      ];

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      if (image != null) 'image': image,
    };
  }

  factory Discount.fromMap(Map<String, dynamic> map) {
    return Discount(
      id: map['_id'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      image: map['image']['url'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Discount.fromJson(String source) =>
      Discount.fromMap(json.decode(source));
}
