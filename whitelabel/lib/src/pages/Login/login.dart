import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whitelabel/src/pages/Menu/menu.dart';
import 'package:whitelabel/src/pages/Password/password.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

TextEditingController emailInputController = new TextEditingController();
TextEditingController celInputController = new TextEditingController();
TextEditingController passwordInputController = new TextEditingController();
TextEditingController nameInputController = new TextEditingController();
var maskFormatter = new MaskTextInputFormatter(
    mask: '#####-####', filter: {"#": RegExp(r'[0-9]')});

class _LoginState extends State<Login> {
  final formKey = new GlobalKey<FormState>();
  bool isLogin = true;
  bool hide = false;
  bool loginFail = false;
  bool loading = false;
  saveTolken(tolken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('tolken_code', tolken);
    // String to = prefs.getString('tolken_code');
    //print('$to');
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    Container textCadastro = Container(
      width: 310,
      child: Text(
        'Vamos criar sua conta?\n É rápido! Igual nossa entrega.',
        style: TextStyle(
            color: Color(
              0xFFFF805D,
            ),
            fontSize: 20,
            height: 1.2,
            fontWeight: FontWeight.w700),
        textAlign: TextAlign.center,
      ),
    );

    Container textInstruction = Container(
      width: 270,
      child: Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Text(
          'Preencha os dados abaixo e enviaremos uma confirmação via SMS.',
          style: TextStyle(
              color: Color(
                0xFF413131,
              ),
              fontSize: 14,
              fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ),
    );

    GestureDetector returnButton = GestureDetector(
      onTap: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 700),
        curve: Curves.fastOutSlowIn,
        width: isLogin ? 0 : 40,
        height: isLogin ? 0 : 40,
        alignment: isLogin ? Alignment.centerRight : Alignment.center,
        child: isLogin
            ? Container()
            : Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
        decoration: BoxDecoration(
            color: isLogin ? Color(0x00FF805D) : Color(0xFFFF805D),
            borderRadius: BorderRadius.circular(10)),
      ),
    );

    Container textLogin = Container(
        width: 290,
        child: Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text(
            'Realize seu login e\n aproveite nosso Aplicativo.',
            style: TextStyle(
                color: Color(
                  0xFFFF805D,
                ),
                fontSize: 20,
                height: 1.2,
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ));

    TextFormField celInput = TextFormField(
      controller: celInputController,
      inputFormatters: [maskFormatter],
      validator: (value) => value.isEmpty ? 'Digite seu celular' : null,
      decoration: InputDecoration(
          fillColor: Color(0xFFEDF1F7),
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(25.0, 20.0, 30.0, 20.0),
          hintText: "Seu celular",
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(
                color: Color(0xFFEDF1F7),
              )),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color(0xFFFF805D), width: 2.0),
          )),
    );

    TextFormField passwordInput = TextFormField(
      controller: passwordInputController,
      validator: (value) => value.isEmpty ? 'Digite sua senha' : null,
      obscureText: hide ? true : false,
      decoration: InputDecoration(
          fillColor: Color(0xFFEDF1F7),
          filled: true,
          suffixIcon: new GestureDetector(
            onTap: () {
              setState(() {
                hide = !hide;
              });
            },
            child:
                hide ? Icon(Icons.visibility_off) : Icon(Icons.remove_red_eye),
          ),
          contentPadding: EdgeInsets.fromLTRB(25.0, 20.0, 30.0, 20.0),
          hintText: "Escolha sua senha",
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: Color(0xFFEDF1F7))),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color(0xFFFF805D), width: 2.0),
          )),
    );

    Container textForgetPassword = Container(
        child: new GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Password()));
      },
      child: Text(
        'Esqueci minha senha',
        style: TextStyle(
          color: Color(
            0xFF413131,
          ),
          fontSize: 12,
          height: 1.2,
        ),
        textAlign: TextAlign.center,
      ),
    ));

    Container textCreateAccount = Container(
        child: GestureDetector(
      onTap: () {
        print(isLogin);
        setState(() {
          isLogin = false;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 30)),
          Text(
            'Ainda não tem conta?',
            style: TextStyle(color: Color(0xFFFF805D), fontSize: 14),
          ),
          Text(
            ' Crie agora mesmo!',
            style: TextStyle(
                color: Color(0xFFFF805D),
                fontSize: 14,
                fontWeight: FontWeight.w900),
          ),
        ],
      ),
    ));

    TextFormField emailInput = TextFormField(
      controller: emailInputController,
      validator: (value) => value.isEmpty ? 'Digite seu e-mail' : null,
      decoration: InputDecoration(
          fillColor: Color(0xFFEDF1F7),
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(25.0, 20.0, 30.0, 20.0),
          hintText: "Seu e-mail",
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(
                color: Color(0xFFEDF1F7),
              )),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color(0xFFFF805D), width: 2.0),
          )),
    );

    TextFormField nameInput = TextFormField(
      controller: nameInputController,
      validator: (value) => value.isEmpty ? 'Digite seu nome' : null,
      decoration: InputDecoration(
          fillColor: Color(0xFFEDF1F7),
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(25.0, 20.0, 30.0, 20.0),
          hintText: "Seu nome",
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(
                color: Color(0xFFEDF1F7),
              )),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color(0xFFFF805D), width: 2.0),
          )),
    );

    Future<String> postLoginButton(BuildContext context) async {
      print(passwordInputController.text);
      print(nameInputController.text);
      print(celInputController.text);
      print(emailInputController.text);
      print("TESTE");
      var jsonLogin = json.encode({
        "company_id": 2,
        "phone": celInputController.text,
        "password": passwordInputController.text
      });
      var number = "2";
      try {
        setState(() {
          loading = true;
        });
        print("Teste login");
        http.Response response = await http.post(
            Uri.encodeFull("http://50.16.146.1/api/auth/login/app"),
            headers: {
              "Accept": "application/json",
              "content-type": "application/json",
            },
            body: jsonLogin);
        var jsonData = response.body;
        print(jsonData);
        var parsedJson = json.decode(jsonData);
        print(parsedJson);
        print(response.statusCode);
        if (response.statusCode == 200) {
          setState(() {
            loading = false;
          });
          var token = parsedJson['data']["access_token"];
          var userId = parsedJson['data']['user']['id'];
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Menu()));

          saveTolken(token);
        } else {
          setState(() {
            loading = false;
          });
          setState(() {
            loginFail = true;
          });
        }
        print(response.body);
      } catch (e) {
        print(e);
      }
    }

    Material loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      color: Color(0xFFFF805D),
      child: MaterialButton(
        minWidth: double.infinity,
        padding: EdgeInsets.fromLTRB(40.0, 20, 40.0, 40.0),
        onPressed: () {
          final form = formKey.currentState;
          postLoginButton(context);
          FocusScope.of(context).unfocus();
        },
        child: loading
            ? SpinKitCircle(
                color: Colors.white,
                size: 35,
              )
            : Text("Entrar",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 20)),
      ),
    );

    Future<String> postRegisterData(BuildContext context) async {
      print(passwordInputController.text);
      print(nameInputController.text);
      print(celInputController.text);
      print(emailInputController.text);
      print("TESTE");
      var number = 2;
      var jsao = json.encode({
        "company_id": number,
        "name": nameInputController.text,
        "email": emailInputController.text,
        "phone": celInputController.text,
        "password": passwordInputController.text,
        "password_confirmation": passwordInputController.text,
        "addresses": [
          {
            "description": "Casa",
            "complement": "Apto 1",
            "zip_code": "91712150",
            "address": "Rua Primordial 103 - Gloria - Porto Alegre - RS",
            "latitude": "-30.09045170",
            "longitude": "-51.18067240"
          }
        ]
      });
      try {
        setState(() {
          loading = true;
        });
        http.Response response = await http.post(
            Uri.encodeFull("http://50.16.146.1/api/customers"),
            headers: {
              "Accept": "application/json",
              "content-type": "application/json"
            },
            body: jsao);
        print(response.body);
        print(jsao);
      } catch (e) {
        print(e);
      }
      setState(() {
        loading = false;
      });
    }

    Material registerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      color: Color(0xFFFF805D),
      child: MaterialButton(
        minWidth: double.infinity,
        padding: EdgeInsets.fromLTRB(40.0, 20, 40.0, 40.0),
        onPressed: () {
          postRegisterData(context);
          setState(() {
            isLogin = !isLogin;
          });
        },
        child: loading
            ? SpinKitCircle(
                color: Colors.white,
                size: 35,
              )
            : Text("Cadastrar",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 20)),
      ),
    );

    Card registerCard = Card(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Container(
          width: double.infinity,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 15),
                  child: Column(
                    children: <Widget>[
                      textCadastro,
                      SizedBox(
                        height: 5,
                      ),
                      textInstruction,
                      SizedBox(
                        height: 10,
                      ),
                      celInput,
                      SizedBox(
                        height: 5,
                      ),
                      emailInput,
                      SizedBox(
                        height: 5,
                      ),
                      nameInput,
                      SizedBox(
                        height: 5,
                      ),
                      passwordInput,
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 0,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                registerButton,
              ])),
    );

    Card loginCard = Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      margin: EdgeInsets.all(0),
      child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30, top: 15),
              child: Column(
                children: <Widget>[
                  textLogin,
                  SizedBox(
                    height: 0,
                  ),
                  celInput,
                  SizedBox(
                    height: 10,
                  ),
                  passwordInput,
                  SizedBox(
                    height: 5,
                  ),
                  Row(children: <Widget>[Spacer(), textForgetPassword]),
                  SizedBox(
                    height: 10,
                  ),
                  textCreateAccount,
                ],
              ),
            ),
            Spacer(),
            loginButton,
          ])),
    );

    Card error = Card(
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
          color: Color(0xFFFA5C5C),
          width: MediaQuery.of(context).size.width,
          child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30, top: 30),
              child: Column(
                children: <Widget>[
                  Text(
                    "Ah, que pena.\nEmail ou senha incorretos",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        height: 1,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.only(),
            ),
            Material(
              elevation: 0,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.white,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width / 1.2,
                padding: EdgeInsets.fromLTRB(30.0, 25, 30.0, 25.0),
                onPressed: () {
                  setState(() {
                    loginFail = !loginFail;
                  });
                },
                child: Text("Tentar novamente",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 16)),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
                child: new GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Password()));
              },
              child: Text(
                'Esqueci minha senha',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            )),
            Spacer(),
          ])),
    );
    return Scaffold(
      body: new Stack(fit: StackFit.expand, children: <Widget>[
        SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: new AssetImage("assets/bg.png"),
                      fit: BoxFit.cover)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 40),
                      child: returnButton,
                    ),
                    Spacer(),
                    AnimatedContainer(
                        duration: Duration(milliseconds: 700),
                        height: loginFail
                            ? 250
                            : isLogin
                                ? 355
                                : MediaQuery.of(context).viewInsets.bottom == 0
                                    ? 475
                                    : 550,
                        curve: Curves.easeInOutBack,
                        child: loginFail
                            ? error
                            : isLogin ? loginCard : registerCard),
                  ])),
        ),
      ]),
    );
  }
}
