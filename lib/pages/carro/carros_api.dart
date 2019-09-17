import 'dart:convert' as convert;

import 'package:carros/pages/carro/carro.dart';
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

  static Future<List<Carro>> getCarros(String tipo) async {
    try {
      //String s = tipo.toString().replaceAll("TipoCarro.", "");

      var url =
          "http://carros-springboot.herokuapp.com/api/v1/carros/tipo/$tipo";

      print("GET >> $url");

      var response = await http.get(url);

      String json = response.body;

      print(json);

      List list = convert.json.decode(json);

//      final carros = List<Carro>();

//      for (Map map in list) {
//        Carro c = Carro.fromJson(map);
//        carros.add(c);
//      }

      final carros = list.map<Carro>((map) => Carro.fromJson(map)).toList();

      return carros;
    } catch (error, exception) {
      print(error);
    }
  }
}
