import 'dart:convert' as convert;
import 'dart:io';

import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/upload_api.dart';
import 'package:carros/pages/login/api_response.dart';
import 'package:carros/pages/login/usuario.dart';
import 'package:carros/utils/http_helper.dart' as http;
import 'package:carros/utils/network.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

class TipoCarro {
  static final String classicos = "classicos";
  static final String esportivos = "esportivos";
  static final String luxo = "luxo";
}

class CarrosApi {
  static bool FAKE = true;

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
//    Usuario user = await Usuario.get();
//
//    Map<String, String> headers = {
//      "Context-Type": "application/json",
//      "Authorization": "Bearer ${user.token}",
//    };
//
//    print(headers);

    var url = "http://carros-springboot.herokuapp.com/api/v2/carros/tipo/$tipo";

    print("GET >> $url");

    var response = await http.get(url);

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

  static Future<ApiResponse<bool>> save(Carro c, File file) async {
    try {
      if (file != null) {
        ApiResponse<String> response = await UploadApi.upload(file);
        if (response.ok) {
          String urlFoto = response.result;
          c.urlFoto = urlFoto;
        }
      }

      Usuario user = await Usuario.get();

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${user.token}"
      };

      var url = 'https://carros-springboot.herokuapp.com/api/v2/carros';

      if (c.id != null) {
        url += "/${c.id}";
      }

      print("POST > $url");

      String json = c.toJson();

      print("   JSON > $json");

      //var response = await http.post(url, body: json, headers: headers);

      var response = await (c.id == null
          ? http.post(url, body: json)
          : http.put(url, body: json));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map mapResponse = convert.json.decode(response.body);

        Carro carro = Carro.fromMap(mapResponse);

        print("Novo carro: ${carro.id}");

        return ApiResponse.ok(result: true);
      }

      if (response.body == null || response.body.isEmpty) {
        return ApiResponse.error(msg: "Nao foi possivel salvar o carro");
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {
      print(e);
      return ApiResponse.error(msg: "Nao foi possivel salvar o carro");
    }
  }

  static Future<ApiResponse<bool>> delete(Carro c) async {
    try {
      Usuario user = await Usuario.get();

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${user.token}"
      };

      var url = 'https://carros-springboot.herokuapp.com/api/v2/carros/${c.id}';

      print("DELETE > $url");

      String json = c.toJson();

      print("   JSON > $json");

      var response = await http.delete(url);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return ApiResponse.ok(result: true);
      }

      if (response.body == null || response.body.isEmpty) {
        return ApiResponse.error(msg: "Nao foi possivel deletar o carro");
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {
      print(e);
      return ApiResponse.error(msg: "Nao foi possivel deletar o carro");
    }
  }

  static Future<List<Carro>> getCarrosByTipo(String tipo) async {
    String json;

    if (FAKE) {
      json = await rootBundle.loadString("assets/fake/$tipo.json");
    } else {
      var connectivyResult = await isNetworkOn();

      if (connectivyResult == ConnectivityResult.none) {
        // get Banco de dados ou arquivo
      } else {
        //API
      }

      return null;
    }
  }

  static search(String query) async {
    List<Carro> carros = await getCarros("classiscos");

    List<Carro> list = [];

    for (Carro c in carros) {
      if (c.nome.toUpperCase().contains(query.toUpperCase())) {
        list.add(c);
      }
    }

    return list;
  }
}
