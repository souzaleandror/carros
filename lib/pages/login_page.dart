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

  void _onClickLogin() {
    bool formOk = _formKey.currentState.validate();

    if (!formOk) {
      return;
    }

    String login = _tLogin.text;
    String senha = _tPassword.text;

    print("Login = ${login} e senha = ${senha}");
  }
}
