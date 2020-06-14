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

class SearchMenu extends StatefulWidget {

  final List<ProductCategory> productCategories;
   SearchMenu({Key key, @required this.productCategories}) : super(key: key);
  @override
  _SearchMenuState createState() => new _SearchMenuState();
}

class _SearchMenuState extends State<SearchMenu> {
  //Abrindo o bottomSheet ao iniciar a tela
  var tolken;

  String searchString = "";

  @override
  void initState() {
    inputController.addListener(() {
      //here you have the changes of your textfield
      texto = Uri.encodeFull(inputController.text);

      //use setState to rebuild the widget
      setState(() {
        searchString = inputController.text;
      });
    });

    setState(() {
      texto = Uri.encodeFull(inputController.text);
    });
    super.initState();
  }

  Size displaySize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  double displayHeight(BuildContext context) {
    return displaySize(context).height;
  }

  double displayWidth(BuildContext context) {
    return displaySize(context).width;
  }

  bool input = true;
  final String value = "";
  var inputController = new TextEditingController();
  String texto = "";

  Widget build(BuildContext context) {

  List<ProductCategory> categories = widget.productCategories;
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
                    child: GestureDetector(
                      onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Menu()));
                },
                      child:Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFFFF805D),
                      size: 20,
                    ))),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 0, left: 20),
                  child: Container(
                      height: displayHeight(context) * 0.06,
                      width: displayWidth(context) * 0.7,
                      child: TextField(
                        controller: inputController,
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
                      child: Container(
                          height: displayHeight(context) * 0.5,
                          width: displayWidth(context) * 0.8,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/mulhercelular.png'),
                              fit: BoxFit.fill,
                            ),
                          )))
                ]))));

    Padding fillCard(ProductCategory, text) {
      List<Produto> productList = [];
      List<Widget> children = [];
      children.add(Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Container(
              child: Text(
                ProductCategory.name,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF413131),
                ),
              ),
            ),
          ));
      for (var product in ProductCategory.products) {
        if (product.name.toLowerCase().contains(text.toLowerCase())) children.add(Padding(
          padding: EdgeInsets.only(top: 0, left: 0),
          child: Container(
              padding: EdgeInsets.only(bottom:10),
              child: Text(
                product.name,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF413131),
                ),
              ),
            ),
          ));
      }

      return Padding(
          padding: EdgeInsets.only(
            top: 0,
          ),
          child: Container(
              width: displayWidth(context),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              )));
    }

    List <Widget> productsList = [];
    for (var category in categories) productsList.add(fillCard(category, searchString));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          color: Color(0xFFF8F6F8),
            
            child: Column(children: <Widget>[
              topBar,
              Container(
                padding: EdgeInsets.only(left:15),
                decoration: BoxDecoration(color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(32),topRight: Radius.circular(32))),
                height: MediaQuery.of(context).size.height * 0.8,
                child:searchString == ''? emptyCard :ListView(children: productsList))
            ]
            )
          ),
        ),

    );
  }
}
