import 'dart:ffi';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

class Produto {
  String image;
  String name;
  String description;
  String options;
  var price;

  Produto({this.name, this.description, this.options, this.price, this.image});
}

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => new _MenuState();
}

class _MenuState extends State<Menu> {
  Size displaySize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  double displayHeight(BuildContext context) {
    return displaySize(context).height;
  }

  double displayWidth(BuildContext context) {
    return displaySize(context).width;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final List<String> images = [
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

    final List<Produto> burguers = [
      Produto(
          name: "Smash Meat",
          description: "180g de picanha, cheddar, rúcula e pão de brioche",
          price: "28,90",
          image: "assets/burg1.png",
          options: ''),
      Produto(
          name: "Triple Angus",
          description: "180g de picanha, cheddar, rúcula e pão de brioche",
          price: "32,90",
          image: "assets/burg2.png",
          options: ''),
      Produto(
          name: "Cheddar Souce",
          description: "180g de picanha, cheddar, rúcula e pão de brioche",
          price: "25,90",
          image: "assets/burg3.png",
          options: ''),
      Produto(
          name: "Crispy Chicken",
          description: "180g de picanha, cheddar, rúcula e pão de brioche",
          price: "31,90",
          image: "assets/burg4.png",
          options: ''),
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
      items: images
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

    Container textBurger = Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              'Especiais',
              style: TextStyle(
                  color: Color(0xFF413131),
                  fontSize: 26,
                  fontWeight: FontWeight.w800),
            ),
          ),
          Container(
            child: Text(
              'Aqueles que quem conhece ama',
              style: TextStyle(color: Color(0xFF413131), fontSize: 14),
            ),
          )
        ]));

    Container gridBurguer = Container(
      height: 500,
        child: GridView.count(
          childAspectRatio: 0.75,
      crossAxisCount: 2,
      children: burguers
          .map((produto) => Container( 
                    child: Column(
                  children: <Widget>[
                    Container(
                        child: Container(
                      padding: EdgeInsets.only(right: 10),
                      width: MediaQuery.of(context).size.width / 2.0,
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 2.0,
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
    ));

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
                        children: <Widget>[
                          textBurger,
                          gridBurguer,
                        ],
                      ),
                    )
                  ],
                )),
              ])),
        )
      ]),
    );
  }
}
