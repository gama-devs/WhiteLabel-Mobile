import 'dart:ffi';
import 'dart:convert';
import 'dart:ffi';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whitelabel/src/pages/Search/searchMenu.dart';
import 'package:whitelabel/src/pages/Menu/categoryAll.dart';
import 'package:whitelabel/src/pages/Product/product.dart';
import 'package:whitelabel/src/pages/Orders/cart.dart';

import '../Orders/cart.dart';

class ProductCategory {
  String name;
  String description;
  List<Produto> products;
  int showItems;
  ProductCategory(
      {this.name, this.description, this.products, this.showItems = 4});
  Map toJson() => {
        'name': name,
        'description': description,
        'products': json.encode(products),
        'showItems': showItems
      };
  factory ProductCategory.fromJson(dynamic json) {
    var productObjsJson = jsonDecode(json['products']) as List;
    List<Produto> productObjs = productObjsJson
        .map((productJson) => Produto.fromJson(productJson))
        .toList();
    return ProductCategory(
        name: json['name'],
        description: json['description'],
        products: productObjs,
        showItems: json['showItems']);
  }
  @override
  String toString() {
    return '{ ${this.name}, ${this.description}, ${this.products}, ${this.showItems} }';
  }
}

class Produto {
  String image;
  String name;
  String description;
  String options;
  var price;
  var jsonData;
  Produto(
      {this.name,
      this.description,
      this.options,
      this.price,
      this.image,
      this.jsonData = ''});
  Map toJson() => {
        'image': image,
        'name': name,
        'description': description,
        'options': options,
        'price': price,
        'jsonData': jsonData
      };
  factory Produto.fromJson(dynamic json) {
    return Produto(
        image: json['image'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        options: json['options'] as String,
        price: json['price'],
        jsonData: json['jsonData']);
  }
  @override
  String toString() {
    return '{ ${this.name}, ${this.description}, ${this.options}, ${this.price}, ${this.image}, ${this.jsonData} }';
  }
}

class Menu extends StatefulWidget {
  var authToken;
  @override
  _MenuState createState() => new _MenuState();
}

class _MenuState extends State<Menu> {
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

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('tolken_code');
  }

  var loading = false;

  Future<String> getProducts(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('tolken_code');
    try {
      setState(() {
        loading = true;
      });
      print("Teste menus");
      print(token);
      http.Response response = await http.get(
        Uri.encodeFull("http://50.16.146.1/api/products?company_id=2"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer " + token
        },
      );
      var jsonData = json.decode(response.body);
      List<Produto> products = [];
      categories = [];
      for (int i = 0; i < jsonData['data'].length; i++) {
        print(jsonData['data'].length);
        products = [];
        var categoryName = jsonData['data'][i]['name'];
        var categoryDescription = jsonData['data'][i]['description'];
        for (int j = 0; j < jsonData['data'][i]['products'].length; j++) {
          var product = jsonData['data'][i]['products'][j];
          products.add(Produto(
              description: product['description'],
              image: product['image'],
              name: product['name'],
              options: product["option_categories"].length > 0
                  ? "Até " +
                      product["option_categories"].length.toString() +
                      " sabores!"
                  : "",
              price: (product['price']),
              jsonData: product));
        }
        categories.add(ProductCategory(
            name: categoryName,
            description: categoryDescription,
            products: products,
            showItems: 4));
        print(categoryName);
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      loading = false;
    });
  }

  void initState() {
    getProducts(context);
    super.initState();
  }

  List<ProductCategory> categories = [];
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final List<String> promoImages = [
      'assets/promo.png',
      'assets/promo.png',
      'assets/promo.png'
    ];

    final List<Produto> produtos = [
      Produto(
          name: 'Familia',
          description: 'A perfeita para dividir com todo mundo',
          options: 'Até 4 sabores',
          price: 66.90,
          image: 'assets/pizzaGrande.png'),
      Produto(
          name: 'Grande',
          description: 'Feita pra juntar a galera e aproveitar!',
          options: 'Até 3 sabores',
          price: 58.90,
          image: 'assets/pizzaMedia.png'),
      Produto(
          name: 'Pequena',
          description: 'Pra não se sentir solitario',
          options: 'Até 3 sabores',
          price: 25.90,
          image: 'assets/pizzaGrande.png')
    ];
    Container containerLogo = Container(
      width: MediaQuery.of(context).size.width / 4,
      child: Image.asset('assets/logo.png'),
    );

    Container search = Container(
        width: MediaQuery.of(context).size.width / 2,
        child: TextFormField(
          validator: (value) => value.isEmpty ? 'Digite seu celular' : null,
          decoration: InputDecoration(
              fillColor: Color(0xFFEDF1F7),
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              suffixIcon: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchMenu(
                                productCategories: categories,
                              )));
                },
                child: Icon(Icons.search),
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: BorderSide(
                    color: Color(0xFFEDF1F7),
                  )),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide:
                    const BorderSide(color: Color(0xFFFF805D), width: 2.0),
              )),
        ));

    GestureDetector profileButton = GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Cart()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 7.5,
        height: MediaQuery.of(context).size.width / 7.5,
        alignment: Alignment.center,
        child: Icon(
          Icons.person,
          color: Colors.white,
        ),
        decoration: BoxDecoration(
            color: Color(0xFFFF805D), borderRadius: BorderRadius.circular(12)),
      ),
    );

    CarouselSlider carouselPromos = CarouselSlider(
      options: CarouselOptions(height: 160, viewportFraction: 0.8),
      items: promoImages
          .map((item) => Container(
                padding: EdgeInsets.only(right: 5, left: 5),
                child: Center(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        item,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                )),
              ))
          .toList(),
    );

    Container textPizza = Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              'Pizzas',
              style: TextStyle(
                  color: Color(0xFF413131),
                  fontSize: 26,
                  fontWeight: FontWeight.w800),
            ),
          ),
          Container(
            child: Text(
              'Uma pizza melhor que a outra',
              style: TextStyle(color: Color(0xFF413131), fontSize: 14),
            ),
          )
        ]));
    CarouselSlider carouselPizzas = CarouselSlider(
      options: CarouselOptions(
          viewportFraction: 0.48,
          height: MediaQuery.of(context).size.height / 2.5),
      items: produtos
          .map((produto) => Container(
                child: Center(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                          border: Border(),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Container(
                          padding: EdgeInsets.only(right: 10),
                          width: MediaQuery.of(context).size.width / 1.8,
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width / 1.8,
                                decoration: BoxDecoration(
                                  border: Border(),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Image.asset(produto.image,
                                    fit: BoxFit.cover),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0)
                                      ),
                                ),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        produto.name,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0XFFFF805D),
                                            fontWeight: FontWeight.w800),
                                      ),
                                      Container(
                                          height: 40,
                                          child: Text(
                                            produto.description,
                                            style: TextStyle(
                                                color: Color(0xFF413131),
                                                fontSize: 12),
                                          )),
                                      Row(
                                        children: <Widget>[
                                          SizedBox(
                                            height: 4,
                                            width: 4,
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color: Color(0xFFFFC850)),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            child: Text(
                                              produto.options,
                                              style: TextStyle(
                                                  color: Color(0xFF625F6F),
                                                  fontSize: 11),
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(right: 3),
                                            child: Text(
                                              "R\$:" +
                                                  (produto.price / 100)
                                                      .toStringAsFixed(2)
                                                      .replaceAll('.', ','),
                                              style: TextStyle(
                                                  color: Color(0XFF413131),
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(right: 3),
                                            child: Text('A partir',
                                                style: TextStyle(
                                                  color: Color(0XFF413131),
                                                  fontSize: 11,
                                                )),
                                          )
                                        ],
                                      )
                                    ]),
                              ),
                            ],
                          ),
                        )),
                  ],
                )),
              ))
          .toList(),
    );

    Container textCategory(category) {
      String name = category.name;
      String description = category.description;
      return Container(
          child: name == null
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                      name == null
                          ? Container()
                          : Container(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Text(
                                name,
                                style: TextStyle(
                                    color: Color(0xFF413131),
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                      Row(
                        children: <Widget>[
                          description == null
                              ? Container()
                              : Container(
                                  child: Text(
                                    description,
                                    style: TextStyle(
                                        color: Color(0xFF413131), fontSize: 14),
                                  ),
                                ),
                          Spacer(),
                          Container(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CategoryAll(
                                              productCategories: category,
                                            )));
                              },
                              child: Text(
                                "Ver todos",
                                style: TextStyle(
                                    color: Color(0xFFFF805D), fontSize: 14),
                              ),
                            ),
                          )
                        ],
                      )
                    ]));
    }

    Container gridCategory(productList, numItems) {
      List<Widget> itemsWidgets = [];
      for (int i = 0; i < numItems; i += 2) {
        List<Widget> row = [];
        for (int j = i; j < i + 2 && j < productList.length; j++) {
          row.add(Container(
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Product(
                              selectedProduct: productList[j],
                            )));
                print("tapped");
              },
              child: Container(
                  child: Container(
                padding: EdgeInsets.only(right: 10),
                width: MediaQuery.of(context).size.width * 0.45,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: MediaQuery.of(context).size.width * 0.35,
                      decoration: BoxDecoration(
                        border: Border(),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: productList[j].image == null
                          ? Image.asset("assets/burg1.png", fit: BoxFit.contain)
                          : Image.network(
                              "http://50.16.146.1/storage/" +
                                  productList[j].image,
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

    Container listCategories(categoriesList) {
      loading
          ? print("loading")
          : categoriesList.map((category) => print(category));
      return (loading
          ? Container()
          : Container(
              child: Column(
                  children: categoriesList
                      .map<Widget>((category) => Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                textCategory(category),
                                gridCategory(
                                    category.products,
                                    category.products.length > 2
                                        ? category.showItems
                                        : 2),
                              ],
                            ),
                          ))
                      .toList()),
            ));
    }

    return Scaffold(
      body: new Stack(fit: StackFit.expand, children: <Widget>[
        SingleChildScrollView(
          child: Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          top: 40.0, bottom: 20, left: 20, right: 20),
                      child: Row(
                        children: <Widget>[
                          containerLogo,
                          search,
                          SizedBox(
                            width: 2,
                          ),
                          profileButton
                        ],
                      ),
                    ),
                    carouselPromos,
                    Container(
                        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: Column(
                          children: <Widget>[
                            Row(children: <Widget>[
                              textPizza,
                            ]),
                          ],
                        )),
                    Container(
                      child: carouselPizzas,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20, left: 20, right: 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [listCategories(categories)]),
                    )
                  ],
                )),
              ])),
        )
      ]),
    );
  }
}
