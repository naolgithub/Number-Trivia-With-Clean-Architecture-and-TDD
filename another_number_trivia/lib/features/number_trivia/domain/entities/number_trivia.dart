// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class NumberTrivia extends Equatable {
  final String text;
  final int number;
  const NumberTrivia({
    required this.text,
    required this.number,
  });

  NumberTrivia copyWith({
    String? text,
    int? number,
  }) {
    return NumberTrivia(
      text: text ?? this.text,
      number: number ?? this.number,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'number': number,
    };
  }

  factory NumberTrivia.fromMap(Map<String, dynamic> map) {
    return NumberTrivia(
      text: map['text'] as String,
      number: map['number'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory NumberTrivia.fromJson(String source) =>
      NumberTrivia.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [text, number];
}
