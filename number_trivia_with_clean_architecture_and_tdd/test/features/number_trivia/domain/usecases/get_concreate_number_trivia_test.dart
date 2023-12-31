import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia_with_clean_architecture_and_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia_with_clean_architecture_and_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia_with_clean_architecture_and_tdd/features/number_trivia/domain/usecases/get_concreate_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

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
    number: tNumber,
    text: 'test',
  );
  test(
    'should get trivia for the number from the repository',
    () async {
      // "On the fly" implementation of the Repository using the Mockito package.
      // When getConcreteNumberTrivia is called with any argument, always answer with
      // the Right "side" of Either containing a test NumberTrivia object.
      when(() => mockNumberTriviaRepository.getConcreateNumberTrivia(any()))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // The "act" phase of the test. Call the not-yet-existent method.
      // final result = await usecase.execute(tNumber);
      //or
      // final result = await usecase.call(tNumber);
      //or
      final result = await usecase(const Params(number: tNumber));

      // UseCase should simply return whatever was returned from the Repository
      expect(result, const Right(tNumberTrivia));
      // Verify that the method has been called on the Repository
      verify(
          () => mockNumberTriviaRepository.getConcreateNumberTrivia(tNumber));
      // Only the above method should be called and nothing more.
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
