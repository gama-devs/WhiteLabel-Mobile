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

class OptionCategory {
  int selected;
  String name;
  int min;
  int max;
  int nOptionsSelected;
  int required;
  List<Option> options;

  OptionCategory(
      {this.name,
      this.min,
      this.max,
      this.required,
      this.selected = -1,
      this.options,
      this.nOptionsSelected = 0});
}

class Option {
  String name;
  String description;
  double price;
  Option({this.name, this.description, this.price});
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
  List<OptionCategory> selectedOptions = [];
  String searchString = "";
  List<OptionCategory> listCategories = [];
  @override
  void initState() {
    List<OptionCategory> optionCategories = [];
    for (int i = 0;
        i < widget.selectedProduct.jsonData['option_categories'].length;
        i++) {
      List<Option> optionList = [];
      print("Option");
      print(widget.selectedProduct.jsonData['option_categories'][i]);
      for (int j = 0;
          j <
              widget.selectedProduct.jsonData['option_categories'][i]['options']
                  .length;
          j++) {
        optionList.add(Option(
            name: widget.selectedProduct.jsonData['option_categories'][i]
                ['options'][j]['name'],
            description: widget.selectedProduct
                .jsonData['option_categories'][i]['options'][j]['description']
                .toString(),
            price: widget.selectedProduct
                .jsonData['option_categories'][i]['options'][j]['price']
                .toDouble()));
      }
      selectedOptions.add(OptionCategory(
          options: [],
          name: widget.selectedProduct.jsonData['option_categories'][i]['name'],
          max: widget.selectedProduct.jsonData['option_categories'][i]['max'],
          min: widget.selectedProduct.jsonData['option_categories'][i]['min'],
          required: widget.selectedProduct.jsonData['option_categories'][i]
              ['required']));
      optionCategories.add(OptionCategory(
          options: optionList,
          name: widget.selectedProduct.jsonData['option_categories'][i]['name'],
          max: widget.selectedProduct.jsonData['option_categories'][i]['max'],
          min: widget.selectedProduct.jsonData['option_categories'][i]['min'],
          required: widget.selectedProduct.jsonData['option_categories'][i]
              ['required']));
    }
    setState(() {
      listCategories = optionCategories;
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

  Widget build(BuildContext context) {
    Produto product = widget.selectedProduct;
    print(product.jsonData);
    Padding topBar(name) {
      return Padding(
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
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Menu()));
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
              ])));
    }

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
                    child: Text(
                        "R\$: " +
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
                        child: Text(
                            product.description == null
                                ? "Descrição do produto"
                                : product.description,
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

    Container optionsCheckbox(categoryName, option) {
      return Container(
        child: Row(children: <Widget>[
          Text(option.name),
          Spacer(),
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: selectedOptions[selectedOptions.indexWhere(
                                (listOption) =>
                                    listOption.name == categoryName)]
                            .options
                            .indexOf(option) !=
                        -1
                    ? Color(0xFFFF805D)
                    : Color(0xFFDEDEDF)),
            child: selectedOptions[selectedOptions.indexWhere(
                            (listOption) => listOption.name == categoryName)]
                        .options
                        .indexOf(option) !=
                    -1
                ? Icon(Icons.check)
                : Container(),
          ),
        ]),
      );
    }

    Container optionsCheckBoxContainer(options) {
      var optionCategory = options.name;
      List<Widget> listOptions = [];
      for (int i = 0; i < options.options.length; i++) {
        if (options.required == 1)
          listOptions.add(GestureDetector(
              onTap: () {
                setState(() {
                  if (selectedOptions[selectedOptions.indexWhere((listOption) =>
                              listOption.name == optionCategory)]
                          .options
                          .indexOf(options.options[i]) ==
                      -1) {
                    if (!(selectedOptions[selectedOptions.indexWhere(
                                (listOption) =>
                                    listOption.name == optionCategory)]
                            .options
                            .length <
                        selectedOptions[selectedOptions.indexWhere(
                                (listOption) =>
                                    listOption.name == optionCategory)]
                            .max)) {
                      selectedOptions[selectedOptions.indexWhere((listOption) =>
                              listOption.name == optionCategory)]
                          .options
                          .removeAt(0);
                      selectedOptions[selectedOptions.indexWhere((listOption) =>
                              listOption.name == optionCategory)]
                          .options
                          .add(options.options[i]);
                    } else {
                      selectedOptions[selectedOptions.indexWhere((listOption) =>
                              listOption.name == optionCategory)]
                          .options
                          .add(options.options[i]);
                      options.nOptionsSelected += 1;
                    }
                  } else {
                    selectedOptions[selectedOptions.indexWhere(
                            (listOption) => listOption.name == optionCategory)]
                        .options
                        .remove(options.options[i]);
                    options.nOptionsSelected -= 1;
                  }
                });
              },
              child: optionsCheckbox(optionCategory, options.options[i])));
      }
      return Container(
          child: Column(children: <Widget>[
        Row(
          children: <Widget>[
            Text(optionCategory),
            Spacer(),
            Container(
              color: Color(0xFFFF805D),
              child: Text(options.nOptionsSelected.toString() +
                  "de" +
                  options.max.toString()),
            )
          ],
        ),
        Column(
          children: listOptions,
        )
      ]));
    }

    Container optionsCounter(optionCategory, option) {
      int numberOfItemsSelected = 0;
      for (var optionSelected in selectedOptions[selectedOptions
              .indexWhere((listOption) => listOption.name == optionCategory)]
          .options) {
        if (optionSelected == option) numberOfItemsSelected += 1;
      }
      return Container(
        child: Row(children: <Widget>[
          Text(option.name),
          Spacer(),
          Row(
            children: <Widget>[
              selectedOptions[selectedOptions.indexWhere((listOption) =>
                              listOption.name == optionCategory)]
                          .options
                          .indexOf(option) !=
                      -1
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedOptions[selectedOptions.indexWhere(
                                (listOption) =>
                                    listOption.name == optionCategory)]
                            .options
                            .remove(option);
                        });
                        
                      },
                      child: Icon(Icons.remove),
                    )
                  : Container(),
              Text(numberOfItemsSelected.toString()),
              selectedOptions[selectedOptions.indexWhere((listOption) =>
                              listOption.name == optionCategory)]
                          .options
                          .length <
                      selectedOptions[selectedOptions.indexWhere((listOption) =>
                              listOption.name == optionCategory)]
                          .max
                  ? GestureDetector(
                      onTap: () {setState(() {
                        selectedOptions[selectedOptions.indexWhere(
                                (listOption) =>
                                    listOption.name == optionCategory)]
                            .options
                            .add(option);
                      });
                        
                      },
                      child: Icon(Icons.add),
                    )
                  : Container(),
            ],
          )
        ]),
      );
    }

    Container optionsCounterContainer(options) {
      var optionCategory = options.name;
      List<Widget> listOptions = [];
      for (int i = 0; i < options.options.length; i++) {
          listOptions.add(Container(
              child: optionsCounter(optionCategory, options.options[i])));
      }
      return Container(
          child: Column(children: <Widget>[
        Row(
          children: <Widget>[
            Text(optionCategory),
            Spacer(),
            Container(
              color: Color(0xFFFF805D),
              child: Text(selectedOptions[selectedOptions
              .indexWhere((listOption) => listOption.name == optionCategory)]
          .options.length.toString() +
                  "de" +
                  options.max.toString()),
            )
          ],
        ),
        Column(
          children: listOptions,
        )
      ]));
    }

    Container requiredOptions(optionList) {
      List<Widget> listRequiredOptions = [];
      for (var option in optionList) {
        if (option.required == 1)
        listRequiredOptions.add(optionsCheckBoxContainer(option));
      }
      for (var option in optionList) {
        if (option.required != 1)
        listRequiredOptions.add(optionsCounterContainer(option));
      }
      return Container(
        child: Column(
          children: listRequiredOptions,
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
            color: Color(0xFFF8F6F8),
            child: Column(children: <Widget>[
              topBar(product.name),
              details,
              requiredOptions(listCategories)
            ])),
      ),
    );
  }
}
