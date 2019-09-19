import 'dart:convert' as convert;

import 'package:carros/pages/carro/carro.dart';
import 'package:carros/pages/login/usuario.dart';
import 'package:http/http.dart' as http;

class TipoCarro {
  static final String classicos = "classicos";
  static final String esportivos = "esportivos";
  static final String luxo = "luxo";
}

class CarrosApi {
//  static Future<List<Carro>> getCarros() async {
//    final carros = List<Carro>();
//
//    await Future.delayed(Duration(seconds: 2));
//
//    return carros;
//  }

//  static Future<List<Carro>> getCarros(String tipo) async {
//    try {
//      //String s = tipo.toString().replaceAll("TipoCarro.", "");
//
//      var url =
//          "http://carros-springboot.herokuapp.com/api/v1/carros/tipo/$tipo";
//
//      print("GET >> $url");
//
//      var response = await http.get(url);
//
//      String json = response.body;
//
//      print(json);
//
//      List list = convert.json.decode(json);
//
////      final carros = List<Carro>();
//
////      for (Map map in list) {
////        Carro c = Carro.fromJson(map);
////        carros.add(c);
////      }
//
//      final carros = list.map<Carro>((map) => Carro.fromJson(map)).toList();
//
//      return carros;
//    } catch (error, exception) {
//      print(error);
//    }
//  }

//  static Future<List<Carro>> getCarros(String tipo) async {
//
//    var url = "http://carros-springboot.herokuapp.com/api/v1/carros/tipo/$tipo";
//
//    print("GET >> $url");
//
//    var response = await http.get(url);
//
//    String json = response.body;
//
//    print(json);
//
//    List list = convert.json.decode(json);
//
//    List<Carro> carros = list.map<Carro>((map) => Carro.fromJson(map)).toList();
//
//    return carros;
//  }

  static Future<List<Carro>> getCarros(String tipo) async {
    Usuario user = await Usuario.get();

    Map<String, String> headers = {
      "Context-Type": "application/json",
      "Authorization": "Bearer ${user.token}",
    };

    print(headers);

    var url = "http://carros-springboot.herokuapp.com/api/v2/carros/tipo/$tipo";

    print("GET >> $url");

    var response = await http.get(url, headers: headers);

    String json = response.body;
    //print("Status Code: ${response.statusCode}");
    //print(json);

//    try {
////      List list = convert.json.decode(json);
////
////      List<Carro> carros =
////          list.map<Carro>((map) => Carro.fromJson(map)).toList();
////
////      return carros;
////    } catch (error, exception) {
////      print("$error > $exception");
////      throw error;
////    }

    List list = convert.json.decode(json);

    List<Carro> carros = list.map<Carro>((map) => Carro.fromJson(map)).toList();

    return carros;
  }
}
