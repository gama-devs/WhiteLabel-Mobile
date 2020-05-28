import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:http/http.dart' as http;

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
              color: Colors.black,
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
                value: isValid,
                onChanged: (value) {
                  setState(() {
                  isValid = !isValid;
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
                  color: isValid ? Color(0xFF1BD09A) : Color(0xFFFF805D),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
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
                        width: displayWidth(context) * 0.7,
                        child: Text(
                          isValid
                              ? 'Maravilha!\n Nós atendemos sua região'
                              : 'Informe o CEP de entrega.',
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            fontSize: 19.0,
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
                      AnimatedContainer(
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
                                  child: Text(
                                    isValid ? '🛵' : 'Seu CEP',
                                    textAlign: TextAlign.center,
                                    style: new TextStyle(
                                      fontSize: isValid ? 26 : 19,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: isValid
                                          ? 0
                                          : displayHeight(context) * 0.01,
                                      bottom: isValid
                                          ? 0
                                          : displayHeight(context) * 0.01,
                                      left: isValid
                                          ? 0
                                          : displayWidth(context) * 0.45),
                                  child: isValid
                                      ? null
                                      : new GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isValid = !isValid;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xFF413131),
                                                border: Border.all(
                                                  color: Color(0xFF413131),
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            width: displayWidth(context) * 0.15,
                                            height:
                                                displayHeight(context) * 0.09,
                                            child: Icon(Icons.check,
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
           SvgPicture.asset(
            'assets/Logo.svg',
            width: displayWidth(context) * 0.8,
            height: displayHeight(context) * 0.1,
          ),
          Padding(
              padding: EdgeInsets.only(
                  top: displayHeight(context) * 0.3, bottom: 40)),
          Descricao(),
          Toogle(),
        ])),
      ]),
    );
  }
}
