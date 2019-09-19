import 'dart:async';

import 'package:carros/pages/carro/carro.dart';
import 'package:carros/pages/carro/carros_api.dart';

class CarrosBloc {
  final _streamController = StreamController<List<Carro>>();

  Stream<List<Carro>> get stream => _streamController.stream;

  loadCarros(String tipo) async {
    try {
      List<Carro> carros = await CarrosApi.getCarros(tipo);

      _streamController.add(carros);
    } catch (e) {
      print(e);
      print("asda");
      _streamController.addError(e);
    }
  }

//  fetch(String tipo) async {
//    List<Carro> carros = await CarrosApi.getCarros(tipo);
//    var _streamController;
//    _streamController.add(carros);
//  }

  Future<List<Carro>> fetch(String tipo) async {
    try {
      List<Carro> carros = await CarrosApi.getCarros(tipo);

      _streamController.add(carros);
    } catch (e) {
      print(e);
      print("asda");
      _streamController.addError(e);
    }
  }

  void dispose() {
    _streamController.close();
  }
}
