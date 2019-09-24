import 'package:cached_network_image/cached_network_image.dart';
import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carro_page.dart';
import 'package:carros/utils/navigator.dart';
import 'package:flutter/material.dart';

class CarrosListView extends StatelessWidget {
  List<Carro> carros;

  CarrosListView(this.carros);

  @override
  Widget build(BuildContext context) {
    // Parte 1
    //Future<List<Carro>> future = CarrosApi.getCarros(widget.tipo);

    //return _listView(carros);
//
//    return Container(
//      child: Center(
//        child: Text(
//          "Ricardo",
//          style: TextStyle(
//            fontSize: 22,
//          ),
//        ),
//      ),
//    );

//    return FutureBuilder(
//      future: future,
//      builder: (context, snapshot) {
//        if (!snapshot.hasData) {
//          return Center(
//            child: CircularProgressIndicator(),
//          );
//        }
//        if (snapshot.hasError) {
//          print(snapshot.hasError);
//          return Center(
//              child: Text(
//            "Nao foi possivel buscar os carros",
//            style: TextStyle(
//              color: Colors.red,
//              fontSize: 22,
//            ),
//          ));
//        }
//
//        List<Carro> carros = snapshot.data;
//        return _listView(carros);
//      },
//    );

    // Parte 2
//    if (carros == null) {
//      return Center(
//        child: CircularProgressIndicator(),
//      );
//    }
//    return _listView(carros);

    // Parte 3
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
                  CachedNetworkImage(
                    imageUrl: c.urlFoto ??
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
                          onPressed: () => _onClickCarro(context, c),
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

//        return Row(
//          children: <Widget>[
//            Image.network(
//              c.urlFoto,
//              width: 150,
//            ),
//            Flexible(
//              child: Text(
//                c.nome,
//                maxLines: 1,
//                overflow: TextOverflow.ellipsis,
//                style: TextStyle(
//                  fontSize: 25,
//                ),
//              ),
//            ),
//          ],
//        );

//        return ListTile(
//          leading: Image.network(c.urlFoto),
//          title: Text(
//            c.nome,
//            style: TextStyle(
//              fontSize: 22,
//            ),
//          ),
//        );
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  _onClickCarro(BuildContext context, Carro c) {
    push(context, CarroPage(c));
  }
}
