import 'dart:async';

import 'package:carros/pages/carros/home_page.dart';
import 'package:carros/pages/login/api_response.dart';
import 'package:carros/pages/login/firebase_service.dart';
import 'package:carros/pages/login/login_bloc.dart';
import 'package:carros/pages/login/usuario.dart';
import 'package:carros/utils/alert_dialog.dart';
import 'package:carros/utils/navigator.dart';
import 'package:carros/widgets/app_button.dart';
import 'package:carros/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _streamController = StreamController<bool>();

  final _bloc = LoginBloc();

//  final _tLogin = TextEditingController();
//  final _tPassword = TextEditingController();

  final _tNome = TextEditingController(text: "teste22");
  final _tLogin = TextEditingController(text: "teste22");
  final _tPassword = TextEditingController(text: "teste22");

  final _formKey = GlobalKey<FormState>();
  final _focusNome = FocusNode();
  final _focusEmail = FocusNode();
  final _focusSenha = FocusNode();

  bool _showProgress = false;

  @override
  void dispose() {
    _streamController.close();
    _bloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
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
            AppText("Nome", "Digite o nome",
                controller: _tNome,
                validator: _validatorNome,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                nextFocus: _focusNome),
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
            StreamBuilder<bool>(
                stream: _bloc.stream,
                initialData: false,
                builder: (context, snapshot) {
                  bool b = snapshot.data;
                  return AppButton(
                    text: "Login",
                    onPressed: _onClickLogin,
                    showProgress: snapshot.data,
                  );
                }),
          ],
        ),
      ),
    );
  }

  String _validatorNome(String text) {
    if (text.isEmpty) {
      return "Digite o Nome";
    } else {
      return null;
    }
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
    ApiResponse response = await _bloc.login(login, senha);

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

  void _onClickGoogle() async {
    final service = FirebaseService();
    ApiResponse response = await service.loginGoogle();

    if (response.ok) {
      push(context, HomePage());
    } else {
      alert(context, "Error", response.msg);
    }
  }

  _onClickCadastrar(BuildContext context) {}
}
