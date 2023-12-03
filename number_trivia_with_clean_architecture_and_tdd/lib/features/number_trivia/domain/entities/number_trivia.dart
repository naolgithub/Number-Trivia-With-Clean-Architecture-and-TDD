// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class NumberTrivia extends Equatable {
  final String text;
  final int number;
  const NumberTrivia({
    required this.text,
    required this.number,
  });

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

  @override
  List<Object> get props => [text, number];
}
