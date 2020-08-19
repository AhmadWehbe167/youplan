import 'package:data_connection_checker/data_connection_checker.dart';

Future<bool> checkConnection() async {
  return await DataConnectionChecker().hasConnection;
}
