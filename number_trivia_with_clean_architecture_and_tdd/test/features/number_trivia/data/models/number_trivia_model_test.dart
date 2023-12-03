import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia_with_clean_architecture_and_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia_with_clean_architecture_and_tdd/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(
    number: 1,
    text: 'Test Text',
  );
  test(
    'should be a subclass of NumberTrivia entity',
    () async {
      //arrange

      //act

      //assert
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );
  group(
    'fromJson',
    () {
      test(
        'should return a valid model when the JSON number is an integer',
        () async {
          //arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('trivia.json'));
          //act
          final result = NumberTriviaModel.fromMap(jsonMap);
          //assert
          // expect(result, equals(tNumberTriviaModel));
          //or
          expect(result, tNumberTriviaModel);
        },
      );

      test(
        'should return a valid model when the JSON number is regarded as double',
        () async {
          //arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('trivia_double.json'));
          //act
          final result = NumberTriviaModel.fromMap(jsonMap);
          //assert
          // expect(result, equals(tNumberTriviaModel));
          //or
          expect(result, tNumberTriviaModel);
        },
      );
    },
  );
  group(
    'toJson',
    () {
      test(
        'should return a JSON map containing the proper data',
        () async {
          //arrange
          //act
          final result = tNumberTriviaModel.toMap();
          //assert
          final expectedJsonMap = {
            "text": "Test Text",
            "number": 1,
          };
          expect(result, expectedJsonMap);
        },
      );
    },
  );
}
