import 'dart:async';

import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carro_page.dart';
import 'package:carros/pages/carros/carros_listview.dart';
import 'package:carros/pages/favoritos/favoritos_model.dart';
import 'package:carros/utils/navigator.dart';
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

    //FavoritosBloc favoritosBloc = Provider.of<FavoritosBloc>(context);
    FavoritosModel model = Provider.of<FavoritosModel>(context);

    List<Carro> carros = model.carros;

    if (carros.isEmpty) {
      return Center(child: Text("Nenhuma carros nos favoritos"));
    }
    return RefreshIndicator(
        onRefresh: _onRefresh, child: CarrosListView(carros));

//    return StreamBuilder(
//        stream: model.stream,
//        builder: (context, snapshot) {
//          if (!snapshot.hasData) {
//            return Center(
//              child: CircularProgressIndicator(),
//            );
//          }
//          if (snapshot.hasError) {
//            print(snapshot.hasError);
//            return TextError("Nao foi possivel buscar os carros");
//          }
//          List<Carro> carros = snapshot.data;
//
////          return RefreshIndicator(
////              onRefresh: _onRefresh, child: _listView(carros));
//          print(carros.length);
//          return RefreshIndicator(
//              onRefresh: _onRefresh, child: CarrosListView(carros));
//        });
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
