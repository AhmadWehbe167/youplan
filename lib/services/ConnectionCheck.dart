import 'package:data_connection_checker/data_connection_checker.dart';

Future<bool> checkConnection() async {
  try {
    return await DataConnectionChecker().hasConnection;
  } catch (err) {
    return false;
  }
}
