import 'package:carros/pages/favoritos/favoritos_model.dart';
import 'package:carros/splash_page.dart';
import 'package:carros/utils/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//final favoritosBloc = FavoritosBloc();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
//        Provider<FavoritosBloc>(
//            builder: (context) => FavoritosBloc(),
//            dispose: (context, bloc) => bloc.dispose()),
//        Provider<FavoritosModel>(
//          builder: (context) => FavoritosModel(),
//        )
        Provider<EventBus>(
          builder: (context) => EventBus(),
          dispose: (context, bus) => bus.dispose(),
        ),
        ChangeNotifierProvider<FavoritosModel>(
          builder: (context) => FavoritosModel(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white),
        home: SplashPage(),
      ),
    );
  }
}
