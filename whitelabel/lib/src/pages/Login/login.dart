import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> { //Abrindo o bottomSheet ao iniciar a tela


 
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    Container textLogin = Container(
      child: Text(
        'Realize seu login e aproveite nosso Aplicativo.',
        style: TextStyle(color: Color(0xFFFF805D,),
        fontSize: 20),),
      );


    return Scaffold(
      body: new Stack(fit: StackFit.expand, children: <Widget>[
        SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: new BoxDecoration(
                image: new DecorationImage(image: new AssetImage("assets/backgroundpizza.png"), fit: BoxFit.cover)
              ),
              child: Column(children: <Widget>[
              
              ])),
        )
      ]),
    );
  }
}