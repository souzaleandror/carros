import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carro_dao.dart';
import 'package:carros/pages/favoritos/favorito.dart';
import 'package:carros/pages/favoritos/favorito_dao.dart';
import 'package:carros/pages/favoritos/favoritos_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class FavoritoService {
  static Future<bool> Favoritar(Carro c, BuildContext context) async {
    //Parte 1
//    Favorito f = Favorito();
//    f.id = c.id;
//    f.nome = c.nome;
    Favorito f = Favorito.fromCarro(c);

    final dao = FavoritoDAO();

    final exists = await dao.exists(c.id);

    if (exists) {
      dao.delete(c.id);

      //Provider.of<FavoritosBloc>(context, listen: false).fetch();
      Provider.of<FavoritosModel>(context, listen: false).getCarros();

      //favoritosBloc.fetch();

      return false;
    } else {
      dao.save(f);

      //favoritosBloc.fetch();
      //Provider.of<FavoritosBloc>(context, listen: false).fetch();
      Provider.of<FavoritosModel>(context, listen: false).getCarros();

      return true;
    }
  }

  static Future<List<Carro>> getCarros() async {
    List<Carro> carros = await CarroDAO()
        .query("select * from carro c, favorito f where c.id = f.id");

    return carros;
  }

  static Future<bool> isFavorito(Carro c) async {
    final dao = FavoritoDAO();

    final exists = await dao.exists(c.id);

    return exists;
  }
}
