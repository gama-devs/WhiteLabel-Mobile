import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:http/http.dart' as http;
import 'package:whitelabel/src/pages/CEP/search.dart';
import 'package:whitelabel/src/pages/Login/login.dart';

class Cep extends StatefulWidget {
  @override
  _CepState createState() => new _CepState();
}

class _CepState extends State<Cep> {
  Size displaySize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  double displayHeight(BuildContext context) {
    return displaySize(context).height;
  }

  double displayWidth(BuildContext context) {
    return displaySize(context).width;
  }

  bool isSwitched = true, isValid = false, isInvalid = false;
  String value = "";

  Widget Descricao() {
    return (Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 40.0, bottom: 40)),
        Container(
          width: displayWidth(context) * 0.8,
          child: Text(
            'Precisamos verificar\n se atendemos sua região.',
            textAlign: TextAlign.center,
            style: new TextStyle(
              fontSize: 23.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF413131),
            ),
          ),
        ),
      ],
    ));
  }

  Widget Toogle() {
    return (Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 40.0)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: displayWidth(context) * 0.15,
              child: Switch(
                value: isInvalid,
                onChanged: (value) {
                  setState(() {
                    isInvalid = !isInvalid;
                  });
                },
                activeTrackColor: Colors.orange,
                activeColor: Color(0xFFFF805D),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 15.0)),
            Container(
              width: displayWidth(context) * 0.6,
              child: Text(
                'Compartilhar localização',
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFFFF805D),
                ),
              ),
            ),
          ],
        ),
      ],
    ));
  }

  Widget Continue() {
    return (Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
                width: displayWidth(context) * 0.9,
                height: displayHeight(context) * 0.08,
                child: FlatButton(
                  color: Colors.white,
                  onPressed: () {
                    print('oi');
                  },
                  child: Text('Desejo acessar mesmo assim',
                      style: TextStyle(
                          color: Color(0xFFFF805D),
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.white,
                          width: 1,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(20)),
                )),
            Container(
                width: displayWidth(context) * 0.9,
                child: FlatButton(
                  onPressed: () {
                    print('oi');
                  },
                  child: Text('Utilizar outro CEP de entrega.',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                  textColor: Colors.white,
                )),
          ],
        ),
      ],
    ));
  }

  Widget Card() {
    return (Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.bounceInOut,
              decoration: BoxDecoration(
                  color: isInvalid
                      ? Color(0xFFFA5C5C)
                      : isValid ? Color(0xFF1BD09A) : Color(0xFFFF805D),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0),
                  )),
              width: displayWidth(context),
              height: displayHeight(context) * 0.3,
              child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 33.0)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: displayWidth(context) * 0.9,
                        child: Text(
                          isInvalid
                              ? 'Ah, que pena.\nAinda não atendemos sua região.'
                              : isValid
                                  ? 'Maravilha!\n Nós atendemos sua região'
                                  : 'Informe o endereço de entrega.',
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 33.0)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      isInvalid
                          ? Continue()
                          : AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              width: isValid
                                  ? displayWidth(context) * 0.2
                                  : displayWidth(context) * 0.9,
                              height: displayHeight(context) * 0.09,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: isValid
                                              ? displayHeight(context) * 0.02
                                              : displayHeight(context) * 0.03,
                                          left: displayWidth(context) * 0.06),
                                      child: isValid
                                          ? Text(
                                              '🛵',
                                              textAlign: TextAlign.center,
                                              style: new TextStyle(
                                                fontSize: isValid ? 26 : 19,
                                                fontWeight: FontWeight.normal,
                                                color: Color(0xFF413131),
                                              ),
                                            )
                                          : Center(
                                              child: Container(
                                              width:
                                                  displayWidth(context) * 0.55,
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: displayHeight(
                                                              context) *
                                                          0.02),
                                                  child: TextField(
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            "Endereço de entrega",
                                                        hintStyle: TextStyle(
                                                            color: Color(
                                                                0xFF413131),
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF413131),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                    onChanged: (text) {
                                                      value = text;
                                                    },
                                                  )),
                                            )),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: isValid
                                              ? 0
                                              : displayHeight(context) * 0.012,
                                          left: isValid
                                              ? 0
                                              : displayWidth(context) * 0.12),
                                      child: isValid
                                          ? null
                                          : new GestureDetector(
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                Timer(
                                                    Duration(seconds: 0),
                                                    () => Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    Address())));
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Color(0xFF413131),
                                                    border: Border.all(
                                                      color: Color(0xFF413131),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12))),
                                                width: 51,
                                                height: 51,
                                                child: Icon(Icons.add,
                                                    color: Colors.white),
                                              )),
                                    ),
                                  ]))
                    ],
                  )
                ],
              ),
            ),
          ],
        )));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      backgroundColor: Colors.white,
      body: new Stack(fit: StackFit.expand, children: <Widget>[
        Positioned.fill(
          child: Card(),
        ),
        Container(
            child: Column(children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 40.0)),
          new GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              setState(() {
                isValid = false;
              });
            },
            child: Image.asset(
              'assets/logo.png',
              width: displayWidth(context) * 0.4,
            ),
          ),
          Container(
            height: displayHeight(context) * 0.05,
          ),
          MediaQuery.of(context).viewInsets.bottom == 0
              ? Image.asset(
                  'assets/fone2.png',
                  width: displayWidth(context) * 0.8,
                  height: displayHeight(context) * 0.35,
                )
              : Text(''),
          Padding(padding: EdgeInsets.only(top: 20.0)),
          MediaQuery.of(context).viewInsets.bottom == 0
              ? Descricao()
              : Text(''),
        ])),
      ]),
    );
  }
}
