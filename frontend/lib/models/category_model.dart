import 'dart:convert';

import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String? id;
  final String name;
  final String description;
  final String image;

  const Category({
    this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  @override
  List<Object?> get props => [id, name, description, image];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'image': image,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['_id'],
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      image: map['image']['url'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source));

  static List<Category> categories = [
    Category(
      id: '1',
      name: 'Drinks',
      description: 'This is a test description',
      image:
          'https://github.com/maxonflutter/flutter_food_delivery_series/blob/17_save_the_basket_with_hive/assets/juice.png?raw=true',
    ),
    Category(
      id: '2',
      name: 'Pizza',
      description: 'This is a test description',
      image:
          'https://github.com/maxonflutter/flutter_food_delivery_series/blob/17_save_the_basket_with_hive/assets/pizza.png?raw=true',
    ),
    Category(
      id: '3',
      name: 'Burgers',
      description: 'This is a test description',
      image:
          'https://github.com/maxonflutter/flutter_food_delivery_series/blob/17_save_the_basket_with_hive/assets/burger.png?raw=true',
    ),
    Category(
      id: '4',
      name: 'Desserts',
      description: 'This is a test description',
      image:
          'https://github.com/maxonflutter/flutter_food_delivery_series/blob/17_save_the_basket_with_hive/assets/pancake.png?raw=true',
    ),
    Category(
      id: '5',
      name: 'Salads',
      description: 'This is a test description',
      image:
          'https://github.com/maxonflutter/flutter_food_delivery_series/blob/17_save_the_basket_with_hive/assets/avocado.png?raw=true',
    ),
  ];
}
