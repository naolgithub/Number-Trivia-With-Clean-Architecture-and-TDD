import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia_with_clean_architecture_and_tdd/core/error/exceptions.dart';
import 'package:number_trivia_with_clean_architecture_and_tdd/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia_with_clean_architecture_and_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;
  setUp(
    () {
      mockSharedPreferences = MockSharedPreferences();
      dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences,
      );
    },
  );
  group(
    'getLastNumberTrivia',
    () {
      final tNumberTriviaModel = NumberTriviaModel.fromMap(
        json.decode(fixture('trivia_cached.json')),
      );
      test(
        'should return NumberTrivia from SharedPreferences when there is one in the cache',
        () async {
          //arrange
          when(() => mockSharedPreferences.getString(any()))
              .thenReturn(fixture('trivia_cached.json'));
          //act
          final result = await dataSource.getLastNumberTrivia();
          //assert
          verify(
            () => mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA),
          );
          expect(result, equals(tNumberTriviaModel));
        },
      );
      test('should throw a CacheException when there is not a cached value',
          () {
        // arrange
        when(() => mockSharedPreferences.getString(any())).thenReturn(null);
        // act
        // Not calling the method here, just storing it inside a call variable
        final call = dataSource.getLastNumberTrivia;
        // assert
        // Calling the method happens from a higher-order function passed.
        // This is needed to test if calling a method throws an exception.
        expect(() => call(), throwsA(isInstanceOf<CacheException>()));
      });
    },
  );

  group(
    'cacheNumberTrivia',
    () {
      const tNumberTriviaModel = NumberTriviaModel(
        number: 1,
        text: 'test trivia',
      );
      test(
        'should call SharedPreferences to cache the data',
        () async {
          //arrange
          when(() => dataSource.cacheNumberTrivia(tNumberTriviaModel))
              .thenAnswer((_) async => Future.value(true));
          // act
          await dataSource.cacheNumberTrivia(tNumberTriviaModel);
          // assert
          final expectedJsonString = json.encode(tNumberTriviaModel.toMap());

          verify(
            () => mockSharedPreferences.setString(
                CACHED_NUMBER_TRIVIA, expectedJsonString),
          );
        },
      );
    },
  );
}
