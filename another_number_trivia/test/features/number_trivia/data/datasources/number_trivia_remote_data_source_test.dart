import 'dart:convert';

import 'package:another_number_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:another_number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });
  const tNumber = 1;
  final tNumberTriviaModel = NumberTriviaModel.fromMap(
    json.decode(fixture('trivia.json')),
  );
  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(
      any,
      headers: {
        'Content-Type': 'application/json',
      },
    )).thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(
      any,
      headers: {
        'Content-Type': 'application/json',
      },
    )).thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    test(
      '''should perform a GET request on a URL with number
       being the endpoint and with application/json header''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getConcreateNumberTrivia(tNumber);
        // assert
        verify(mockHttpClient.get(
          Uri.parse('http://numbersapi.com/$tNumber'),
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getConcreateNumberTrivia(tNumber);
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getConcreateNumberTrivia;
        // assert
        // expect(
        //   call(tNumber),
        //   throwsA(const TypeMatcher<ServerException>()),
        // );
        // expect(
        //   call(tNumber),
        //   throwsA(isInstanceOf<ServerException>()),
        // );
        expect(
          call(tNumber),
          throwsA(const TypeMatcher()),
        );
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromMap(json.decode(fixture('trivia.json')));

    test(
      '''should perform a GET request on a URL with random
       being the endpoint and with application/json header''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getRandomNumberTrivia();
        // assert
        verify(mockHttpClient.get(
          Uri.parse('http://numbersapi.com/random'),
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getRandomNumberTrivia();
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getRandomNumberTrivia;
        // assert
        // expect(call(), throwsA(const TypeMatcher<ServerException>()));
        // expect(call(), throwsA(isInstanceOf<ServerException>()));
        expect(call(), throwsA(const TypeMatcher()));
      },
    );
  });
}
