import 'package:connectivity/connectivity.dart';

Future<bool> isNetworkOn() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    print("Eu");
    return false;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    print("Eu2");
    // I am connected to a wifi network.
    return true;
  }
}
