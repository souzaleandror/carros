import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carro_dao.dart';
import 'package:carros/pages/favoritos/favorito.dart';
import 'package:carros/pages/favoritos/favorito_dao.dart';

class FavoritoService {
  static Future<bool> Favoritar(Carro c) async {
    //Parte 1
//    Favorito f = Favorito();
//    f.id = c.id;
//    f.nome = c.nome;
    Favorito f = Favorito.fromCarro(c);

    final dao = FavoritoDAO();

    final exists = await dao.exists(c.id);

    if (exists) {
      dao.delete(c.id);

      return false;
    } else {
      dao.save(f);
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
