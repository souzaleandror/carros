import 'dart:async';

import 'package:carros/pages/carros/home_page.dart';
import 'package:carros/pages/login/api_response.dart';
import 'package:carros/pages/login/cadastro_page.dart';
import 'package:carros/pages/login/firebase_service.dart';
import 'package:carros/pages/login/login_bloc.dart';
import 'package:carros/pages/login/usuario.dart';
import 'package:carros/utils/alert_dialog.dart';
import 'package:carros/utils/navigator.dart';
import 'package:carros/widgets/app_button.dart';
import 'package:carros/widgets/app_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _streamController = StreamController<bool>();

  final _bloc = LoginBloc();
  final _bloc2 = LoginBloc();

  final _tLogin = TextEditingController();
  final _tPassword = TextEditingController();

  //final _tLogin = TextEditingController(text: "teste2");
  //final _tPassword = TextEditingController(text: "teste2");

  final _formKey = GlobalKey<FormState>();
  final _focusSenha = FocusNode();

  bool _showProgress = false;

  FirebaseUser user;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void dispose() {
    _streamController.close();
    _bloc.dispose();
    _bloc2.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Future<Usuario> future = Usuario.get();
    future.then((Usuario user) {
      if (user != null) {
        push(context, HomePage(), replace: true);
//        setState(() {
//          _tLogin.text = user.login;
//        });
      }
    });

    //final RemoteConfig remoteConfig = await RemoteConfig.instance;

    RemoteConfig.instance.then((remoteConfig) {
      remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: false));
      //final defaults = <String, dynamic>{'welcome': 'default welcome'};
      //remoteConfig.setDefaults(defaults);

      try {
        remoteConfig.fetch(expiration: const Duration(minutes: 1));
        remoteConfig.activateFetched();
      } catch (e, exception) {
        print("Remote Confing: $e >> $exception");
      }
      final mensagem = remoteConfig.getString("eu");

      print('mensagem: ${mensagem}');
    });

    _firebaseMessaging.getToken().then((token) {
      print("Firebase Toke ${token}");
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: ${message}");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: ${message}");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: ${message}");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carros"),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  _body() {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            AppText("Login", "Digite o Login",
                controller: _tLogin,
                validator: _validatorLogin,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                nextFocus: _focusSenha),
            SizedBox(
              height: 10,
            ),
            AppText(
              "Senha",
              "Digite a Senha",
              password: true,
              controller: _tPassword,
              validator: _validatorPassword,
              keyboardType: TextInputType.number,
              focusNode: _focusSenha,
            ),
            SizedBox(
              height: 20,
            ),
//parte 1
//            AppButton(
////              text: "Login",
////              onPressed: _onClickLogin,
////              showProgress: _showProgress,
////            )
            // parte 2
//            StreamBuilder<bool>(
//                stream: _streamController.stream,
//                initialData: false,
//                builder: (context, snapshot) {
//                  bool b = snapshot.data;
//
//                  return AppButton(
//                    text: "Login",
//                    onPressed: _onClickLogin,
//                    showProgress: snapshot.data,
//                  );
//                })
            StreamBuilder<bool>(
                stream: _bloc2.stream,
                initialData: false,
                builder: (context, snapshot) {
                  bool b = snapshot.data;
                  return AppButton(
                    text: "Login Com API Carros",
                    onPressed: _onClickLogin,
                    showProgress: snapshot.data,
                  );
                }),
            StreamBuilder<bool>(
                stream: _bloc.stream,
                initialData: false,
                builder: (context, snapshot) {
                  bool b = snapshot.data;
                  return AppButton(
                    text: "Login Com Firebase",
                    onPressed: _onClickLoginGoogle,
                    showProgress: snapshot.data,
                  );
                }),
            Container(
              height: 46,
              margin: EdgeInsets.all(20),
              child: GoogleSignInButton(
                onPressed: _onClickGoogle,
              ),
            ),
            Container(
              color: Colors.white,
              height: 46,
              margin: EdgeInsets.all(20),
              child: InkWell(
                onTap: () => _onClickCadastrar(context),
                child: Text(
                  "Cadastre-se",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _validatorLogin(String text) {
    if (text.isEmpty) {
      return "Digite o login";
    } else {
      return null;
    }
  }

  String _validatorPassword(String text) {
    if (text.isEmpty) {
      return "Digite o password";
    }
    if (text.length < 3) {
      return "O minimo 3 caracteres";
    } else {
      return null;
    }
  }

  void _onClickLogin() async {
    bool formOk = _formKey.currentState.validate();

    setState(() {
      _showProgress = true;
    });

    _streamController.add(true);

    if (!formOk) {
      return;
    }

    String login = _tLogin.text;
    String senha = _tPassword.text;

    print("Login = ${login} e senha = ${senha}");
    //push(context, HomePage());
//    bool ok = await LoginApi.login(login, senha);
//
//    if (ok) {
//      push(context, HomePage());
//    } else {
//      print("Login Incorreto");
//    }

    // parte 2
//    Usuario user = await LoginApi.login(login, senha);
//
//    if (user != null) {
//      print(">>>> $user");
//
//      push(context, HomePage());
//    } else {
//      print("Login Incorreto");
//    }

    // parte 3
    //ApiResponse response = await LoginApi.login(login, senha);
    ApiResponse response = await _bloc.loginAPI(login, senha);

    if (response.ok) {
      Usuario user = response.result;

      print(">>>>> $user");

      setState(() {
        _showProgress = false;
      });

      _streamController.add(false);

      push(context, HomePage(), replace: true);
    } else {
      print("Login Incorreto");
      alert(context, "Erro", response.msg);

      setState(() {
        _showProgress = false;
      });

      _streamController.add(false);
    }
  }

  void _onClickLoginGoogle() async {
    String login = _tLogin.text;
    String senha = _tPassword.text;

    final service = FirebaseService();
    ApiResponse response = await service.login(login, senha);

    if (response.ok) {
      push(context, HomePage());
    } else {
      alert(context, "Error", response.msg);
    }
  }

  void _onClickGoogle() async {
    final service = FirebaseService();
    ApiResponse response = await service.loginGoogle();

    if (response.ok) {
      push(context, HomePage());
    } else {
      alert(context, "Error", response.msg);
    }
  }

  _onClickCadastrar(BuildContext context) {
    push(context, CadastroPage(), replace: true);
  }
}
