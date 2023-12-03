import 'package:another_number_trivia/core/network/network_info.dart';
import 'package:another_number_trivia/core/presentation/util/input_converter.dart';
import 'package:another_number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:another_number_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:another_number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:another_number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:another_number_trivia/features/number_trivia/domain/usecases/get_concreate_number_trivia.dart';
import 'package:another_number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

// @GenerateMocks(
//   [
//     NumberTriviaRepository,
//     NumberTriviaRepositoryImpl,
//     GetConcreateNumberTrivia,
//     GetRandomNumberTrivia,
//     NumberTriviaRemoteDataSource,
//     NumberTriviaLocalDataSource,
//     NetworkInfo,
//     DataConnectionChecker,
//     InternetConnectionChecker,
//     SharedPreferences,
//     http.Client,
//     Fake,
//     Uri,
//     InputConverter,
//   ],
//   customMocks: [MockSpec<http.Client>(as: #MockHttpClient)],
// )
@GenerateNiceMocks(
  [
    MockSpec<NumberTriviaRepository>(),
    MockSpec<NumberTriviaRepositoryImpl>(),
    MockSpec<GetConcreateNumberTrivia>(),
    MockSpec<GetRandomNumberTrivia>(),
    MockSpec<NumberTriviaRemoteDataSource>(),
    MockSpec<NumberTriviaLocalDataSource>(),
    MockSpec<NetworkInfo>(),
    MockSpec<DataConnectionChecker>(),
    MockSpec<InternetConnectionChecker>(),
    MockSpec<SharedPreferences>(),
    MockSpec<http.Client>(),
    MockSpec<Fake>(),
    MockSpec<Uri>(),
    MockSpec<InputConverter>(),
    MockSpec<http.Client>(as: #MockHttpClient)
  ],
)
void main() {}
