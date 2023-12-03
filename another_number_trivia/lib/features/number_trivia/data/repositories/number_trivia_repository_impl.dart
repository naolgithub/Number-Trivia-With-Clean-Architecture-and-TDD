import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivia_repository.dart';
import '../datasources/number_trivia_local_data_source.dart';
import '../datasources/number_trivia_remote_data_source.dart';
import '../models/number_trivia_model.dart';

// class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
//   final NumberTriviaRemoteDataSource remoteDataSource;
//   final NumberTriviaLocalDataSource localDataSource;
//   final NetworkInfo networkInfo;

//   NumberTriviaRepositoryImpl({
//     required this.remoteDataSource,
//     required this.localDataSource,
//     required this.networkInfo,
//   });

//   @override
//   Future<Either<Failure, NumberTrivia>> getConcreateNumberTrivia(
//       int number) async {
//     if (await networkInfo.isConnected) {
//       try {
//         final remoteTrivia =
//             await remoteDataSource.getConcreateNumberTrivia(number);
//         await localDataSource.cacheNumberTrivia(remoteTrivia);
//         return Right(remoteTrivia);
//       } on ServerException {
//         return Left(ServerFailure());
//       }
//     } else {
//       try {
//         final localTrivia = await localDataSource.getLastNumberTrivia();
//         return Right(localTrivia);
//       } on CacheException {
//         return Left(CacheFailure());
//       }
//     }
//   }

//   @override
//   Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
//     if (await networkInfo.isConnected) {
//       try {
//         final remoteTrivia = await remoteDataSource.getRandomNumberTrivia();
//         localDataSource.cacheNumberTrivia(remoteTrivia);
//         return Right(remoteTrivia);
//       } on ServerException {
//         return Left(ServerFailure());
//       }
//     } else {
//       try {
//         final localTrivia = await localDataSource.getLastNumberTrivia();
//         return Right(localTrivia);
//       } on CacheException {
//         return Left(CacheFailure());
//       }
//     }
//   }
// }

typedef _ConcreteOrRandomChooser = Future<NumberTrivia> Function();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreateNumberTrivia(
    int number,
  ) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreateNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
    _ConcreteOrRandomChooser getConcreteOrRandom,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia as NumberTriviaModel);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
