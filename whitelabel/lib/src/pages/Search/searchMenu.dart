import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class searchMenu extends StatefulWidget {
  @override
  _searchMenuState createState() => new _searchMenuState();
}

class _searchMenuState extends State<searchMenu> {
  //Abrindo o bottomSheet ao iniciar a tela
  @override
  void initState() {}

  Size displaySize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  double displayHeight(BuildContext context) {
    return displaySize(context).height;
  }

  double displayWidth(BuildContext context) {
    return displaySize(context).width;
  }

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    Padding topBar = Padding(
        padding: EdgeInsets.only(top: 0, bottom: 0),
        child: Container(
            color: Color(0xFFF8F6F8),
            height: displayHeight(context) * 0.2,
            width: displayWidth(context) * 1,
            child: Row(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 0, left: 20),
                child: Container(
                    width: displayWidth(context) * 0.13,
                    height: displayHeight(context) * 0.06,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFFFF805D),
                      size: 20,
                    )),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 0, left: 20),
                  child: Container(
                      height: displayHeight(context) * 0.06,
                      width: displayWidth(context) * 0.7,
                      child: TextField(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                  color: Color(0xFFF8F6F8),
                                )),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Color(0xFFFF805D), width: 2.0),
                            ),
                            fillColor: Colors.white,
                            prefixIcon: Icon(
                              Icons.search,
                              color: Color(0xFFFF805D),
                            ),
                            hintText: "Buscar Itens",
                            hintStyle: TextStyle(
                                color: Color(0xFF413131),
                                fontSize: 16,
                                fontWeight: FontWeight.normal)),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color(0xFF413131),
                            fontSize: 16,
                            fontWeight: FontWeight.normal),
                        onChanged: (text) {},
                      )))
            ])));

    Padding emptyCard = Padding(
        padding: EdgeInsets.only(top: 0),
        child: Container(
            width: displayWidth(context),
            height: displayHeight(context) * 0.76,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            child: Padding(
                padding: EdgeInsets.only(top: 75, left: 0),
                child: Column(children: <Widget>[
                  Container(
                    width: displayWidth(context) * .6,
                    child: Text(
                      'O que você está buscando para hoje?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFFFF805D),
                      ),
                    ),
                  ),
                  Padding(
                padding: EdgeInsets.only(top: 0),
                  child:Container(
                      height: displayHeight(context) * 0.5,
                      width: displayWidth(context) * 0.8,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/mulhercelular.png'),
                          fit: BoxFit.fill,
                        ),
                      )))
                ]))));

    return Scaffold(
      body: Center(
        child: Container(
          color: Color(0xFFF8F6F8),
          child: Padding(
            padding: const EdgeInsets.only(),
            child: ListView(children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  topBar,
                  SizedBox(height: 0),
                  emptyCard,
                  SizedBox(height: 0),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
