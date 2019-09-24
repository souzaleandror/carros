import 'package:carros/drawer_list.dart';
import 'package:carros/pages/carros/carro-form-page.dart';
import 'package:carros/pages/carros/carros_api.dart';
import 'package:carros/pages/carros/carros_page.dart';
import 'package:carros/pages/favoritos/favoritos_page.dart';
import 'package:carros/utils/navigator.dart';
import 'package:carros/utils/prefs.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin<HomePage> {
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _iniTabs();

//    _tabController = TabController(length: 3, vsync: this);
//    //_tabController.index = await Prefs.getInt("tabIdx");
//
//    Future<int> future = Prefs.getInt("tabIdx");
//    future.then((int idx) {
//      print("Tab default > $idx");
//      _tabController.index = idx;
//    });
//
//    _tabController.addListener(() {
//      print("Tab ${_tabController.index}");
//
//      Prefs.setInt("tabIdx", _tabController.index);
//    });
  }

  _iniTabs() async {
    _tabController = TabController(length: 4, vsync: this);

    _tabController.index = await Prefs.getInt("tabIdx");

    _tabController.addListener(() {
      print("Tab ${_tabController.index}");

      Prefs.setInt("tabIdx", _tabController.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("HomePage Build");
    return Scaffold(
      appBar: AppBar(
        title: Text("Carros"),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              text: "Classicos",
              icon: Icon(Icons.directions_car),
            ),
            Tab(
              text: "Esportivos",
              icon: Icon(Icons.directions_car),
            ),
            Tab(
              text: "Luxos",
              icon: Icon(Icons.directions_car),
            ),
            Tab(
              text: "Favoritos",
              icon: Icon(Icons.favorite),
            ),
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: <Widget>[
        CarrosPage(TipoCarro.classicos),
        CarrosPage(TipoCarro.esportivos),
        CarrosPage(TipoCarro.luxo),
        FavoritosPage(),
      ]),
      drawer: DrawerList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _onClickAdicionarCarro,
      ),
    );
  }

  _onClickAdicionarCarro() {
    //alert(context, "adicionar Carro !");
    push(context, CarroFormPage());
  }
}
