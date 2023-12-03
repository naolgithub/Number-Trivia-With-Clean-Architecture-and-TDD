part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();

  @override
  List<Object> get props => [];
}

class GetTriviaForConcreateNumber extends NumberTriviaEvent {
  final String numberString;

  const GetTriviaForConcreateNumber(this.numberString);
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {}
