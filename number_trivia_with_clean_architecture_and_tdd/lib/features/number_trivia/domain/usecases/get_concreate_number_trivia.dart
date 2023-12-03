// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia_with_clean_architecture_and_tdd/core/error/failures.dart';
import 'package:number_trivia_with_clean_architecture_and_tdd/core/usecases/usecase.dart';
import 'package:number_trivia_with_clean_architecture_and_tdd/features/number_trivia/domain/entities/number_trivia.dart';

import '../repositories/number_trivia_repository.dart';

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
