part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

class NumberTriviaEmpty extends NumberTriviaState {}

class NumberTriviaLoading extends NumberTriviaState {}

class NumberTriviaLoaded extends NumberTriviaState {
  final NumberTrivia trivia;

  const NumberTriviaLoaded({
    required this.trivia,
  });
}

class NumberTriviaError extends NumberTriviaState {
  final String message;

  const NumberTriviaError({required this.message});
}
