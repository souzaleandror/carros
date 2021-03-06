import 'dart:async';

import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carro_page.dart';
import 'package:carros/pages/carros/carros_api.dart';
import 'package:carros/pages/carros/carros_bloc.dart';
import 'package:carros/pages/carros/carros_listview.dart';
import 'package:carros/utils/event_bus.dart';
import 'package:carros/utils/navigator.dart';
import 'package:carros/widgets/text_error.dart';
import 'package:flutter/material.dart';

class CarrosPage extends StatefulWidget {
  String tipo;

  CarrosPage(this.tipo);

  @override
  _CarrosPageState createState() => _CarrosPageState();
}

class _CarrosPageState extends State<CarrosPage>
    with AutomaticKeepAliveClientMixin<CarrosPage> {
  List<Carro> carros;

  //StreamSubscription<String> subscription;
  StreamSubscription<Event> subscription;

  String get tipo => widget.tipo;

  final _streamController = StreamController<List<Carro>>();

  final _bloc = CarrosBloc();

  @override
  void dispose() {
    _streamController.close();
    _bloc.dispose();
    subscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //parte 1
//    _loadData();
//    Future<List<Carro>> future = CarrosApi.getCarros(widget.tipo);
//
//    future.then((List<Carro> carros) {
//      setState(() {
//        this.carros = carros;
//      });
//    });
    //parte 2
    //_loadCarros();

    // parte 3
    _bloc.fetch(tipo);

    //Escutando uma stream
    //final bus = Provider.of<EventBus>(context, listen: false);
    final bus = EventBus.get(context);
    ;
//    subscription = bus.stream.listen((String s) {
//      print("Event $s");
//      _bloc.fetch(tipo);
//    });

    subscription = bus.stream.listen((Event e) {
      print("Event $e");
      CarroEvent carroEvent = e;
      if (carroEvent.tipo == tipo) {
        _bloc.fetch(tipo);
      }
    });
  }

  _loadData() async {
    List<Carro> carros = await CarrosApi.getCarros(widget.tipo);

    setState(() {
      this.carros = carros;
    });
  }

  _loadCarros() async {
    List<Carro> carros = await CarrosApi.getCarros(widget.tipo);
    _streamController.sink.add(carros);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("CarrosListView build ${widget.tipo}");

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
    return StreamBuilder(
        //stream: _streamController.stream,
        stream: _bloc.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            print(snapshot.hasError);
            print("fsfs");
            return TextError("Nao foi possivel buscar os carros");
          }
          List<Carro> carros = snapshot.data;

//          return RefreshIndicator(
//              onRefresh: _onRefresh, child: _listView(carros));
          return RefreshIndicator(
              onRefresh: _onRefresh, child: CarrosListView(carros));
        });
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

  _onClickCarro(Carro c) {
    push(context, CarroPage(c));
  }

  Future<void> _onRefresh() {
//    return Future.delayed(Duration(seconds: 3), () {
//      print("Fim");
//    });
    return _bloc.fetch(tipo);
  }
}
