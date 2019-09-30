import 'package:cached_network_image/cached_network_image.dart';
import 'package:carros/pages/carros/carro-form-page.dart';
import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carros_api.dart';
import 'package:carros/pages/carros/loripsum_api.dart';
import 'package:carros/pages/carros/mapa_page.dart';
import 'package:carros/pages/carros/video_app.dart';
import 'package:carros/pages/favoritos/favorito_service.dart';
import 'package:carros/pages/login/api_response.dart';
import 'package:carros/utils/alert_dialog.dart';
import 'package:carros/utils/event_bus.dart';
import 'package:carros/utils/navigator.dart';
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

  Color color = Colors.grey;

  Carro get carro => widget.carro;

  @override
  void initState() {
    super.initState();
    _loripsumBloc.fetch();

//    FavoritoService.isFavorito(carro).then((bool favorito) {
//      setState(() {
//        color = favorito ? Colors.red : Colors.grey;
//      });
//    });

    final service = FavoritoService();
    service.isFavorito2(carro).then((b) {
      color = b ? Colors.red : Colors.grey;
    });
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
        title: Text("${widget.carro.nome} - ${widget.carro.id}"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.place),
            onPressed: () => _onClickMapa(context),
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
        CachedNetworkImage(
            imageUrl: widget.carro.urlFoto ??
                "http://www.livroandroid.com.br/livro/carros/classicos/Chevrolet_BelAir.png"),
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
                  color: color,
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

  void _onClickMapa(context) {
    if (carro.latitude != null && carro.longitude != null) {
      push(
          context,
          MapaPage(
            carro: carro,
          ));
    } else {
      alert(context, "Erro", "Esse carro nao possui");
    }
  }

  void _onClickVideo() {
    if (carro.urlVideo != null && carro.urlVideo.isNotEmpty) {
      //launch(carro.urlVideo);
      //VideoPage(carro: carro);
//      push(
//          context,
//          VideoPage(
//            carro: carro,
//          ));
      push(context, VideoApp());
    } else {
      alert(context, "Erro", "Este carro nao possui nenhum video");
    }
  }

  _onClickPopupMenu(String value) {
    switch (value) {
      case "Editar":
        print("Editar");
        push(context, CarroFormPage(carro: carro));
        break;
      case "Deletar":
        _deletar();
        print("Deletar");
        break;
      case "Share":
        print("Share");
        break;
      default:
        print("Nenhuma opcao");
    }
  }

  void _onClickFavorito() async {
//    bool favorito = await FavoritoService.Favoritar(carro, context);
//
//    setState(() {
//      color = favorito ? Colors.red : Colors.grey;
//    });
    final service = FavoritoService();
    final exists = await service.favoritar2(carro);

    setState(() {
      color = exists ? Colors.red : Colors.grey;
    });
  }

  void _onClickShare() {}

  void _deletar() async {
    ApiResponse<bool> response = await CarrosApi.delete(carro);

    if (response.ok) {
      alert(context, "Sucesso", "Carro deletado com sucesso", callback: () {
        EventBus.get(context)
            .sendEvent(CarroEvent("Carro Deletado", carro.tipo));
        pop(context);
      });
    } else {
      alert(context, "Erro", response.msg);
    }
  }
}
