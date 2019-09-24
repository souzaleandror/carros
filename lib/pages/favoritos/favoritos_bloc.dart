import 'dart:async';

import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/favoritos/favorito_service.dart';

class FavoritosBloc {
  final _streamController = StreamController<List<Carro>>();

  Stream<List<Carro>> get stream => _streamController.stream;

  Future<List<Carro>> fetch() async {
    try {
      List<Carro> carros = await FavoritoService.getCarros();

      _streamController.add(carros);
    } catch (e) {
      print(e);
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

  void dispose() {
    _streamController.close();
  }
}
