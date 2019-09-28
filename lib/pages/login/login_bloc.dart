import 'dart:async';

import 'package:carros/pages/login/api_response.dart';
import 'package:carros/pages/login/firebase_service.dart';
import 'package:carros/pages/login/usuario.dart';

class LoginBloc {
  final _streamController = StreamController<bool>();

  Stream<bool> get stream => _streamController.stream;

  Future<ApiResponse<Usuario>> login(String login, String password) async {
    _streamController.add(true);

    //ApiResponse response = await LoginApi.login(login, password);
    ApiResponse response = await FirebaseService().login(login, password);

    _streamController.add(false);

    return response;
  }

  void dispose() {
    _streamController.close();
  }
}
