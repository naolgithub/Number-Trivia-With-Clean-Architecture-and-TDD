import '../../domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  //Simply pass all the constructor parameters
  //to the super class(i.e NumberTrivia entity class)
  const NumberTriviaModel({
    required super.text,
    required super.number,
  });

  factory NumberTriviaModel.fromMap(Map<String, dynamic> map) {
    return NumberTriviaModel(
      text: map['text'],
      // The 'num' type can be both a 'double' and an 'int'
      number: (map['number'] as num).toInt(),
    );
  }
  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'number': number,
    };
  }
}
