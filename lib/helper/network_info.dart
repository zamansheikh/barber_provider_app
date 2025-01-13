import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkInfo {
  final Connectivity connectivity;
  NetworkInfo(this.connectivity);

  Future<bool> get isConnected async {
    List<ConnectivityResult> result = await connectivity.checkConnectivity();
    return result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.mobile);
  }

  static void checkConnectivity(GlobalKey<ScaffoldMessengerState> globalKey) {
    bool firstTime = true;
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) async {
      debugPrint("========> Check Network Info : $result");
      if (!firstTime) {
        bool isNotConnected = result.contains(ConnectivityResult.none);
        if (!isNotConnected) {
          globalKey.currentState?.hideCurrentSnackBar();
        }
        debugPrint("========> Check Network Toast $isNotConnected");
        globalKey.currentState?.showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? "No internet connection" : "Connected",
            textAlign: TextAlign.center,
          ),
        ));
      }

      firstTime = false;
    });
  }
}
