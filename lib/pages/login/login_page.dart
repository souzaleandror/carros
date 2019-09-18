import 'package:carros/pages/carro/home_page.dart';
import 'package:carros/pages/login/api_response.dart';
import 'package:carros/pages/login/login_api.dart';
import 'package:carros/pages/login/usuario.dart';
import 'package:carros/utils/alert_dialog.dart';
import 'package:carros/utils/navigator.dart';
import 'package:carros/widgets/app_button.dart';
import 'package:carros/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _tLogin = TextEditingController();
  final _tPassword = TextEditingController();

  //final _tLogin = TextEditingController(text: "teste2");
  //final _tPassword = TextEditingController(text: "teste2");

  final _formKey = GlobalKey<FormState>();
  final _focusSenha = FocusNode();

  bool _showProgress = false;

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
            AppButton(
              text: "Login",
              onPressed: _onClickLogin,
              showProgress: _showProgress,
            )
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
    ApiResponse response = await LoginApi.login(login, senha);

    if (response.ok) {
      Usuario user = response.result;

      print(">>>>> $user");

      setState(() {
        _showProgress = false;
      });

      push(context, HomePage(), replace: true);
    } else {
      print("Login Incorreto");
      alert(context, response.msg);

      setState(() {
        _showProgress = false;
      });
    }
  }
}