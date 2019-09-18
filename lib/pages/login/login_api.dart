import 'dart:convert';

import 'package:carros/pages/login/api_response.dart';
import 'package:carros/pages/login/usuario.dart';
import 'package:http/http.dart' as http;

class LoginApi {
//  static Future<bool> login(String login, String password) async {
//    var url = 'http://livrowebservices.com.br/rest/login';
//
//    Map params = {'login': login, 'password': password};
//
//    var response = await http.post(url, body: params);
//    print('Response status: ${response.statusCode}');
//    print('Response body: ${response.body}');
//
//    return true;
//  }

//  static Future<Usuario> login(String login, String password) async {
//    var url = 'https://carros-springboot.herokuapp.com/api/v2/login';
//
//    Map<String, String> headers = {"Context-Type": "application/json"};
//
//    Map params = {'username': login, 'password': password};
//
//    String s = json.encode(params);
//
//    var response = await http.post(url, body: s, headers: headers);
//    print('Response status: ${response.statusCode}');
//    print('Response body: ${response.body}');
//
//    Map mapResponse = json.decode(response.body);
//
////    String nome = mapResponse["nome"];
////    String email = mapResponse["email"];
////
////    print(nome);
////    print(email);
////
////    final user = Usuario.fromJson(mapResponse);
////
////    return user;
//
//    //return true;
//
//    if (response.statusCode == 200) {
//      final user = Usuario.fromJson(mapResponse);
//
//      return user;
//    }
//  }

  static Future<ApiResponse<Usuario>> login(
      String login, String password) async {
    try {
      var url = 'https://carros-springboot.herokuapp.com/api/v2/login';

      Map<String, String> headers = {"Context-Type": "application/json"};

      Map params = {'username': login, 'password': password};

      String s = json.encode(params);

      var response = await http.post(url, body: s, headers: headers);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      Map mapResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        final user = Usuario.fromJson(mapResponse);

        //Prefs.setString("user.prefs", response.body);
        user.save();

        Usuario user2 = await Usuario.get();
        print("Usuario2 = $user2");

        return ApiResponse.ok(user);
      }

      return ApiResponse.error(mapResponse["error"]);
    } catch (error, exception) {
      print("Erro no login: $error > $exception");
      return ApiResponse.error("Nao foi possivel fazer o login");
    }
  }
}
