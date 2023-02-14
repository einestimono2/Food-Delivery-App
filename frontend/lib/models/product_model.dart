import 'dart:convert';

import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String? id;
  final String? restaurant;
  final String category;
  final String name;
  final String description;
  final String image;
  final double price;
  final bool isFeatured;

  const Product({
    this.id,
    this.restaurant,
    this.isFeatured = false,
    required this.name,
    required this.category,
    required this.description,
    required this.image,
    required this.price,
  });

  @override
  List<Object?> get props => [
        id,
        restaurant,
        name,
        category,
        description,
        price,
        image,
        isFeatured,
      ];

      static List<Product> products = [
    Product(
      id: '1',
      restaurant: '1',
      name: 'Margherita',
      category: 'Pizza',
      description: 'Tomatoes, mozzarella, basil',
      price: 4.99,
      image: "https://img.freepik.com/free-photo/delicious-hawaiian-pizza-cooking-ingredients_1150-24289.jpg?w=2000",
    ),
    Product(
      id: '2',
      restaurant: '1',
      name: '4 Formaggi',
      category: 'Pizza',
      description: 'Tomatoes, mozzarella, basil',
      price: 4.99,
      image: "https://img.freepik.com/free-photo/delicious-hawaiian-pizza-cooking-ingredients_1150-24289.jpg?w=2000",
    ),
    Product(
      id: '3',
      restaurant: '1',
      name: 'Baviera',
      category: 'Pizza',
      description: 'Tomatoes, mozzarella, basil',
      price: 4.99,
      image: "https://img.freepik.com/free-photo/delicious-hawaiian-pizza-cooking-ingredients_1150-24289.jpg?w=2000",
    ),
    Product(
      id: '4',
      restaurant: '1',
      name: 'Baviera',
      category: 'Pizza',
      description: 'Tomatoes, mozzarella, basil',
      price: 4.99,
      image: "https://img.freepik.com/free-photo/delicious-hawaiian-pizza-cooking-ingredients_1150-24289.jpg?w=2000",
    ),
    Product(
      id: '5',
      restaurant: '1',
      name: 'Coca Cola',
      category: 'Drink',
      description: 'A fresh drink',
      price: 1.99,
      image: "https://img.freepik.com/free-photo/delicious-hawaiian-pizza-cooking-ingredients_1150-24289.jpg?w=2000",
    ),
    Product(
      id: '6',
      restaurant: '1',
      name: 'Coca Cola',
      category: 'Drink',
      description: 'A fresh drink',
      price: 1.99,
      image: "https://img.freepik.com/free-photo/delicious-hawaiian-pizza-cooking-ingredients_1150-24289.jpg?w=2000",
    ),
    Product(
      id: '7',
      restaurant: '2',
      name: 'Coca Cola',
      category: 'Drink',
      description: 'A fresh drink',
      price: 1.99,
      image: "https://img.freepik.com/free-photo/delicious-hawaiian-pizza-cooking-ingredients_1150-24289.jpg?w=2000",
    ),
    Product(
      id: '8',
      restaurant: '3',
      name: 'Water',
      category: 'Drink',
      description: 'A fresh drink',
      price: 1.99,
      image: "https://img.freepik.com/free-photo/delicious-hawaiian-pizza-cooking-ingredients_1150-24289.jpg?w=2000",
    ),
    Product(
      id: '9',
      restaurant: '2',
      name: 'Caesar Salad',
      category: 'Salad',
      description: 'A fresh drink',
      price: 1.99,
      image: "https://img.freepik.com/free-photo/delicious-hawaiian-pizza-cooking-ingredients_1150-24289.jpg?w=2000",
    ),
    Product(
      id: '10',
      restaurant: '3',
      name: 'CheeseBurger',
      category: 'Burger',
      description: 'A burger with Cheese',
      price: 9.99,
      image: "https://img.freepik.com/free-photo/delicious-hawaiian-pizza-cooking-ingredients_1150-24289.jpg?w=2000",
    ),
    Product(
      id: '11',
      restaurant: '4',
      name: 'Chocolate Cake',
      category: 'Desser',
      description: 'A cake with chocolate',
      price: 9.99,
      image: "https://img.freepik.com/free-photo/delicious-hawaiian-pizza-cooking-ingredients_1150-24289.jpg?w=2000",
    )
  ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'restaurant': restaurant,
      'category': category,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'isFeatured': isFeatured,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['_id'],
      restaurant: map['restaurant'],
      category: map['category'],
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      image: map['image']['url'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      isFeatured: map['isFeatured'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}
