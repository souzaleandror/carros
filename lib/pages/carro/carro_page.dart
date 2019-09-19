import 'package:carros/pages/carro/carro.dart';
import 'package:carros/pages/carro/loripsum_api.dart';
import 'package:carros/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CarroPage extends StatefulWidget {
  Carro carro;

  CarroPage(this.carro);

  @override
  _CarroPageState createState() => _CarroPageState();
}

class _CarroPageState extends State<CarroPage> {
  final _loripsumBloc = LoripsumBloc();

  @override
  void initState() {
    super.initState();
    _loripsumBloc.fetch();
  }

  @override
  void dispose() {
    _loripsumBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.carro.nome),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.place),
            onPressed: _onClickMapa,
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: _onClickVideo,
          ),
          PopupMenuButton<String>(
            onSelected: (String value) => _onClickPopupMenu(value),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: "Editar",
                  child: Text("Editar"),
                ),
                PopupMenuItem(
                  value: "Deletar",
                  child: Text("Deletar"),
                ),
                PopupMenuItem(
                  value: "Share",
                  child: Text("Share"),
                ),
              ];
            },
          ),
        ],
      ),
      body: _body(),
    );
  }

  _body() {
    return Container(
      padding: EdgeInsets.all(10),
      child: ListView(children: <Widget>[
        Image.network(widget.carro.urlFoto),
        _bloco1(),
        _bloco2(),
      ]),
    );
  }

  _bloco2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 16,
        ),
        text(widget.carro.descricao, fontSize: 16, bold: false),
        SizedBox(
          height: 16,
        ),
        // Parte 1
//        FutureBuilder<String>(
//          future: LoripsumApi.getLoripsum(),
//          builder: (context, snapshot) {
//            if (!snapshot.hasData) {
//              return Center(
//                child: CircularProgressIndicator(),
//              );
//            }
//
//            return text(snapshot.data, fontSize: 16);
//          },
//        ),
        //Parte 2
        StreamBuilder<String>(
          stream: _loripsumBloc.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return text(snapshot.data, fontSize: 16);
          },
        ),
      ],
    );
  }

  Row _bloco1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            text(widget.carro.nome, fontSize: 20, bold: true),
            text(widget.carro.tipo, fontSize: 20, bold: false),
          ],
        ),
        Row(
          children: <Widget>[
            IconButton(
                onPressed: _onClickFavorito,
                icon: Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 40,
                )),
            IconButton(
                onPressed: _onClickShare,
                icon: Icon(
                  Icons.share,
                  size: 40,
                ))
          ],
        ),
      ],
    );
  }

  void _onClickMapa() {}

  void _onClickVideo() {}

  _onClickPopupMenu(String value) {
    switch (value) {
      case "Editar":
        print("Editar");
        break;
      case "Deletar":
        print("Deletar");
        break;
      case "Share":
        print("Share");
        break;
      default:
        print("Nenhuma opcao");
    }
  }

  void _onClickFavorito() {}

  void _onClickShare() {}
}
