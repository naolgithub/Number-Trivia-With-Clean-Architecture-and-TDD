import 'package:another_number_trivia/core/usecases/usecase.dart';
import 'package:another_number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:another_number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetRandomNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(
      repository: mockNumberTriviaRepository,
    );
  });

  const tNumberTrivia = NumberTrivia(
    text: 'test',
    number: 1,
  );
  test(
    'should get trivia for the number from the repository',
    () async {
      //arrange
      when(mockNumberTriviaRepository.getRandomNumberTrivia())
          .thenAnswer((_) async => const Right(tNumberTrivia));
      //act
      // final result = await usecase.execute(tNumber);
      //or
      //  final result = await usecase.call(tNumber);
      //or
      final result = await usecase(NoParams());
      //assert
      expect(result, const Right(tNumberTrivia));
      verify(mockNumberTriviaRepository.getRandomNumberTrivia());
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
