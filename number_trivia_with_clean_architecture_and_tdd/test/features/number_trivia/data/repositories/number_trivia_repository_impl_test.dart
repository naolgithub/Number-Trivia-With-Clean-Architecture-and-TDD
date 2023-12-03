import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia_with_clean_architecture_and_tdd/core/error/exceptions.dart';
import 'package:number_trivia_with_clean_architecture_and_tdd/core/error/failures.dart';
import 'package:number_trivia_with_clean_architecture_and_tdd/core/network/network_info.dart';
import 'package:number_trivia_with_clean_architecture_and_tdd/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia_with_clean_architecture_and_tdd/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia_with_clean_architecture_and_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia_with_clean_architecture_and_tdd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia_with_clean_architecture_and_tdd/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  setUp(
    () {
      mockRemoteDataSource = MockRemoteDataSource();
      mockLocalDataSource = MockLocalDataSource();
      mockNetworkInfo = MockNetworkInfo();
      repository = NumberTriviaRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo,
      );
    },
  );

  void runTestsOnline(Function body) {
    group('device is online', () {
      // This setUp applies only to the 'device
      //is online' group
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group(
    'getConcreateNumberTrivia',
    () {
      // DATA FOR THE MOCKS AND ASSERTIONS

      // We'll use these three variables
      //throughout all the tests
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
          //Stub for mockRemoteDataSource.getConcreteNumberTrivia
          when(() => mockRemoteDataSource.getConcreateNumberTrivia(any()))
              .thenAnswer((_) async => tNumberTriviaModel);
          //Stub for mockLocalDataSource.cacheNumberTrivia
          when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
              .thenAnswer((_) async => Future.value());
          //Stub for mockNetworkInfo.isConnected
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);

          //act
          repository.getConcreateNumberTrivia(tNumber);
          //assert
          verify(() => mockNetworkInfo.isConnected);
        },
      );

      runTestsOnline(() {
        test(
          'should return remote data when the call to remote data source is successful',
          () async {
            //arrange

            //Stub for mockRemoteDataSource.getConcreteNumberTrivia
            // when(() => mockRemoteDataSource.getConcreateNumberTrivia(tNumber))
            //     .thenAnswer((_) async => tNumberTriviaModel);
            //OR
            when(() => mockRemoteDataSource.getConcreateNumberTrivia(any()))
                .thenAnswer((_) async => tNumberTriviaModel);
            //Stub for mockLocalDataSource.cacheNumberTrivia
            when(() =>
                    mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
                .thenAnswer((_) async => Future.value());

            //act
            final result = await repository.getConcreateNumberTrivia(tNumber);

            //assert
            verify(
              () => mockRemoteDataSource.getConcreateNumberTrivia(tNumber),
            );
            expect(result, equals(const Right(tNumberTrivia)));
          },
        );
        test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
            //arrange

            //Stub for mockRemoteDataSource.getConcreteNumberTrivia
            // when(() => mockRemoteDataSource.getConcreateNumberTrivia(any()))
            //     .thenAnswer((_) async => tNumberTriviaModel);
            //or
            when(() => mockRemoteDataSource.getConcreateNumberTrivia(tNumber))
                .thenAnswer((_) async => tNumberTriviaModel);
            //Stub for mockLocalDataSource.cacheNumberTrivia
            when(() =>
                    mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
                .thenAnswer((_) async => Future.value());

            //act
            await repository.getConcreateNumberTrivia(tNumber);

            //assert
            verify(
              () => mockRemoteDataSource.getConcreateNumberTrivia(tNumber),
            );
            verify(
              () => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel),
            );
          },
        );
        test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
            //arrange
            when(() => mockRemoteDataSource.getConcreateNumberTrivia(tNumber))
                .thenThrow(ServerException());
            //act
            final result = await repository.getConcreateNumberTrivia(tNumber);
            //assert
            verify(
              () => mockRemoteDataSource.getConcreateNumberTrivia(tNumber),
            );
            //verifyNoMoreInteractions must only be given
            //a Mock object,not a call back mock function

            //AND THE FF WILL NOT WORK
            // verifyZeroInteractions(
            //   () => mockLocalDataSource,
            // );

            //AND THIS ONE WILL WORK
            verifyZeroInteractions(
              mockLocalDataSource,
            );
            expect(result, equals(Left(ServerFailure())));
          },
        );
      });

      runTestsOffline(() {
        test(
          'should return last locally cached data when the cached data is present',
          () async {
            //arrange
            when(() => mockLocalDataSource.getLastNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);
            //act
            final result = await repository.getConcreateNumberTrivia(tNumber);
            //assert
            verifyZeroInteractions(mockRemoteDataSource);
            verify(
              () => mockLocalDataSource.getLastNumberTrivia(),
            );
            expect(result, equals(const Right(tNumberTrivia)));
          },
        );
        test(
          'should return CacheFailure when there is no cached data present',
          () async {
            //arrange
            when(() => mockLocalDataSource.getLastNumberTrivia())
                .thenThrow(CacheException());
            //act
            final result = await repository.getConcreateNumberTrivia(tNumber);
            //assert
            verifyZeroInteractions(mockRemoteDataSource);
            verify(
              () => mockLocalDataSource.getLastNumberTrivia(),
            );
            expect(result, equals(Left(CacheFailure())));
          },
        );
      });
    },
  );

  group('getRandomNumberTrivia', () {
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
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //Stub for mockLocalDataSource.cacheNumberTrivia
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async => Future.value());
        //Stub for mockNetworkInfo.isConnected
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        //act
        repository.getRandomNumberTrivia();
        //assert
        verify(() => mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          //arrange

          //Stub for mockRemoteDataSource.getConcreteNumberTrivia
          when(() => mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          //Stub for mockLocalDataSource.cacheNumberTrivia
          when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
              .thenAnswer((_) async => Future.value());

          //act
          final result = await repository.getRandomNumberTrivia();

          //assert
          verify(
            () => mockRemoteDataSource.getRandomNumberTrivia(),
          );
          expect(result, equals(const Right(tNumberTrivia)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          //arrange

          //Stub for mockRemoteDataSource.getConcreteNumberTrivia
          when(() => mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          //Stub for mockLocalDataSource.cacheNumberTrivia
          when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
              .thenAnswer((_) async => Future.value());

          //act
          await repository.getRandomNumberTrivia();

          //assert
          verify(
            () => mockRemoteDataSource.getRandomNumberTrivia(),
          );
          verify(
            () => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel),
          );
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          //arrange
          when(() => mockRemoteDataSource.getRandomNumberTrivia())
              .thenThrow(ServerException());
          //act
          final result = await repository.getRandomNumberTrivia();
          //assert
          verify(
            () => mockRemoteDataSource.getRandomNumberTrivia(),
          );
          //verifyNoMoreInteractions must only be given
          //a Mock object,not a call back mock function

          //AND THE FF WILL NOT WORK
          // verifyZeroInteractions(
          //   () => mockLocalDataSource,
          // );

          //AND THIS ONE WILL WORK
          verifyZeroInteractions(
            mockLocalDataSource,
          );
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          //arrange
          when(() => mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          //act
          final result = await repository.getRandomNumberTrivia();
          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(
            () => mockLocalDataSource.getLastNumberTrivia(),
          );
          expect(result, equals(const Right(tNumberTrivia)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          //arrange
          when(() => mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          //act
          final result = await repository.getRandomNumberTrivia();
          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(
            () => mockLocalDataSource.getLastNumberTrivia(),
          );
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
