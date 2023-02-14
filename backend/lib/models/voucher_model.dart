import 'dart:convert';

import 'package:equatable/equatable.dart';

class Voucher extends Equatable {
  final String? id;
  final String code;
  final double value;

  const Voucher({
    this.id,
    required this.code,
    required this.value,
  });

  @override
  List<Object?> get props => [id, code, value];

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'value': value,
    };
  }

  factory Voucher.fromMap(Map<String, dynamic> map) {
    return Voucher(
      id: map['_id'],
      code: map['code'] ?? '',
      value: map['value']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Voucher.fromJson(String source) => Voucher.fromMap(json.decode(source));
}
