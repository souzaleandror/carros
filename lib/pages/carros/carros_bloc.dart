import 'dart:async';

import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carro_dao.dart';
import 'package:carros/pages/carros/carros_api.dart';
import 'package:carros/utils/network.dart';

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
      bool networkOn = await isNetworkOn();

      if (!networkOn) {
        print("opa");
        List<Carro> carros = await CarroDAO().findAllByTipo(tipo);
        _streamController.add(carros);
        return carros;
      }

      List<Carro> carros = await CarrosApi.getCarros(tipo);

      if (carros.isNotEmpty) {
        print("opa2");
        final dao = CarroDAO();

        //carros.forEach((c) => dao.save(c));

//    for(Carro c in carros){
//      dao.save(c);
//    }

        carros.forEach(dao.save);
      }

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
