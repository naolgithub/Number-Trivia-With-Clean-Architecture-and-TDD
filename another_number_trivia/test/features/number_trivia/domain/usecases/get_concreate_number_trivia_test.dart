import 'package:another_number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:another_number_trivia/features/number_trivia/domain/usecases/get_concreate_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetConcreateNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreateNumberTrivia(
      repository: mockNumberTriviaRepository,
    );
  });
  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(
    text: 'test',
    number: tNumber,
  );
  test(
    'should get trivia for the number from the repository',
    () async {
      //arrange
      when(mockNumberTriviaRepository.getConcreateNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      //act
      // final result = await usecase.execute(tNumber);
      //or
      //  final result = await usecase.call(tNumber);
      //or
      final result = await usecase(const Params(number: tNumber));
      //assert
      expect(result, const Right(tNumberTrivia));
      verify(mockNumberTriviaRepository.getConcreateNumberTrivia(tNumber));
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
