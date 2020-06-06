import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:http/http.dart' as http;
import 'package:whitelabel/src/pages/Login/login.dart';

class Address extends StatefulWidget {
  @override
  _AddressState createState() => new _AddressState();
}

class _AddressState extends State<Address> {
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
        Padding(padding: EdgeInsets.only(top: 0.0, bottom: 40)),
        Container(
          width: displayWidth(context) * 0.2,
          child: Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Icon(
                Icons.arrow_back_ios,
                color: Color(0xFFFF805D),
              )),
        ),
        Container(
            width: displayWidth(context) * 0.7,
            child: TextField(
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xFFFF805D),
                  ),
                  border: InputBorder.none,
                  hintText: "Digite o endereço",
                  hintStyle: TextStyle(
                      color: Color(0xFF413131),
                      fontSize: 16,
                      fontWeight: FontWeight.normal)),
              textInputAction: TextInputAction.continueAction,
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Color(0xFF413131),
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
              onChanged: (text) {
                value = text;
              },
            )),
      ],
    ));
  }

  Widget Number() {
    return (Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: displayWidth(context) * 0.9,
          child: Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text('Por gentileza, informe o número.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    ));
  }

  Widget NumberTextField() {
    return (Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            width: displayWidth(context) * 0.7,
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Número",
                  hintStyle: TextStyle(
                      color: Color(0xFF413131),
                      fontSize: 16,
                      fontWeight: FontWeight.normal)),
              textInputAction: TextInputAction.continueAction,
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Color(0xFF413131),
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
              onChanged: (text) {
                value = text;
              },
            )),
      ],
    ));
  }

  Widget NumberButton() {
    return (Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
            width: displayWidth(context) * 0.75,
            height: displayHeight(context) * 0.08,
            child: FlatButton(
              color: Colors.white,
              onPressed: () {
                print('oi');
              },
              child: Text('Endereço sem número',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.normal)),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Colors.white, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(20)),
            )),
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
                          color: Colors.black,
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
                  child: Text('Utilizar outro endereço de entrega.',
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
                  color: isInvalid ? Color(0xFFFA5C5C) : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0),
                  )),
              width: displayWidth(context),
              height: isInvalid
                  ? displayHeight(context) * 0.35
                  : displayHeight(context) * 0.68,
              child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 43.0)),
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
                                  ? 'Que tal já salvar o endereço\n para suas compras?'
                                  : 'Informe o CEP de entrega.',
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            fontSize: 19.0,
                            fontWeight: FontWeight.bold,
                            color: isInvalid ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  isInvalid
                      ? SizedBox.shrink()
                      : Padding(padding: EdgeInsets.only(top: 43.0)),
                  isInvalid
                      ? SizedBox.shrink()
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: displayWidth(context) * 0.9,
                              child: Text(
                                'Rua Venâncio Aires, 139,',
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFFFF805D),
                                ),
                              ),
                            ),
                          ],
                        ),
                  isInvalid
                      ? SizedBox.shrink()
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: displayWidth(context) * 0.9,
                              child: Text(
                                'Rua Venâncio Aires, 139,',
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFFFF805D),
                                ),
                              ),
                            ),
                          ],
                        ),
                  isInvalid
                      ? SizedBox.shrink()
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: displayWidth(context) * 0.9,
                              child: Text(
                                'CEP: 94415-352',
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFFFF805D),
                                ),
                              ),
                            ),
                          ],
                        ),
                  isInvalid
                      ? SizedBox.shrink()
                      : Padding(padding: EdgeInsets.only(top: 43.0)),
                  isInvalid
                      ? SizedBox.shrink()
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: displayWidth(context) * 0.6,
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Complemento(caso tenha)",
                                      hintStyle: TextStyle(
                                          color: Color(0xFF413131),
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal)),
                                  textInputAction:
                                      TextInputAction.continueAction,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color(0xFF413131),
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                  onChanged: (text) {
                                    value = text;
                                  },
                                )),
                          ],
                        ),
                  isInvalid
                      ? SizedBox.shrink()
                      : Padding(padding: EdgeInsets.only(top: 13.0)),
                  isInvalid
                      ? SizedBox.shrink()
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: displayWidth(context) * 0.6,
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Nome do endereço(ex.Casa)",
                                      hintStyle: TextStyle(
                                          color: Color(0xFF413131),
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal)),
                                  textInputAction:
                                      TextInputAction.continueAction,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color(0xFF413131),
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                  onChanged: (text) {
                                    value = text;
                                  },
                                )),
                          ],
                        ),
                  isInvalid
                      ? Padding(padding: EdgeInsets.only(top: 21.0))
                      : Padding(padding: EdgeInsets.only(top: 13.0)),
                  isInvalid
                      ? Continue()
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                  bottom: 20.0, left: 30, right: 30),
                              child: Container(
                                  width: displayWidth(context) * 0.8,
                                  height: displayHeight(context) * 0.08,
                                  child: FlatButton(
                                    color: Color(0xFFFF805D),
                                    onPressed: () {
                                      print('oi');
                                      setState(() {
                                        isValid = true;
                                      });
                                    },
                                    child: Text('Confirmar',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700)),
                                    textColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Color(0xFFFF805D),
                                            width: 1,
                                            style: BorderStyle.solid),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  )),
                            )
                          ],
                        ),
                  isInvalid
                      ? SizedBox.shrink()
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                  bottom: 70.0, left: 30, right: 30),
                              child: Container(
                                  width: displayWidth(context) * 0.8,
                                  height: displayHeight(context) * 0.03,
                                  child: FlatButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      print('oi');
                                      setState(() {
                                        isInvalid = true;
                                        isValid = false;
                                      });
                                    },
                                    child: Text('Não, obrigado.',
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700)),
                                    textColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.white,
                                            width: 1,
                                            style: BorderStyle.solid),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  )),
                            )
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
      backgroundColor: isValid ? Color(0xFF1BD09A) : Colors.white,
      body: new Stack(fit: StackFit.expand, children: <Widget>[
        isValid
            ? Positioned.fill(
                child: Card(),
              )
            : new Positioned(
                child: new Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                      padding:
                          EdgeInsets.only(bottom: 70.0, left: 30, right: 30),
                      child: Container(
                          width: displayWidth(context) * 0.8,
                          height: displayHeight(context) * 0.08,
                          child: FlatButton(
                            color: Color(0xFFFF805D),
                            onPressed: () {
                              print('oi');
                              setState(() {
                                isValid = true;
                              });
                            },
                            child: Text('Confirmar',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700)),
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Color(0xFFFF805D),
                                    width: 1,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(20)),
                          )),
                    )),
              ),
        Column(
          children: <Widget>[
            Container(
              height: 50,
            ),
            isValid ? Text('') : Descricao(),
            Container(
              height: 50,
            ),
            isValid ? Text('') : Number(),
            Container(
              height: 50,
            ),
            isValid ? Text('') : NumberTextField(),
            Container(
              height: 20,
            ),
            isValid ? Text('') : NumberButton()
          ],
        ),
      ]),
    );
  }
}
