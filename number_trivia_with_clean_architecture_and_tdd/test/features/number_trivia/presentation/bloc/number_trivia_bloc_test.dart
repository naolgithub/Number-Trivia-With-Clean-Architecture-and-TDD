import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia_with_clean_architecture_and_tdd/core/error/failures.dart';
import 'package:number_trivia_with_clean_architecture_and_tdd/core/presentation/util/input_converter.dart';
import 'package:number_trivia_with_clean_architecture_and_tdd/core/usecases/usecase.dart';
import 'package:number_trivia_with_clean_architecture_and_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia_with_clean_architecture_and_tdd/features/number_trivia/domain/usecases/get_concreate_number_trivia.dart';
import 'package:number_trivia_with_clean_architecture_and_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia_with_clean_architecture_and_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreateNumberTrivia extends Mock
    implements GetConcreateNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

class MockParams extends Fake implements Params {}

class MockNoParams extends Fake implements NoParams {}

class MocknumberTriviaBloc
    extends MockBloc<NumberTriviaEvent, NumberTriviaState>
    implements NumberTriviaBloc {}

void main() {
  late NumberTriviaBloc numberTriviaBloc;
  late MockGetConcreateNumberTrivia mockGetConcreateNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;
  // late MockParams mockParams;
  setUpAll(
    () {
      registerFallbackValue(MockParams());
      registerFallbackValue(MockNoParams());
    },
  );
  setUp(
    () {
      mockGetConcreateNumberTrivia = MockGetConcreateNumberTrivia();
      mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
      mockInputConverter = MockInputConverter();
      // mockParams = MockParams();
      numberTriviaBloc = NumberTriviaBloc(
        inputConverter: mockInputConverter,
        getConcreteNumberTrivia: mockGetConcreateNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
      );
    },
  );
  const tNumber = 1;
  const tNumberString = '1';
  final tNumberParsed = int.parse(tNumberString);

  const tNumberTrivia = NumberTrivia(
    text: 'test trivia',
    number: 123,
  );
  test(
    'initial NumberTrivia state should be NumberTriviaEmpty',
    () {
      //assert
      expect(numberTriviaBloc.state, NumberTriviaEmpty());
    },
  );

  group(
    'getTriviaForConcreateNumber',
    () {
      // test(
      //   'should call the InputConverter to validate and convert the string to an unsigned integer',
      //   () async {
      //     // arrange
      //     when(() => mockInputConverter.stringToUnsignedInteger(any()))
      //         .thenReturn(Right(tNumberParsed));
      //     when(() => mockGetConcreateNumberTrivia
      //             .call(const Params(number: tNumber)))
      //         .thenAnswer((_) async => const Right(tNumberTrivia));
      //     // act
      //     numberTriviaBloc.add(const GetTriviaForConcreateNumber(
      //       tNumberString,
      //     ));
      //     final expected = [
      //       NumberTriviaLoading(),
      //       const NumberTriviaLoaded(trivia: tNumberTrivia),
      //     ];
      //     expectLater(numberTriviaBloc.stream, emitsInOrder(expected));
      //     await untilCalled(
      //       () => mockInputConverter.stringToUnsignedInteger(any()),
      //     );
      //     // assert
      //     verify(
      //         () => mockInputConverter.stringToUnsignedInteger(tNumberString));
      //   },
      // );

      //or using bloc_test

      blocTest<NumberTriviaBloc, NumberTriviaState>(
          'should call the InputConverter to validate and convert the string to an unsigned integer',
          build: () {
            when(() => mockInputConverter.stringToUnsignedInteger(any()))
                .thenReturn(Right(tNumberParsed));
            when(() => mockGetConcreateNumberTrivia
                    .call(const Params(number: tNumber)))
                .thenAnswer((_) async => const Right(tNumberTrivia));
            return numberTriviaBloc;
          },
          act: (bloc) async {
            bloc.add(const GetTriviaForConcreateNumber(tNumberString));
            await untilCalled(
              () => mockInputConverter.stringToUnsignedInteger(any()),
            );
          },
          wait: const Duration(milliseconds: 500),
          expect: () => [
                NumberTriviaLoading(),
                const NumberTriviaLoaded(trivia: tNumberTrivia),
              ],
          verify: (_) {
            verify(() =>
                mockInputConverter.stringToUnsignedInteger(tNumberString));
          });

      // test(
      //   'should emit [NumberTriviaLoadFailure/Error] when the input is invalid',
      //   () async {
      //     // arrange
      //     when(() => mockInputConverter.stringToUnsignedInteger(any()))
      //         .thenReturn(Left(InvalidInputFailure()));
      //     // assert later
      //     final expected = [
      //       const NumberTriviaError(message: invalidInputFailureMessage),
      //     ];
      //     expectLater(numberTriviaBloc.stream, emitsInOrder(expected));
      //     //OR
      //     expectLater(numberTriviaBloc.stream.asBroadcastStream(),
      //         emitsInOrder(expected));

      //     // act
      //     numberTriviaBloc.add(const GetTriviaForConcreateNumber(
      //       tNumberString,
      //     ));
      //   },
      // );
      //or using bloc_test
      blocTest<NumberTriviaBloc, NumberTriviaState>(
          'should emit [NumberTriviaError] when the input is invalid',
          build: () {
            when(() => mockInputConverter.stringToUnsignedInteger(any()))
                .thenReturn(Left(InvalidInputFailure()));
            // when(() => mockGetConcreateNumberTrivia
            //         .call(const Params(number: tNumber)))
            //     .thenAnswer((_) async => const Right(tNumberTrivia));
            return numberTriviaBloc;
          },
          act: (bloc) =>
              bloc.add(const GetTriviaForConcreateNumber(tNumberString)),
          wait: const Duration(milliseconds: 500),
          expect: () => [
                const NumberTriviaError(message: invalidInputFailureMessage),
              ]);
      test(
        'should get data from the concreate use case',
        () async {
          // arrange
          when(() => mockInputConverter.stringToUnsignedInteger(any()))
              .thenReturn(Right(tNumberParsed));
          when(() => mockGetConcreateNumberTrivia(any()))
              .thenAnswer((_) async => const Right(tNumberTrivia));
          // act
          numberTriviaBloc.add(const GetTriviaForConcreateNumber(
            tNumberString,
          ));
          await untilCalled(() => mockGetConcreateNumberTrivia(any()));
          // assert
          verify(() =>
              mockGetConcreateNumberTrivia(Params(number: tNumberParsed)));
        },
      );
      blocTest(
        'should get data from the concreate use case',
        build: () {
          when(() => mockInputConverter.stringToUnsignedInteger(any()))
              .thenReturn(Right(tNumberParsed));
          when(() => mockGetConcreateNumberTrivia(any()))
              .thenAnswer((_) async => const Right(tNumberTrivia));
          return numberTriviaBloc;
        },
        act: (bloc) => bloc.add(const GetTriviaForConcreateNumber(
          tNumberString,
        )),
        wait: const Duration(milliseconds: 500),
        verify: (_) async {
          await untilCalled(() => mockGetConcreateNumberTrivia(any()));
          verify(() =>
              mockGetConcreateNumberTrivia(Params(number: tNumberParsed)));
        },
      );

      test(
        'should emit [NumberTriviaLoading, NumberTriviaLoaded] when data is gotten successfully',
        () async {
          // arrange
          when(() => mockInputConverter.stringToUnsignedInteger(any()))
              .thenReturn(Right(tNumberParsed));
          when(() => mockGetConcreateNumberTrivia(any()))
              .thenAnswer((_) async => const Right(tNumberTrivia));
          // assert later
          final expected = [
            NumberTriviaLoading(),
            const NumberTriviaLoaded(trivia: tNumberTrivia),
          ];

          expectLater(numberTriviaBloc.stream, emitsInOrder(expected));
          // expectLater(numberTriviaBloc.stream.asBroadcastStream(),
          //     emitsInOrder(expected));

          // act
          numberTriviaBloc.add(
            const GetTriviaForConcreateNumber(tNumberString),
          );
        },
      );
//or using bloc_test
      blocTest<NumberTriviaBloc, NumberTriviaState>(
          'should emit [NumberTriviaLoading,NumberTriviaLoaded] when data is gotten successfuly',
          build: () {
            when(() => mockInputConverter.stringToUnsignedInteger(any()))
                .thenReturn(Right(tNumberParsed));
            when(() => mockGetConcreateNumberTrivia
                    .call(const Params(number: tNumber)))
                .thenAnswer((_) async => const Right(tNumberTrivia));
            return numberTriviaBloc;
          },
          act: (bloc) =>
              bloc.add(const GetTriviaForConcreateNumber(tNumberString)),
          wait: const Duration(milliseconds: 500),
          expect: () => [
                NumberTriviaLoading(),
                const NumberTriviaLoaded(trivia: tNumberTrivia),
              ]);

      test(
        'should emit [NumberTriviaLoading, NumberTriviaServerError] when getting data fails',
        () async {
          // arrange
          when(() => mockInputConverter.stringToUnsignedInteger(any()))
              .thenReturn(Right(tNumberParsed));
          when(() => mockGetConcreateNumberTrivia(any()))
              .thenAnswer((_) async => Left(ServerFailure()));
          // assert later
          final expected = [
            NumberTriviaLoading(),
            const NumberTriviaError(message: serverFailureMessage),
          ];
          expectLater(numberTriviaBloc.stream, emitsInOrder(expected));
          // act
          numberTriviaBloc
              .add(const GetTriviaForConcreateNumber(tNumberString));
        },
      );
      //or using bloc_test
      blocTest<NumberTriviaBloc, NumberTriviaState>(
          'should emit [NumberTriviaLoading,NumberTriviaServerError] when data is gotten unsuccessful',
          build: () {
            when(() => mockInputConverter.stringToUnsignedInteger(any()))
                .thenReturn(Right(tNumberParsed));
            when(() => mockGetConcreateNumberTrivia
                    .call(const Params(number: tNumber)))
                .thenAnswer((_) async => Left(ServerFailure()));
            return numberTriviaBloc;
          },
          act: (bloc) =>
              bloc.add(const GetTriviaForConcreateNumber(tNumberString)),
          wait: const Duration(milliseconds: 500),
          expect: () => [
                NumberTriviaLoading(),
                const NumberTriviaError(message: serverFailureMessage),
              ]);

      test(
        'should emit [NumberTriviaLoading, NumberTriviaCacheError] when getting data fails',
        () async {
          // arrange
          when(() => mockInputConverter.stringToUnsignedInteger(any()))
              .thenReturn(Right(tNumberParsed));
          when(() => mockGetConcreateNumberTrivia(any()))
              .thenAnswer((_) async => Left(CacheFailure()));
          // assert later
          final expected = [
            NumberTriviaLoading(),
            const NumberTriviaError(message: cacheFailureMessage),
          ];
          expectLater(numberTriviaBloc.stream, emitsInOrder(expected));
          // act
          numberTriviaBloc
              .add(const GetTriviaForConcreateNumber(tNumberString));
        },
      );
      //or using bloc_test
      blocTest<NumberTriviaBloc, NumberTriviaState>(
          'should emit [NumberTriviaLoading,NumberTriviaCacheError] when data is gotten unsuccessful',
          build: () {
            when(() => mockInputConverter.stringToUnsignedInteger(any()))
                .thenReturn(Right(tNumberParsed));
            when(() => mockGetConcreateNumberTrivia
                    .call(const Params(number: tNumber)))
                .thenAnswer((_) async => Left(CacheFailure()));
            return numberTriviaBloc;
          },
          act: (bloc) =>
              bloc.add(const GetTriviaForConcreateNumber(tNumberString)),
          wait: const Duration(milliseconds: 500),
          expect: () => [
                NumberTriviaLoading(),
                const NumberTriviaError(message: cacheFailureMessage),
              ]);
    },
  );
  group(
    'getTriviaForRandomNumber',
    () {
      test(
        'should get data from the random use case',
        () async {
          // arrange
          when(() => mockGetRandomNumberTrivia(any()))
              .thenAnswer((_) async => const Right(tNumberTrivia));
          // act
          numberTriviaBloc.add(GetTriviaForRandomNumber());
          await untilCalled(() => mockGetRandomNumberTrivia(any()));
          // assert
          verify(() => mockGetRandomNumberTrivia(any()));
        },
      );
      //or using bloc_test
      blocTest<NumberTriviaBloc, NumberTriviaState>(
          'should get data from the random use case', build: () {
        // arrange
        when(() => mockGetRandomNumberTrivia(any()))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        return numberTriviaBloc;
      }, act: (bloc) async {
        bloc.add(GetTriviaForRandomNumber());
      }, verify: (_) async {
        await untilCalled(() => mockGetRandomNumberTrivia(any()));
        verify(() => mockGetRandomNumberTrivia(any()));
      });

      test(
        'should emit [NumberTriviaLoading, NumberTriviaLoaded] when data is gotten successfully',
        () async {
          // arrange
          when(() => mockGetRandomNumberTrivia(any()))
              .thenAnswer((_) async => const Right(tNumberTrivia));
          // assert later
          final expected = [
            NumberTriviaLoading(),
            const NumberTriviaLoaded(trivia: tNumberTrivia),
          ];

          expectLater(numberTriviaBloc.stream, emitsInOrder(expected));
          // expectLater(numberTriviaBloc.stream.asBroadcastStream(),
          //     emitsInOrder(expected));

          // act
          numberTriviaBloc.add(
            GetTriviaForRandomNumber(),
          );
        },
      );
      //or using bloc_test
      blocTest<NumberTriviaBloc, NumberTriviaState>(
          'should emit [NumberTriviaLoading,NumberTriviaLoaded] when data is gotten successfuly',
          build: () {
            // when(() => mockGetRandomNumberTrivia(any()))
            //     .thenAnswer((_) async => const Right(tNumberTrivia));
            //or
            when(() => mockGetRandomNumberTrivia.call(any()))
                .thenAnswer((_) async => const Right(tNumberTrivia));
            return numberTriviaBloc;
          },
          act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
          wait: const Duration(milliseconds: 500),
          expect: () => [
                NumberTriviaLoading(),
                const NumberTriviaLoaded(trivia: tNumberTrivia),
              ]);

      test(
        'should emit [NumberTriviaLoading, NumberTriviaServerError] when getting data fails',
        () async {
          // arrange
          when(() => mockGetRandomNumberTrivia.call(any()))
              .thenAnswer((_) async => Left(ServerFailure()));
          // //or
          when(() => mockGetRandomNumberTrivia(any()))
              .thenAnswer((_) async => Left(ServerFailure()));
          // assert later
          final expected = [
            NumberTriviaLoading(),
            const NumberTriviaError(message: serverFailureMessage),
          ];
          expectLater(numberTriviaBloc.stream, emitsInOrder(expected));
          // act
          numberTriviaBloc.add(GetTriviaForRandomNumber());
        },
      );

      // or using bloc_test
      blocTest<NumberTriviaBloc, NumberTriviaState>(
          'should emit [NumberTriviaLoading,NumberTriviaServerError] when data is gotten unsuccessful',
          build: () {
            when(() => mockGetRandomNumberTrivia.call(any()))
                .thenAnswer((_) async => Left(ServerFailure()));
            return numberTriviaBloc;
          },
          act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
          wait: const Duration(milliseconds: 500),
          expect: () => [
                NumberTriviaLoading(),
                const NumberTriviaError(message: serverFailureMessage),
              ]);

      test(
        'should emit [NumberTriviaLoading, NumberTriviaCacheError] when getting data fails',
        () async {
          // arrange
          when(() => mockGetRandomNumberTrivia(any()))
              .thenAnswer((_) async => Left(CacheFailure()));
          // assert later
          final expected = [
            NumberTriviaLoading(),
            const NumberTriviaError(message: cacheFailureMessage),
          ];
          expectLater(numberTriviaBloc.stream, emitsInOrder(expected));
          // act
          numberTriviaBloc.add(GetTriviaForRandomNumber());
        },
      );
      //or using bloc_test
      blocTest<NumberTriviaBloc, NumberTriviaState>(
          'should emit [NumberTriviaLoading,NumberTriviaCacheError] when data is gotten unsuccessful',
          build: () {
            when(() => mockGetRandomNumberTrivia.call(any()))
                .thenAnswer((_) async => Left(CacheFailure()));
            return numberTriviaBloc;
          },
          act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
          wait: const Duration(milliseconds: 500),
          expect: () => [
                NumberTriviaLoading(),
                const NumberTriviaError(message: cacheFailureMessage),
              ]);
    },
  );
}
