import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whitelabel/src/pages/Menu/menu.dart';

class categoryAll extends StatefulWidget {
  var authToken;
  @override
  _categoryAllState createState() => new _categoryAllState();
}

class _categoryAllState extends State<categoryAll> {
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

  List<ProductCategory> categories = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Stack(fit: StackFit.expand, children: <Widget>[
        SingleChildScrollView(
          child: Container(),
        )
      ]),
    );
  }
}
