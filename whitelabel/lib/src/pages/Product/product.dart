import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:whitelabel/src/pages/Menu/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Product extends StatefulWidget {
  @override
  _ProductState createState() => new _ProductState();
}

class _ProductState extends State<Product> {
  //Abrindo o bottomSheet ao iniciar a tela
  var tolken;

  String searchString = "";

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
    Padding topBar = Padding(
        padding: EdgeInsets.only(top: 50, bottom: 0),
        child: Container(
            color: Color(0xFFF8F6F8),
            height: displayHeight(context) * 0.13,
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
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Menu()));
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Color(0xFFFF805D),
                          size: 20,
                        ))),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0, left: 75),
                child: Container(
                    child: Text('Pizza',
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: 22,
                            fontWeight: FontWeight.w800))),
              ),
            ])));

    Padding details = Padding(
      padding: EdgeInsets.only(top: 0, left: 0),
      child: Container(
        color: Color(0xFFF8F6F8),
        width: displayWidth(context),
        height: displayHeight(context) * 0.2,
        child: Row(children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 0, left: 15),
              child: Container(
                  width: displayWidth(context) * 0.3,
                  height: displayHeight(context) * 0.15,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child:
                          Image.asset("assets/burg1.png", fit: BoxFit.fill)))),
          Container(
              child: Padding(
            padding: EdgeInsets.only(top: 20, left: 15),
            child: Container(
                child: Column(
              children: <Widget>[
                Container(
                    width: displayWidth(context) * 0.5,
                    height: displayHeight(context) * 0.03,
                    color: Colors.transparent,
                    child: Text("RS66,90",
                        style: TextStyle(
                            color: Color(0xFF413131),
                            fontSize: 17,
                            fontWeight: FontWeight.w700))),
                Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Container(
                        width: displayWidth(context) * 0.5,
                        height: displayHeight(context) * 0.05,
                        color: Colors.transparent,
                        child: Text('A perfeita para dividir com todo mundo',
                            style: TextStyle(
                                color: Color(0xFF413131),
                                fontSize: 14,
                                fontWeight: FontWeight.normal)))),
                Container(
                    width: displayWidth(context) * 0.5,
                    height: displayHeight(context) * 0.05,
                    color: Colors.transparent,
                    child: Padding(
                        padding: EdgeInsets.only(
                          top: 0,
                          left: 0,
                          right: 80,
                          bottom: 5,
                        ),
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.white,
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('  Até 4 sabores',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xFF413131),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300))
                                ]))))
              ],
            )),
          ))
        ]),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
            color: Color(0xFFF8F6F8),
            child: Column(children: <Widget>[
              topBar,
              details,
            ])),
      ),
    );
  }
}
