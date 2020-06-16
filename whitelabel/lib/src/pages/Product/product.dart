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

class Options {
  int selectedOption;
  List<String> options;
  Options({this.selectedOption,options});
}

class Product extends StatefulWidget {
    final Produto selectedProduct;
   Product({Key key, @required this.selectedProduct}) : super(key: key);
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
    Produto product = widget.selectedProduct;
    print(product.jsonData);
    Padding topBar (name) { return Padding(
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
                    child: Text(name,
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: 22,
                            fontWeight: FontWeight.w800))),
              ),
            ])));}

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
                    child: Text("R\$: " +
                                        (product.price / 100)
                                            .toStringAsFixed(2)
                                            .replaceAll('.', ','),
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
                        child: Text(product.description == null? "Descrição do produto" : product.description,
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

    Container optionsCheckbox(name,index, selectedIndex){
      return Container(child: Row(children:<Widget>[
        Text(name),
        Spacer(),
        Container(height: 20,
        width: 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: index == selectedIndex? Color(0xFFFF805D) : Color(0xFFDEDEDF)),
        child: index == selectedIndex? Icon(Icons.check):Container(),),
      ]),);
    }
    Container optionsContainer(options) {
      int selectedIndex = 1;
      var optionCategory = options['name'];
      List<Widget> listOptions = [];
      for(int i = 0; i< options['options'].length;i++){
        listOptions.add(GestureDetector(
          onTap: (){
            setState(() {
              selectedIndex = i;
            });
          },
          child:optionsCheckbox(options['options'][i]['name'], i, selectedIndex)));
      }
      return Container(child: Column(children: <Widget>[
        Row(children: <Widget>[
          Text(optionCategory),
          Spacer(),
          Container(color: Color(0xFFFF805D),
          child: Text("1 de 1"),)
        ],),
        Column(children: listOptions,)
      ]));
    }



    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
            color: Color(0xFFF8F6F8),
            child: Column(children: <Widget>[
              topBar(product.name),
              details,
              
            ])),
      ),
    );
  }
}
