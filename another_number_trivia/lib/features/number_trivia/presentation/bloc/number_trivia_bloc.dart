import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/util/input_converter.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concreate_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String invalidInputFailureMessage =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreateNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(NumberTriviaEmpty()) {
    on<GetTriviaForConcreateNumber>((event, emit) async {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);
      await inputEither.fold((failure) {
        emit(const NumberTriviaError(message: invalidInputFailureMessage));
      }, (integer) async {
        emit(NumberTriviaLoading());
        final failureOrTrivia =
            await getConcreteNumberTrivia(Params(number: integer));
        _eitherLoadedOrErrorState(emit, failureOrTrivia);
      });
    });

    on<GetTriviaForRandomNumber>((event, emit) async {
      emit(NumberTriviaLoading());
      final failureOrTrivia = await getRandomNumberTrivia(NoParams());
      _eitherLoadedOrErrorState(emit, failureOrTrivia);
    });
  }

  void _eitherLoadedOrErrorState(Emitter<NumberTriviaState> emit,
      Either<Failure, NumberTrivia> failureOrTrivia) {
    failureOrTrivia.fold(
        (failure) =>
            emit(NumberTriviaError(message: _mapFailureToMessage(failure))),
        (trivia) => emit(NumberTriviaLoaded(trivia: trivia)));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return 'Unexpected error';
    }
  }
}
