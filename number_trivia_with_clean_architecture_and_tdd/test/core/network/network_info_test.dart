import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia_with_clean_architecture_and_tdd/core/network/network_info.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late DataNetworkInfoImpl dataNetworkInfoImpl;
  late InternetNetworkInfoImpl internetNetworkInfoImpl;
  late MockDataConnectionChecker mockDataConnectionChecker;
  late MockInternetConnectionChecker mockInternetConnectionChecker;
  setUp(
    () {
      mockDataConnectionChecker = MockDataConnectionChecker();
      mockInternetConnectionChecker = MockInternetConnectionChecker();
      dataNetworkInfoImpl = DataNetworkInfoImpl(
        dataConnectionChecker: mockDataConnectionChecker,
      );
      internetNetworkInfoImpl = InternetNetworkInfoImpl(
        internetConnectionChecker: mockInternetConnectionChecker,
      );
    },
  );
  //1st approach
  group(
    'unAwaiting isConnected',
    () {
      test(
        'should forward the call to DataConnectionChecker.hasConnection',
        () async {
          //arrange
          final tHasConnectionFuture = Future<bool>.value(true);
          when(() => mockDataConnectionChecker.hasConnection)
              .thenAnswer((_) async => tHasConnectionFuture);

          //act
          // NOTICE: We're NOT awaiting the result
          final unAwaitedResult = dataNetworkInfoImpl.isConnected;
          final awaitedResult = await dataNetworkInfoImpl.isConnected;
          //assert

          verify(
            () => mockDataConnectionChecker.hasConnection,
          );

          // Utilizing Dart's default referential equality.
          // Only references to the same object are equal.
          expect(unAwaitedResult, isA<Future<bool>>());
          expect(awaitedResult, isA<bool>());
        },
      );
      //or

      test(
        'should forward the call to InternetConnectionChecker.hasConnection',
        () async {
          //arrange
          final tHasConnectionFuture = Future<bool>.value(true);

          when(() => mockInternetConnectionChecker.hasConnection)
              .thenAnswer((_) async => tHasConnectionFuture);

          //act
          // NOTICE: We're NOT awaiting the result
          final unAwaitedResult = internetNetworkInfoImpl.isConnected;
          final awaitedResult = await internetNetworkInfoImpl.isConnected;
          //assert
          verify(
            () => mockInternetConnectionChecker.hasConnection,
          );

          // Utilizing Dart's default referential equality.
          // Only references to the same object are equal.
          expect(unAwaitedResult, isA<Future<bool>>());
          expect(awaitedResult, isA<bool>());
        },
      );
    },
  );

  //2nd approach
  group(
    'awaiting isConnected',
    () {
      group(
        'DataConnectionChecker',
        () {
          test(
            'should forward the call to DataConnectionChecker.hasConnection is successful',
            () async {
              //arrange
              when(() => mockDataConnectionChecker.hasConnection)
                  .thenAnswer((_) async => true);

              //act
              // NOTICE: We're  awaiting the result
              final awaitedResult = await dataNetworkInfoImpl.isConnected;
              //assert

              verify(
                () => mockDataConnectionChecker.hasConnection,
              );

              // Utilizing Dart's default referential equality.
              // Only references to the same object are equal.
              // expect(unAwaitedResult, isA<Future<bool>>());
              expect(awaitedResult, true);
            },
          );
          test(
            'should forward the call to DataConnectionChecker.hasConnection is unsuccessful',
            () async {
              //arrange
              when(() => mockDataConnectionChecker.hasConnection)
                  .thenAnswer((_) async => false);

              //act
              // NOTICE: We're awaiting the result
              final awaitedResult = await dataNetworkInfoImpl.isConnected;
              //assert

              verify(
                () => mockDataConnectionChecker.hasConnection,
              );

              // Utilizing Dart's default referential equality.
              // Only references to the same object are equal.
              // expect(unAwaitedResult, isA<Future<bool>>());
              expect(awaitedResult, false);
            },
          );
        },
      );

      group(
        'InternetConnectionChecker',
        () {
          test(
            'should forward the call to InternetConnectionChecker.hasConnection is successful',
            () async {
              //arrange
              when(() => mockInternetConnectionChecker.hasConnection)
                  .thenAnswer((_) async => true);

              //act
              // NOTICE: We're  awaiting the result
              final awaitedResult = await internetNetworkInfoImpl.isConnected;
              //assert

              verify(
                () => mockInternetConnectionChecker.hasConnection,
              );

              // Utilizing Dart's default referential equality.
              // Only references to the same object are equal.
              // expect(unAwaitedResult, isA<Future<bool>>());
              expect(awaitedResult, true);
            },
          );
          test(
            'should forward the call to InternetConnectionChecker.hasConnection is unsuccessful',
            () async {
              //arrange
              when(() => mockInternetConnectionChecker.hasConnection)
                  .thenAnswer((_) async => false);

              //act
              // NOTICE: We're awaiting the result
              final awaitedResult = await internetNetworkInfoImpl.isConnected;
              //assert

              verify(
                () => mockInternetConnectionChecker.hasConnection,
              );

              // Utilizing Dart's default referential equality.
              // Only references to the same object are equal.
              // expect(unAwaitedResult, isA<Future<bool>>());
              expect(awaitedResult, false);
            },
          );
        },
      );
    },
  );
}
