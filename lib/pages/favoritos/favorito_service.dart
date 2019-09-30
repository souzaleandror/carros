import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carro_dao.dart';
import 'package:carros/pages/favoritos/favorito.dart';
import 'package:carros/pages/favoritos/favorito_dao.dart';
import 'package:carros/pages/favoritos/favoritos_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class FavoritoService {
  getCarros2() => _carros.snapshots();

  get _carros => Firestore.instance.collection("carros");

  List<Carro> toList(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((document) => Carro.fromJson(document.data))
        .toList();
  }

  Future<bool> favoritar2(Carro carro) async {
    var document = _carros.document("${carro.id}");
    var documentSnapshot = await document.get();

    if (!documentSnapshot.exists) {
      print("${carro.nome}, adicionado nos favoritos");
      print("${carro.id}, adicionado nos favoritos");
      document.setData(carro.toMap());

      return true;
    } else {
      print("${carro.nome}, removido dos favoritos");
      document.delete();

      return false;
    }
  }

  Future<bool> isFavorito2(Carro c) async {
    var document = _carros.document("${c.id}");
    var documentSnapshot = await document.get();

    return documentSnapshot.exists;
  }

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
