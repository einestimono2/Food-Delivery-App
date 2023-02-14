import 'dart:convert';

import 'package:equatable/equatable.dart';

class Discount extends Equatable {
  final String? id;
  final String title;
  final String description;
  final String image;

  const Discount({
    this.id,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        image,
      ];

  static List<Discount> discounts = [
    Discount(
      id: '1',
      title: 'FREE Delivery on Your First 3 Orders.',
      description:
          'Place an order of \$10 or more and the delivery fee is on us',
      image:
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
    ),
    Discount(
      id: '2',
      title: '20% off on Selected Restaurants.',
      description: 'Get a discount at more than 200+ restaurants',
      image:
          'https://images.unsplash.com/photo-1428515613728-6b4607e44363?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
    ),
    Discount(
      id: '3',
      title: '30% off on MacDonald\'s.',
      description:
          'Get Discount of 30% at MacDonald\'s on your first order & Instant cashback',
      image:
          'https://github.com/abuanwar072/Food-Ordering-App/blob/master/assets/images/beyond-meat-mcdonalds.png?raw=true',
    )
  ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
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
