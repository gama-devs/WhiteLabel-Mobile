import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Category {
  String name;
  String description;
  List<Produto> products;
  Category({this.name, this.description, this.products});
}

class Produto {
  String image;
  String name;
  String description;
  String options;
  String price;

  Produto({this.name, this.description, this.options, this.price, this.image});
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
    print(token);
    authToken = token;
  }

  var loading = false;

  Future<String> getProducts(BuildContext context) async {
    getToken();
    try {
      setState(() {
        loading = true;
      });
      print("Teste menus");
      print(authToken.toString());
      http.Response response = await http.get(
        Uri.encodeFull("http://50.16.146.1/api/products?company_id=2"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer " +
              "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNTZiMTYwYjkxOGU1ZWEwMTgxODY4YmJkMzFkOTlhMjBiNGI1NzE5MWMzN2RlNmQwZWVmODBjM2FiOTI0YjU5YTQ2ZTcwYjViNTI3ZGFiZTIiLCJpYXQiOjE1OTE2NjM1NTEsIm5iZiI6MTU5MTY2MzU1MSwiZXhwIjoxNjIzMTk5NTUxLCJzdWIiOiIzOCIsInNjb3BlcyI6W119.fMQVyl6pk_937IShaFH4iEqlM9tK3F5GRlJgz_7c8-xSrqM87b1YABPllSrritM-ozYre8lHOJkkI-rX6KIjOY3EinFsjT6PXgJlF7ygZtBZqMz6BvGo3IppY9XzdnKc6I3GGWEBAKwvR7lArEe1P2Q1myudz4rJC8fDz5LmJ8Yy2knIldh9kQsrtAYbvLltHccvhIBC47rjxJgOVmQV0BqHSRIXRD5Xc06ozYuzHxbLwdXqXvaewWfcpd3OxRXKs7mk0ipEd87aEBhwSdreER14PcgyxRBXTTf26VTPkLlR0HYrmokDGE6uubmpeharwSvSkEvw-dLeEtEHp8ON2lYmksr5dLUQrB5upEVupE6zcvrc0m8q5Fey7JHol-nLjNbjMIcJG08U0Bt5GLkoLvszDA-g7ht3esFAM_tKwLSGGTYJ_PynpsaNcvgtUqK6EaiK6tGOQ60ToiHnFKP8Ky0Jsbqv0d37zm-4JMnmPGGiJyQiJbOrV5m0MYrjCZ4avA7AyCwiXknRlITawlk9zHOUvqTebR-Ri9vKza1TEnWUAtXdz9SnADa4ZYhTD1mZKuFmeOq4omLzXcojW2SVOt-_7jCbb9RPtQqoG2hMqvM_EKgUlcPYWJ8JlIg1gYanzr-EaXoNPDuAvsTVQu57oRnHCRe-rmNp-ukmuB372T8"
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
              price: (product['price'] / 100).toString()));
        }
        categories.add(Category(
            name: categoryName,
            description: categoryDescription,
            products: products));
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

  List<Category> categories = [];
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
          price: "R\$:66,90",
          image: 'assets/pizzaGrande.png'),
      Produto(
          name: 'Grande',
          description: 'Feita pra juntar a galera e aproveitar!',
          options: 'Até 3 sabores',
          price: 'R\$:58,90',
          image: 'assets/pizzaMedia.png'),
      Produto(
          name: 'Pequena',
          description: 'Pra não se sentir solitario',
          options: 'Até 3 sabores',
          price: 'R\$:25,90',
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
              suffixIcon: Icon(Icons.search),
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
        setState(() {});
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
                        child: Container(
                      padding: EdgeInsets.only(right: 10),
                      width: MediaQuery.of(context).size.width / 1.8,
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 1.8,
                            decoration: BoxDecoration(border: Border()),
                            child:
                                Image.asset(produto.image, fit: BoxFit.cover),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                  BorderRadius.circular(10.0),
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
                                          produto.price,
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

    Container textCategory(name, description) {
    
    return Container(
          child: name == null ? Container(): Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
            name == null ? Container():Container(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                name,
                style: TextStyle(
                    color: Color(0xFF413131),
                    fontSize: 26,
                    fontWeight: FontWeight.w800),
              ),
            ),
            description == null ? Container():Container(
              child: Text(
                description,
                style: TextStyle(color: Color(0xFF413131), fontSize: 14),
              ),
            )
          ]));
    }

    Container gridCategory(productList) {
      return Container(
          height: productList.length > 2 ? 500:250,
          child:GridView.count(
                scrollDirection: Axis.vertical,
                
                childAspectRatio: 0.75,
                crossAxisCount: 2,
                children: productList
                    .map<Widget>((product) => Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                  child: Container(
                                padding: EdgeInsets.only(right: 10),
                                width: MediaQuery.of(context).size.width / 2.0,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.0,
                                      decoration:
                                          BoxDecoration(border: Border()),
                                      child: product.image == null
                                          ? Image.asset("assets/burg1.png",
                                              fit: BoxFit.cover)
                                          : Image.asset(product.image,
                                              fit: BoxFit.cover),
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              product.name,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0XFFFF805D),
                                                  fontWeight: FontWeight.w800),
                                            ),
                                            Container(
                                                height: 40,
                                                child:
                                                    product.description == null
                                                        ? Text(
                                                            "Descricao do produto",
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFF413131),
                                                                fontSize: 12),
                                                          )
                                                        : Text(
                                                            product.description,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFF413131),
                                                                fontSize: 12),
                                                          )),
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(right: 3),
                                                  child: Text(
                                                    product.price,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0XFF413131),
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w800),
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
                        ))
                    .toList(),
              )
            
          );
    }

    Container listCategories(categoriesList) {
      print("OI");
      loading ? print("loading"):categoriesList.map((category) => print(category));
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
                                textCategory(category.name, category.description),
                                gridCategory(category.products),
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
                      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
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
