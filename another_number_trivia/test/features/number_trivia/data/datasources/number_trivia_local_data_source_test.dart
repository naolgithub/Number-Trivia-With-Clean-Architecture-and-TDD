import 'dart:convert';

import 'package:another_number_trivia/core/error/exceptions.dart';
import 'package:another_number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:another_number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../helpers/test_helper.mocks.dart';

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
          when(mockSharedPreferences.getString(any))
              .thenReturn(fixture('trivia_cached.json'));
          //act
          final result = await dataSource.getLastNumberTrivia();
          //assert
          verify(
            mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA),
          );
          expect(result, equals(tNumberTriviaModel));
        },
      );
      test('should throw a CacheException when there is not a cached value',
          () {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        // Not calling the method here, just storing it inside a call variable
        final call = dataSource.getLastNumberTrivia;
        // assert
        // Calling the method happens from a higher-order function passed.
        // This is needed to test if calling a method throws an exception.

        expect(() => call(), throwsA(isInstanceOf<CacheException>()));
        //OR
        // expect(call, throwsA(const TypeMatcher()));
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
          //Because we really cannot test if the
          //sharedPreferences contain sth
          //we gonna remove arrange part
          //we only check whether shared preferences are called

          // act
          await dataSource.cacheNumberTrivia(tNumberTriviaModel);
          // assert
          final expectedJsonString = json.encode(tNumberTriviaModel.toMap());
          verify(
            mockSharedPreferences.setString(
                CACHED_NUMBER_TRIVIA, expectedJsonString),
          );
        },
      );
    },
  );
}
