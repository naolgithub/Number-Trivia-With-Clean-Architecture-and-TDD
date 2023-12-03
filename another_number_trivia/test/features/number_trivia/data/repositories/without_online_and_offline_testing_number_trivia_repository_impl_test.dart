// import 'package:another_number_trivia/core/platform/network_info.dart';
// import 'package:another_number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
// import 'package:another_number_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
// import 'package:another_number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';

// class MockRemoteDataSource extends Mock
//     implements NumberTriviaRemoteDataSource {}

// class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

// class MockNetworkInfo extends Mock implements NetworkInfo {}

import 'package:another_number_trivia/core/error/exceptions.dart';
import 'package:another_number_trivia/core/error/failures.dart';
import 'package:another_number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:another_number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:another_number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late NumberTriviaRepositoryImpl repository;
  // late MockRemoteDataSource mockRemoteDataSource;
  late MockNumberTriviaRemoteDataSource mockNumberTriviaRemoteDataSource;
//   late MockLocalDataSource mockLocalDataSource;
  late MockNumberTriviaLocalDataSource mockNumberTriviaLocalDataSource;
//   late MockNetworkInfo mockNetworkInfo;
  late MockNetworkInfo mockNetworkInfo;
//   setUp(
//     () {
//       mockRemoteDataSource = MockRemoteDataSource();
//       mockLocalDataSource = MockLocalDataSource();
//       mockNetworkInfo = MockNetworkInfo();
//       repository = NumberTriviaRepositoryImpl(
//         remoteDataSource: mockRemoteDataSource,
//         localDataSource: mockLocalDataSource,
//         networkInfo: mockNetworkInfo,
//       );
//     },
//   );
  setUp(
    () {
      mockNumberTriviaRemoteDataSource = MockNumberTriviaRemoteDataSource();
      mockNumberTriviaLocalDataSource = MockNumberTriviaLocalDataSource();
      mockNetworkInfo = MockNetworkInfo();
      repository = NumberTriviaRepositoryImpl(
        remoteDataSource: mockNumberTriviaRemoteDataSource,
        localDataSource: mockNumberTriviaLocalDataSource,
        networkInfo: mockNetworkInfo,
      );
    },
  );
  group(
    'getConcreteNumberTrivia',
    () {
      // DATA FOR THE MOCKS AND ASSERTIONS
      // We'll use these three variables throughout all the tests
      const tNumber = 1;
      const tNumberTriviaModel = NumberTriviaModel(
        number: tNumber,
        text: 'test trivia',
      );
      const NumberTrivia tNumberTrivia = tNumberTriviaModel;
      test(
        'should check if the device is online',
        () async {
          //arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          //act
          repository.getConcreateNumberTrivia(tNumber);
          //assert
          verify(mockNetworkInfo.isConnected);
        },
      );
      group(
        'device is online',
        () {
          // This setUp applies only to the 'device
          //is online' group
          setUp(() {
            when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          });
          test(
            'should return remote data when the call to remote data source is successful',
            () async {
              //arrange
              // when(mockNumberTriviaRemoteDataSource
              //         .getConcreateNumberTrivia(tNumber))
              //     .thenAnswer((_) async => tNumberTriviaModel);
              //OR
              when(mockNumberTriviaRemoteDataSource
                      .getConcreateNumberTrivia(any))
                  .thenAnswer((_) async => tNumberTriviaModel);
              //act
              final result = await repository.getConcreateNumberTrivia(tNumber);

              //assert
              verify(mockNumberTriviaRemoteDataSource
                  .getConcreateNumberTrivia(tNumber));
              expect(result, equals(const Right(tNumberTrivia)));
            },
          );
          test(
            'should cache the data locally when the call to remote data source is successful',
            () async {
              //arrange
              // when(mockNumberTriviaRemoteDataSource
              //         .getConcreateNumberTrivia(any))
              //     .thenAnswer((_) async => tNumberTriviaModel);
              //OR
              when(mockNumberTriviaRemoteDataSource
                      .getConcreateNumberTrivia(tNumber))
                  .thenAnswer((_) async => tNumberTriviaModel);

              //act
              await repository.getConcreateNumberTrivia(tNumber);
              //assert
              verify(
                mockNumberTriviaRemoteDataSource
                    .getConcreateNumberTrivia(tNumber),
              );
              verify(
                mockNumberTriviaLocalDataSource
                    .cacheNumberTrivia(tNumberTriviaModel),
              );
            },
          );
          test(
            'should return server failure when the call to remote data source is unsuccessful',
            () async {
              //arrange
              when(mockNumberTriviaRemoteDataSource
                      .getConcreateNumberTrivia(tNumber))
                  .thenThrow(ServerException());
              //act
              final result = await repository.getConcreateNumberTrivia(tNumber);
              //assert
              verify(
                mockNumberTriviaRemoteDataSource
                    .getConcreateNumberTrivia(tNumber),
              );
              verifyZeroInteractions(
                mockNumberTriviaLocalDataSource,
              );
              expect(result, equals(Left(ServerFailure())));
            },
          );
        },
      );
      group(
        'device is offline',
        () {
          setUp(() {
            when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
          });
          test(
            'should return last locally cached data when the cached data is present',
            () async {
              //arrange
              when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
                  .thenAnswer((_) async => tNumberTriviaModel);
              //act
              final result = await repository.getConcreateNumberTrivia(tNumber);
              //assert
              verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
              verify(
                mockNumberTriviaLocalDataSource.getLastNumberTrivia(),
              );
              expect(result, equals(const Right(tNumberTrivia)));
            },
          );

          test(
            'should return CacheFailure when there is no cached data present',
            () async {
              //arrange
              when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
                  .thenThrow(CacheException());
              //act
              final result = await repository.getConcreateNumberTrivia(tNumber);
              //assert
              verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
              verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
              expect(result, equals(Left(CacheFailure())));
            },
          );
        },
      );
    },
  );
  group(
    'getRandomNumberTrivia',
    () {
      // DATA FOR THE MOCKS AND ASSERTIONS

      // We'll use these two variables
      //throughout all the tests

      const tNumberTriviaModel = NumberTriviaModel(
        number: 123,
        text: 'test trivia',
      );
      const NumberTrivia tNumberTrivia = tNumberTriviaModel;
      test(
        'should check if the device is online',
        () async {
          //arrange

          //Stub for mockRemoteDataSource.getConcreteNumberTrivia
          // when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
          //     .thenAnswer((_) async => tNumberTriviaModel);

          //Stub for mockLocalDataSource.cacheNumberTrivia
          // when(mockNumberTriviaLocalDataSource
          //         .cacheNumberTrivia(tNumberTriviaModel))
          //     .thenAnswer((_) async => Future.value());

          //Stub for mockNetworkInfo.isConnected
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

          //act
          repository.getRandomNumberTrivia();
          //assert
          verify(mockNetworkInfo.isConnected);
        },
      );
      group(
        'device is online',
        () {
          // This setUp applies only to the 'device
          //is online' group
          setUp(() {
            when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          });
          test(
            'should return remote data when the call to remote data source is successful',
            () async {
              //arrange

              //Stub for mockRemoteDataSource.getConcreteNumberTrivia
              when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
                  .thenAnswer((_) async => tNumberTriviaModel);

              //Stub for mockLocalDataSource.cacheNumberTrivia
              // when(mockNumberTriviaLocalDataSource
              //         .cacheNumberTrivia(tNumberTriviaModel))
              //     .thenAnswer((_) async => Future.value());

              //act
              final result = await repository.getRandomNumberTrivia();

              //assert
              verify(
                mockNumberTriviaRemoteDataSource.getRandomNumberTrivia(),
              );
              expect(result, equals(const Right(tNumberTrivia)));
            },
          );
          test(
            'should cache the data locally when the call to remote data source is successful',
            () async {
              //arrange

              //Stub for mockRemoteDataSource.getConcreteNumberTrivia
              when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
                  .thenAnswer((_) async => tNumberTriviaModel);

              //Stub for mockLocalDataSource.cacheNumberTrivia
              // when(mockNumberTriviaLocalDataSource
              //         .cacheNumberTrivia(tNumberTriviaModel))
              //     .thenAnswer((_) async => Future.value());

              //act
              await repository.getRandomNumberTrivia();

              //assert
              verify(
                mockNumberTriviaRemoteDataSource.getRandomNumberTrivia(),
              );
              verify(
                mockNumberTriviaLocalDataSource
                    .cacheNumberTrivia(tNumberTriviaModel),
              );
            },
          );
          test(
            'should return server failure when the call to remote data source is unsuccessful',
            () async {
              //arrange
              when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
                  .thenThrow(ServerException());
              //act
              final result = await repository.getRandomNumberTrivia();
              //assert
              verify(
                mockNumberTriviaRemoteDataSource.getRandomNumberTrivia(),
              );
              //verifyNoMoreInteractions must only be given
              //a Mock object,not a call back mock function

              //AND THE FF WILL NOT WORK
              // verifyZeroInteractions(
              //   () => mockLocalDataSource,
              // );

              //AND THIS ONE WILL WORK
              verifyZeroInteractions(
                mockNumberTriviaLocalDataSource,
              );
              expect(result, equals(Left(ServerFailure())));
            },
          );
        },
      );
      group(
        'device is offline',
        () {
          setUp(() {
            when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
          });
          test(
            'should return last locally cached data when the cached data is present',
            () async {
              //arrange
              when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
                  .thenAnswer((_) async => tNumberTriviaModel);
              //act
              final result = await repository.getRandomNumberTrivia();
              //assert
              verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
              verify(
                mockNumberTriviaLocalDataSource.getLastNumberTrivia(),
              );
              expect(result, equals(const Right(tNumberTrivia)));
            },
          );
          test(
            'should return CacheFailure when there is no cached data present',
            () async {
              //arrange
              when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
                  .thenThrow(CacheException());
              //act
              final result = await repository.getRandomNumberTrivia();
              //assert
              verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
              verify(
                mockNumberTriviaLocalDataSource.getLastNumberTrivia(),
              );
              expect(result, equals(Left(CacheFailure())));
            },
          );
        },
      );
    },
  );
}
