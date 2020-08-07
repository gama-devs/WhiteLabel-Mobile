import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whitelabel/src/pages/Menu/menu.dart';
import 'package:whitelabel/src/pages/Menu/principal.dart';

class CategoryAll extends StatefulWidget {
  final ProductCategory productCategories;
  var authToken;
  CategoryAll({Key key, @required this.productCategories}) : super(key: key);
  @override
  _CategoryAllState createState() => new _CategoryAllState();
}

class _CategoryAllState extends State<CategoryAll> {
  var authToken;
  Size displaySize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  double displayHeight(BuildContext context) {
    return displaySize(context).height;
  }

  double displayWidth(BuildContext context) {
    return displaySize(context).width;
  }

  Container gridCategory(productList, numItems) {
    List<Widget> itemsWidgets = [];
    for (int i = 0; i < numItems; i += 2) {
      List<Widget> row = [];
      for (int j = i; j < i + 2 && j < productList.length; j++) {
        row.add(Container(
          child: Column(
            children: <Widget>[
              Container(
                  child: Container(
                padding: EdgeInsets.only(right: 10),
                width: MediaQuery.of(context).size.width * 0.45,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      decoration: BoxDecoration(border: Border()),
                      child: productList[j].image == null
                          ? Image.asset("assets/burg1.png", fit: BoxFit.cover)
                          : Image.asset(productList[j].image,
                              fit: BoxFit.cover),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              productList[j].name,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0XFFFF805D),
                                  fontWeight: FontWeight.w800),
                            ),
                            Container(
                                height: 40,
                                child: productList[j].description == null
                                    ? Text(
                                        "Descricao do produto",
                                        style: TextStyle(
                                            color: Color(0xFF413131),
                                            fontSize: 12),
                                      )
                                    : Text(
                                        productList[j].description,
                                        style: TextStyle(
                                            color: Color(0xFF413131),
                                            fontSize: 12),
                                      )),
                            Row(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(right: 3),
                                  child: Text(
                                    "R\$: " +
                                        (productList[j].price / 100)
                                            .toStringAsFixed(2)
                                            .replaceAll('.', ','),
                                    style: TextStyle(
                                        color: Color(0XFF413131),
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ],
                            )
                          ]),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ));
      }
      itemsWidgets.add(Row(children: row));
    }

    return Container(
        height: (itemsWidgets.length * 250).toDouble(),
        padding: EdgeInsets.only(top: 10),
        child: Column(children: itemsWidgets));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Stack(fit: StackFit.expand, children: <Widget>[
        Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.only(top:25),
              child: Text(widget.productCategories.name,
                  style: TextStyle(
                      color: Color(0xFFFF805D),
                      fontWeight: FontWeight.w800,
                      fontSize: 22)),
            )),
        Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: <Widget>[
                    Container(
                        width: displayWidth(context) * 0.13,
                        height: displayHeight(context) * 0.06,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Principal()));
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Color(0xFFFF805D),
                              size: 20,
                            ))),
                  ],
                )),
            SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                    child: Column(
                      children: <Widget>[
                        gridCategory(widget.productCategories.products,
                            widget.productCategories.products.length)
                      ],
                    )))
          ],
        )
      ]),
    );
  }
}
