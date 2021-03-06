import 'dart:async';

import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carro_page.dart';
import 'package:carros/pages/carros/carros_listview.dart';
import 'package:carros/pages/favoritos/favorito_service.dart';
import 'package:carros/pages/favoritos/favoritos_model.dart';
import 'package:carros/utils/navigator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritosPage extends StatefulWidget {
  @override
  _FavoritosPageState createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage>
    with AutomaticKeepAliveClientMixin<FavoritosPage> {
  @override
  void dispose() {
    //favoritosBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //favoritosBloc.fetch();
//    FavoritosBloc favoritosBloc = Provider.of<FavoritosBloc>(context, listen: false);
    //favoritosBloc.fetch();

    FavoritosModel model = Provider.of<FavoritosModel>(context, listen: false);

    model.getCarros();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final service = FavoritoService();

    return Container(
      padding: EdgeInsets.all(12),
      child: StreamBuilder<QuerySnapshot>(
        //stream: Firestore.instance.collection('carros').snapshots(),
        stream: service.getCarros2(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            //Part1
//            List<Carro> carros = List<Carro>();
//            snapshot.data.documents.map((DocumentSnapshot document) {
//              Carro c = Carro.fromJson(document.data);
//              carros.add(c);
//            }).toList();
//            return CarrosListView(carros);

            List<Carro> carros = service.toList(snapshot);

            return CarrosListView(carros);
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Sem dados",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 26,
                    fontStyle: FontStyle.italic),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Container _listView(List<Carro> carros) {
    return Container(
      padding: EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: carros != null ? carros.length : 0,
        itemBuilder: (context, index) {
          Carro c = carros[index];

          return Card(
            color: Colors.grey[100],
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.network(
                    c.urlFoto ??
                        "http://www.livroandroid.com.br/livro/carros/classicos/Chevrolet_BelAir.png",
                    width: 250,
                  ),
                  Text(
                    c.nome ?? "N/D",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    "Descricao",
                    style: TextStyle(fontSize: 16.9),
                  ),
                  ButtonTheme.bar(
                    child: ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: Text("Detalhes"),
                          onPressed: () => _onClickCarro(c),
                        ),
                        FlatButton(
                          child: Text("Share"),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  _onClickCarro(Carro c) {
    push(context, CarroPage(c));
  }

  Future<void> _onRefresh() {
//    return Future.delayed(Duration(seconds: 3), () {
//      print("Fim");
//    });
    //return favoritosBloc.fetch();
    //return Provider.of<FavoritosBloc>(context, listen: false).fetch();
    return Provider.of<FavoritosModel>(context, listen: false).getCarros();
  }
}
