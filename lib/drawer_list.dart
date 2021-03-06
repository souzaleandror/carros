import 'package:carros/pages/login/firebase_service.dart';
import 'package:carros/pages/login/login_page.dart';
import 'package:carros/pages/login/usuario.dart';
import 'package:carros/pages/site_page.dart';
import 'package:carros/utils/navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerList extends StatelessWidget {
  UserAccountsDrawerHeader _header2(FirebaseUser user) {
    return UserAccountsDrawerHeader(
      accountName: Text(user.displayName ?? ""),
      accountEmail: Text(user.email ?? ""),
      currentAccountPicture: user.photoUrl != null
          ? CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl),
            )
          : FlutterLogo(),
    );
  }

  UserAccountsDrawerHeader _header(Usuario user) {
    return UserAccountsDrawerHeader(
      accountEmail: Text(user.nome ?? ""),
      accountName: Text(user.email ?? ""),
      currentAccountPicture: user.urlFoto != null
          ? CircleAvatar(
              backgroundImage: NetworkImage(user.urlFoto),
            )
          : FlutterLogo(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<Usuario> future = Usuario.get();
    Future<FirebaseUser> future2 = FirebaseAuth.instance.currentUser();

    return SafeArea(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            FutureBuilder<Usuario>(
              future: future,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                Usuario user = snapshot.data;

                return user != null ? _header(user) : Container();
              },
            ),
            FutureBuilder<FirebaseUser>(
              future: future2,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                FirebaseUser user2 = snapshot.data;

                return user2 != null ? _header2(user2) : Container();
              },
            ),
//            FutureBuilder<FirebaseUser>(
//              future: future,
//              builder: (context, snapshot) {
//                FirebaseUser user = snapshot.data;
//
//                return user != null ? _header(user) : Container();
//              },
//            ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text("Favoritos"),
              subtitle: Text("mais informações..."),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                print("Item 1");
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text("Ajuda"),
              subtitle: Text("mais informações..."),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                print("Item 1");
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text("Visite seu site"),
              subtitle: Text("mais informações..."),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.pop(context);
                _onClickSite(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Logout"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => _onClickLogout(context),
            )
          ],
        ),
      ),
    );
  }

  _onClickLogout(BuildContext context) {
    Usuario.clear();
    FirebaseService().logout();
    Navigator.pop(context);
    push(context, LoginPage(), replace: true);
  }

  _onClickSite(BuildContext context) {
    push(context, SitePage(), replace: false);
  }
}
