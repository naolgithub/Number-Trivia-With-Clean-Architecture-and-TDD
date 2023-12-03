// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:number_trivia_with_clean_architecture_and_tdd/core/error/failures.dart';
// import 'package:number_trivia_with_clean_architecture_and_tdd/core/presentation/util/input_converter.dart';
// import 'package:number_trivia_with_clean_architecture_and_tdd/features/number_trivia/domain/entities/number_trivia.dart';
// import 'package:number_trivia_with_clean_architecture_and_tdd/features/number_trivia/domain/usecases/get_concreate_number_trivia.dart';
// import 'package:number_trivia_with_clean_architecture_and_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
// import 'package:number_trivia_with_clean_architecture_and_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

// class MockGetConcreateNumberTrivia extends Mock
//     implements GetConcreateNumberTrivia {}

// class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

// class MockInputConverter extends Mock implements InputConverter {}

// class MockParams extends Fake implements Params {}

// void main() {
//   late NumberTriviaBloc bloc;
//   late MockGetConcreateNumberTrivia mockGetConcreateNumberTrivia;
//   late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
//   late MockInputConverter mockInputConverter;
//   setUpAll(
//     () {
//       registerFallbackValue(MockParams());
//     },
//   );
//   setUp(
//     () {
//       mockGetConcreateNumberTrivia = MockGetConcreateNumberTrivia();
//       mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
//       mockInputConverter = MockInputConverter();
//       bloc = NumberTriviaBloc(
//         getConcreateNumberTrivia: mockGetConcreateNumberTrivia,
//         getRandomNumberTrivia: mockGetRandomNumberTrivia,
//         inputConverter: mockInputConverter,
//       );
//     },
//   );
//   test(
//     'initialState should be Empty',
//     () async {
//       expect(bloc.initialState, equals(Empty()));
//     },
//   );
//   group(
//     'getTriviaForConcreateNumber',
//     () {
//       // The event takes in a String
//       const tNumberString = '1';
//       // This is the successful output of the InputConverter
//       final tNumberParsed = int.parse(tNumberString);
//       // NumberTrivia instance is needed too, of course
//       const tNumberTrivia = NumberTrivia(
//         number: 1,
//         text: 'test trivia',
//       );
//       void setUpMockInputConverterSuccess() =>
//           when(() => mockInputConverter.stringToUnsignedInteger(any()))
//               .thenReturn(Right(tNumberParsed));
//       test(
//         'should call the InputConverter to validate and convert the string to an unsigned integer',
//         () async {
//           // arrange
//           setUpMockInputConverterSuccess();
//           // act
//           bloc.add(const GetTriviaForConcreateNumber(
//             numberString: tNumberString,
//           ));

//           await untilCalled(
//             () => mockInputConverter.stringToUnsignedInteger(any()),
//           );
//           // assert
//           verify(
//               () => mockInputConverter.stringToUnsignedInteger(tNumberString));
//         },
//       );
//       test(
//         'should emit [Error] when the input is invalid',
//         () async* {
//           // arrange
//           when(() => mockInputConverter.stringToUnsignedInteger(any()))
//               .thenReturn(Left(InvalidInputFailure()));
//           // assert later
//           final expected = [
//             // The initial state is always emitted first
//             Empty(),
//             const Error(message: INVALID_INPUT_FAILURE_MESSAGE),
//           ];
//           // expectLater(bloc.state, emitsInOrder(expected));
//           expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));

//           // act
//           bloc.add(const GetTriviaForConcreateNumber(
//             numberString: tNumberString,
//           ));
//         },
//       );
//       test(
//         'should get data from the concrete use case',
//         () async {
//           // arrange
//           setUpMockInputConverterSuccess();
//           when(() => mockGetConcreateNumberTrivia(any()))
//               .thenAnswer((_) async => const Right(tNumberTrivia));
//           // act
//           bloc.add(const GetTriviaForConcreateNumber(
//             numberString: tNumberString,
//           ));
//           await untilCalled(() => mockGetConcreateNumberTrivia(any()));
//           // assert
//           verify(() =>
//               mockGetConcreateNumberTrivia(Params(number: tNumberParsed)));
//         },
//       );

//       test(
//         'should emit [Loading, Loaded] when data is gotten successfully',
//         () async {
//           // arrange
//           setUpMockInputConverterSuccess();
//           when(() => mockGetConcreateNumberTrivia(any()))
//               .thenAnswer((_) async => const Right(tNumberTrivia));
//           // assert later
//           final expected = [
//             Empty(),
//             Loading(),
//             const Loaded(trivia: tNumberTrivia),
//           ];

//           expectLater(bloc.state, emitsInOrder(expected));
//           // expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));

//           // act
//           bloc.add(
//             const GetTriviaForConcreateNumber(numberString: tNumberString),
//           );
//         },
//       );
//       test(
//         'should emit [Loading, Error] when getting data fails',
//         () async {
//           // arrange
//           setUpMockInputConverterSuccess();
//           when(() => mockGetConcreateNumberTrivia(any()))
//               .thenAnswer((_) async => Left(ServerFailure()));
//           // assert later
//           final expected = [
//             Empty(),
//             Loading(),
//             const Error(message: SERVER_FAILURE_MESSAGE),
//           ];
//           expectLater(bloc.state, emitsInOrder(expected));
//           // act
//           bloc.add(
//               const GetTriviaForConcreateNumber(numberString: tNumberString));
//         },
//       );

//       test(
//         'should emit [Loading, Error] with a proper message for the error when getting data fails',
//         () async {
//           // arrange
//           setUpMockInputConverterSuccess();
//           when(() => mockGetConcreateNumberTrivia(any()))
//               .thenAnswer((_) async => Left(CacheFailure()));
//           // assert later
//           final expected = [
//             Empty(),
//             Loading(),
//             const Error(message: CACHE_FAILURE_MESSAGE),
//           ];
//           expectLater(bloc.state, emitsInOrder(expected));
//           // act
//           bloc.add(
//               const GetTriviaForConcreateNumber(numberString: tNumberString));
//         },
//       );
//     },
//   );
// }
