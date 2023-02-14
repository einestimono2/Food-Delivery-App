import 'dart:convert';

import 'package:equatable/equatable.dart';

class OpeningHours extends Equatable {
  final String? id;
  final String day;
  final double openAt;
  final double closeAt;
  final bool isOpen;

  const OpeningHours({
    this.id,
    required this.day,
    required this.openAt,
    required this.closeAt,
    required this.isOpen,
  });

  @override
  List<Object?> get props => [id, day, openAt, closeAt, isOpen];

  static List<OpeningHours> openingHoursList = const [
    OpeningHours(
      day: 'Monday',
      openAt: 0,
      closeAt: 24,
      isOpen: false,
    ),
    OpeningHours(
      day: 'Tuesday',
      openAt: 0,
      closeAt: 24,
      isOpen: false,
    ),
    OpeningHours(
      day: 'Wednesday',
      openAt: 0,
      closeAt: 24,
      isOpen: false,
    ),
    OpeningHours(
      day: 'Thursday',
      openAt: 0,
      closeAt: 24,
      isOpen: false,
    ),
    OpeningHours(
      day: 'Friday',
      openAt: 0,
      closeAt: 24,
      isOpen: false,
    ),
    OpeningHours(
      day: 'Saturday',
      openAt: 0,
      closeAt: 24,
      isOpen: false,
    ),
    OpeningHours(
      day: 'Sunday',
      openAt: 0,
      closeAt: 24,
      isOpen: false,
    ),
  ];

  OpeningHours copyWith({
    String? id,
    String? day,
    double? openAt,
    double? closeAt,
    bool? isOpen,
  }) {
    return OpeningHours(
      id: id ?? this.id,
      day: day ?? this.day,
      openAt: openAt ?? this.openAt,
      closeAt: closeAt ?? this.closeAt,
      isOpen: isOpen ?? this.isOpen,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'openAt': openAt,
      'closeAt': closeAt,
      'isOpen': isOpen,
    };
  }

  factory OpeningHours.fromMap(Map<String, dynamic> map) {
    return OpeningHours(
      id: map['_id'],
      day: map['day'] ?? '',
      openAt: map['openAt']?.toDouble() ?? 0.0,
      closeAt: map['closeAt']?.toDouble() ?? 0.0,
      isOpen: map['isOpen'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory OpeningHours.fromJson(String source) => OpeningHours.fromMap(json.decode(source));
}
