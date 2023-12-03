import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class InternetNetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker internetConnectionChecker;
  InternetNetworkInfoImpl({
    required this.internetConnectionChecker,
  });

  @override
  Future<bool> get isConnected => internetConnectionChecker.hasConnection;
}

class DataNetworkInfoImpl implements NetworkInfo {
  final DataConnectionChecker dataConnectionChecker;
  DataNetworkInfoImpl({
    required this.dataConnectionChecker,
  });

  @override
  Future<bool> get isConnected => dataConnectionChecker.hasConnection;
}
