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
import 'package:whitelabel/src/pages/Menu/principal.dart';

save(String key, value) async {
  print("SAVE");
  print(value.runtimeType);
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(key, json.encode(value));
}
read(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return json.decode(prefs.getString(key));
}

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
  Map<String, dynamic> toJson() => {
        'selected': selected,
        'name': name,
        'min': min,
        'max': max,
        'nOptionsSelected': nOptionsSelected,
        'required': required,
        'options': json.encode(options),
      };
  factory OptionCategory.fromJson(dynamic json) {
    var optionObjsJson = jsonDecode(json['options']) as List;
    List<Option> optionObjs = optionObjsJson
        .map((optionJson) => Option.fromJson(optionJson))
        .toList();
    return OptionCategory(
        options: optionObjs,
        name: json['name'],
        max: json['max'],
        required: json['required'],
        min: json['min'],
        selected: json['selected'],
        nOptionsSelected: json['nOptionsSelected']);
  }
  String toString() {
    return '{ ${this.name}, ${this.min}, ${this.max}, ${this.required}, ${this.selected}, ${this.options}, ${this.nOptionsSelected} }';
  }
}

class Option {
  String name;
  String description;
  double price;
  Option({this.name, this.description, this.price});
  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'price': price,
      };
  factory Option.fromJson(dynamic json) {
    return Option(
        description: json['description'],
        name: json['name'],
        price: json['price']);
  }
  String toString() {
    return '{ ${this.name}, ${this.description}, ${this.price} }';
  }
}

class FinalProduct {
  Produto product;
  List<OptionCategory> selectedOptions;
  FinalProduct({this.product, this.selectedOptions});
  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'selectedOptions': json.encode(selectedOptions)
      };
  factory FinalProduct.fromJson(dynamic json) {
    var selectedOptionsObjsJson = jsonDecode(json['selectedOptions']) as List;
    List<OptionCategory> selectedOptionsObjs = selectedOptionsObjsJson
        .map((optionJson) => OptionCategory.fromJson(optionJson))
        .toList();
    return FinalProduct(
        product: Produto.fromJson(json['product']),
        selectedOptions: selectedOptionsObjs);
  }
  String toString() {
    return '{ ${this.product}, ${this.selectedOptions} }';
  }
}

class FinalProductList {
  List<FinalProduct> listProducts;
  Map<String, dynamic> toJson() => {
        'listProducts': json.encode(listProducts),
      };
  factory FinalProductList.fromJson(Map<String, dynamic> json) {
    var selectedOptionsObjsJson = jsonDecode(json['listProducts']) as List;
    List<FinalProduct> selectedOptionsObjs = selectedOptionsObjsJson
        .map((optionJson) => FinalProduct.fromJson(optionJson))
        .toList();
    return FinalProductList(listProducts: selectedOptionsObjs);
  }
  FinalProductList({this.listProducts});
  String toString() {
    return '{ ${this.listProducts} }';
  }
}

class Product extends StatefulWidget {
  final Produto selectedProduct;
  Product({Key key, @required this.selectedProduct}) : super(key: key);
  @override
  _ProductState createState() => new _ProductState();
}

class _ProductState extends State<Product> {
  ScrollController _scrollController = new ScrollController();
  pullContainer() async {
    await new Future.delayed(const Duration(milliseconds: 1000), () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        //Para iniciar com o listView na parte de cima
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
      });
    });
  }
  FinalProductList finalProductList;
  int necessarySelected = 0;
  int fullSelected = 0;
  loadSharedPrefs() async {
    try {
      finalProductList = FinalProductList.fromJson(await read("cartItems"));
    } catch (Excepetion) {
      print(Excepetion);
      finalProductList = FinalProductList(listProducts: []);
    }
  }

  //Abrindo o bottomSheet ao iniciar a tela
  var tolken;
  List<OptionCategory> selectedOptions = [];
  String searchString = "";
  List<OptionCategory> listCategories = [];
  @override
  void initState() {
    loadSharedPrefs();
    List<OptionCategory> optionCategories = [];
    for (int i = 0;
        i < widget.selectedProduct.jsonData['option_categories'].length;
        i++) {
      List<Option> optionList = [];
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
    Padding topBar(name) {
      
      return Padding(
          padding: EdgeInsets.only(top: 20, bottom: 0),
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
                                    builder: (context) => Principal()));
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
              padding: EdgeInsets.only(bottom:30, left: 15),
              child: Container(
                  width: displayWidth(context) * 0.3,
                  height: displayHeight(context) * 0.15,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child:
                          Image.asset("assets/burg1.png", fit: BoxFit.fill)))),
          Container(
              child: Padding(
            padding: EdgeInsets.only(top: 0, left: 15),
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
          Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: 5, left: 5),
                  child: Text(
                    option.name,
                    style: TextStyle(color: Color(0xFF413131), fontSize: 16),
                  )),
              option.price != 0
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 5, left: 5),
                      child: Text(
                        " + R\$: " +
                            (option.price / 100)
                                .toStringAsFixed(2)
                                .replaceAll('.', ','),
                      ))
                  : Container()
            ],
          ),
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
                ? Icon(
                    Icons.check,
                    size: 15,
                    color: Colors.white,
                  )
                : Container(),
          ),
        ]),
      );
    }

    Container optionsCheckBoxContainer(options) {
      var optionCategory = options.name;
      List<Widget> listOptions = [];
      if (selectedOptions[selectedOptions.indexWhere(
                  (listOption) => listOption.name == optionCategory)]
              .options
              .length ==
          options.max) {
        setState(() {
          fullSelected += 1;
        });
      }
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
            Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
                child: Text(
                  "Escolha o tipo de " + optionCategory,
                  style: TextStyle(
                      color: Color(0xFF413131),
                      fontSize: 16,
                      fontWeight: FontWeight.w800),
                )),
            Spacer(),
            Container(
                child: Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5, right: 10),
                    child: Container(
                      height: 20,
                      width: 45,
                      decoration: BoxDecoration(
                          color: Color(0xFFFF805D),
                          borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        " " +
                            options.nOptionsSelected.toString() +
                            " de " +
                            options.max.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    )))
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
          Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: 5, left: 5),
                  child: Text(
                    option.name,
                    style: TextStyle(color: Color(0xFF413131), fontSize: 16),
                  )),
              option.price != 0
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 5, left: 5),
                      child: Text(
                        " + R\$: " +
                            (option.price / 100)
                                .toStringAsFixed(2)
                                .replaceAll('.', ','),
                      ))
                  : Container()
            ],
          ),
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
                      onTap: () {
                        setState(() {
                          selectedOptions[selectedOptions.indexWhere(
                                  (listOption) =>
                                      listOption.name == optionCategory)]
                              .options
                              .add(option);
                        });
                      },
                      child: Icon(Icons.add),
                    )
                  : Container(width: 20,),
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
      if (selectedOptions[selectedOptions.indexWhere(
                  (listOption) => listOption.name == optionCategory)]
              .options
              .length ==
          options.max) {
        setState(() {
          fullSelected += 1;
        });
      }
      return Container(
          child: Column(children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
                child: Text(
                  "Escolha os " + optionCategory,
                  style: TextStyle(
                      color: Color(0xFF413131),
                      fontSize: 16,
                      fontWeight: FontWeight.w800),
                )),
            Spacer(),
            Container(
                child: Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5, right: 10),
                    child: Container(
                        height: 20,
                        width: 45,
                        decoration: BoxDecoration(
                            color: Color(0xFFFF805D),
                            borderRadius: BorderRadius.circular(4)),
                        child: Center(
                          child: Text(
                            selectedOptions[selectedOptions.indexWhere(
                                        (listOption) =>
                                            listOption.name == optionCategory)]
                                    .options
                                    .length
                                    .toString() +
                                " de " +
                                options.max.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ))))
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
        setState(() {
          necessarySelected += 1;
        });
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

    GestureDetector buttonCart() {
      double optionAddValue = 0;
      for (var category in selectedOptions) {
        for (var option in category.options) {
          optionAddValue += option.price;
        }
      }
      print(necessarySelected);
      print(fullSelected);
      return GestureDetector(
          onTap: () {
            print("tappedGEsture");
            finalProductList.listProducts.add(FinalProduct(
                product: product, selectedOptions: selectedOptions));
            print(finalProductList.toJson()['listProducts']);
            save('cartItems', (finalProductList));
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Principal()));
          },
          child: Container(
              height: 110,
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                decoration: BoxDecoration(
                    color: Color(0xFFFF805D),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))),
                alignment: Alignment.bottomCenter,
                curve: fullSelected == necessarySelected
                    ? Curves.easeOutBack
                    : Curves.easeInBack,
                duration: Duration(milliseconds: 700),
                height: fullSelected == necessarySelected ? 100 : 0,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(
                    "R\$" +
                        ((product.price + optionAddValue) / 100)
                            .toStringAsFixed(2)
                            .replaceAll('.', ',') +
                        " • Adicionar a sacola",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              )));
    }

    Scaffold scaffold() {
      necessarySelected = 0;
      fullSelected = 0;
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
              color: Color(0xFFF8F6F8),
              child: Column(children: <Widget>[
                topBar(product.name),
                details,
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32))),
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: Align(alignment: Alignment.bottomCenter,child:SingleChildScrollView(
                    
                    controller: _scrollController,
                    child: Column(
                    
                    children: <Widget>[
                      Container(padding: EdgeInsets.all(10),child:requiredOptions(listCategories)),
                      
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(children: <Widget>[buttonCart()]),
                      )
                    ],
                  ),)
                )),
              ])),
        ),
      );
    }

    return scaffold();
  }
}
