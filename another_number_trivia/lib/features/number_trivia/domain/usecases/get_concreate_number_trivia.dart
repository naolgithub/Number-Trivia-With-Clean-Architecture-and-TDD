// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:another_number_trivia/core/error/failures.dart';
import 'package:another_number_trivia/core/usecases/usecase.dart';
import 'package:another_number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:another_number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetConcreateNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;
  GetConcreateNumberTrivia({
    required this.repository,
  });
  // Future<Either<Failure, NumberTrivia>> execute(int number) async {
  //   return await repository.getConcreateNumberTrivia(number);
  // }
  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreateNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;
  const Params({
    required this.number,
  });

  @override
  List<Object> get props => [number];
}
