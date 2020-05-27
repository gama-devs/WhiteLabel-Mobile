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

  bool isSwitched = true;

  Widget Logo() {
    return (Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: displayWidth(context) * 0.8,
          child: Image.asset('assets/log.png'),
        ),
      ],
    ));
  }

  Widget Photo() {
    return (Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: displayWidth(context) * 0.55,
          child: Image.asset('assets/hand.png'),
        ),
      ],
    ));
  }

  Widget Descricao() {
    return (Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 40.0, bottom: 40)),
        Container(
          width: displayWidth(context) * 0.8,
          child: Text(
            'Precisamos verificar se atendemos sua região.',
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
        Padding(padding: EdgeInsets.only(top: 40.0, bottom: 40)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: displayWidth(context) * 0.15,
              child: Switch(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
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
    return (Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 200.0)),
        Container(
          decoration: BoxDecoration(
              color: Color(0xFFFF805D),
              border: Border.all(
                color: Color(0xFFFF805D),
              ),
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
                  Text(
                    'Informe o CEP de entrega.',
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                      fontSize: 19.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 33.0)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      width: displayWidth(context) * 0.9,
                      height: displayHeight(context) * 0.09,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  top: displayHeight(context) * 0.03,
                                  left: displayWidth(context) * 0.06),
                              child: Text(
                                'Seu CEP',
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: displayHeight(context) * 0.01,
                                    bottom: displayHeight(context) * 0.01,
                                    left: displayWidth(context) * 0.45),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xFF413131),
                                      border: Border.all(
                                        color: Color(0xFF413131),
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  width: displayWidth(context) * 0.15,
                                  height: displayHeight(context) * 0.09,
                                  child: Icon(Icons.check, color: Colors.white),
                                )),
                          ]))
                ],
              )
            ],
          ),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      backgroundColor: Colors.white,
      body: new Stack(fit: StackFit.expand, children: <Widget>[
        Container(
            child: Column(children: <Widget>[
          Logo(),
          Photo(),
          Descricao(),
          Toogle(),
          Card(),
        ])),
      ]),
    );
  }
}
