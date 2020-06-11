import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:whitelabel/src/pages/Menu/menu.dart';

import '../Menu/menu.dart';

class CartItem {
  int quantity;
  Produto product;
  CartItem({this.quantity, this.product});

  getFinalPrice() {
    return ((this.product.price * this.quantity));
  }
}

class Address {
  String name;
  String description;

  Address({this.name, this.description});
}

Address enderecoTeste = Address(
    name: "Casa",
    description:
        "R. Álvares Machado, 187,Petrópolis, Porto Alegre/RS\n CEP: 94252-652");

List<CartItem> items = [
  CartItem(
      quantity: 2,
      product: Produto(
          description:
              'Massa Tradicional, Borda recheada, Formaggi, Calabresa, Strogonoff e Frango com Catupity',
          image: '',
          name: 'Pizza Familia',
          price: 60,
          options: '')),
  CartItem(
      quantity: 1,
      product: Produto(
          description: "2 litros",
          image: '',
          name: 'Coca - cola',
          options: '',
          price: 6.50))
];

class Cart extends StatefulWidget {
  @override
  _CartState createState() => new _CartState();
}

bool loaded = false;

class _CartState extends State<Cart> {
  Size displaySize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  double displayHeight(BuildContext context) {
    return displaySize(context).height;
  }

  double displayWidth(BuildContext context) {
    return displaySize(context).width;
  }

  pullContainer() async {
    await new Future.delayed(const Duration(milliseconds: 1500));
    setState(() {
      loaded = true;
    });
  }

  Container cardItemContainer(cardItem) {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.only(bottom: 3),
                  child: Text(
                    cardItem.product.name,
                    style: TextStyle(
                        color: Color(0xFFFF805D),
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.only(bottom: 3),
                  child: Text(
                    cardItem.product.description,
                    style: TextStyle(color: Color(0xFF413131), fontSize: 12),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(
                    "R\$: " +
                        cardItem
                            .getFinalPrice()
                            .toStringAsFixed(2)
                            .replaceAll('.', ','),
                    style: TextStyle(
                        color: Color(0xFF413131),
                        fontSize: 18,
                        fontWeight: FontWeight.w800),
                  ),
                )
              ],
            ),
            Spacer(),
            IconButton(
              padding: EdgeInsets.only(right: 3),
              icon: Icon(
                Icons.minimize,
                size: 20,
                color: Color(0xFFDEDEDF),
              ),
              onPressed: () {
                if (cardItem.quantity > 1)
                  setState(() {
                    cardItem.quantity -= 1;
                  });
              },
            ),
            Text(cardItem.quantity.toString()),
            IconButton(
              padding: EdgeInsets.only(left: 3),
              icon: Icon(
                Icons.add,
                size: 20,
                color: Color(0xFFFF805D),
              ),
              onPressed: () {
                setState(() {
                  cardItem.quantity += 1;
                });
              },
            ),
          ],
        ));
  }

  Card cardAddress(address) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(
          color: Color(0xFFFF805D),
          width: 0.7,
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width*0.7,
        height: MediaQuery.of(context).size.height*0.2,
        padding: EdgeInsets.fromLTRB(20,10,10,10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          
          children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
            child: Text(
              address.name,
              style: TextStyle(
                  color: Color(0xFF413131),
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
            child: Text(
              address.description,
              style: TextStyle(
                  color: Color(0xFF413131),
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ]),
      ),
    );
  }

  AnimatedContainer cardCart() {
    if (!loaded) pullContainer();

    return AnimatedContainer(
      curve: Curves.easeOutBack,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32), topRight: Radius.circular(32))),
      height: loaded ? MediaQuery.of(context).size.height * 0.8 : 0,
      width: MediaQuery.of(context).size.width,
      duration: Duration(milliseconds: 700),
      child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  "🍕 Itens",
                  style: TextStyle(
                      color: Color(0xFF413131),
                      fontSize: 16,
                      fontWeight: FontWeight.w800),
                ),
              ),
              Column(
                  children:
                      items.map((item) => cardItemContainer(item)).toList()),
              cardAddress(enderecoTeste),
            ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      backgroundColor: Color(0xFF1BD09A),
      body: new Stack(fit: StackFit.expand, children: <Widget>[
        Align(alignment: Alignment.bottomCenter, child: cardCart()),
      ]),
    );
  }
}
