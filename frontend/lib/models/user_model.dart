import 'dart:convert';

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? id;
  final String name;
  final String email;
  final String? password;
  final bool socialAuth;
  final String? avatar;
  final String? phoneNumber;

  const User({
    this.id,
    required this.name,
    required this.email,
    this.password,
    this.socialAuth = false,
    this.avatar,
    this.phoneNumber,
  });

  @override
  List<Object?> get props =>
      [id, name, email, password, socialAuth, avatar, phoneNumber];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'socialAuth': socialAuth,
      'avatar': avatar,
      'phoneNumber': phoneNumber,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'],
      name: map['name'].toString(),
      email: map['email'].toString(),
      password: map['password'],
      socialAuth: map['socialAuth'] ?? false,
      avatar: map['avatar'],
      phoneNumber: map['phoneNumber'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
