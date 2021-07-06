import 'package:connectivity/connectivity.dart';

class ConnectivityManager {

  static final get = ConnectivityManager._();

  final _connectivity = Connectivity();

  ConnectivityManager._();

  Future<bool> getConnectivityState() async {
    final connectivity = await _connectivity.checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }
}