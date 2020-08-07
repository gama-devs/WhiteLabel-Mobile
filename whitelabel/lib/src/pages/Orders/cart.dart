import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whitelabel/src/pages/Menu/menu.dart';
import 'package:whitelabel/src/pages/Product/product.dart';
import '../Menu/menu.dart';

remove(String key) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}

class PaymentMethod {
  String description;
  String name;
  bool needInput;
  PaymentMethod(
      {this.description = 'Descricao',
      this.name = 'name',
      this.needInput = false});
}

int selectedPayment = 1;
int selectedAddress = 0;
bool creditCardError = false;

class CartItem {
  int quantity;
  FinalProduct product;
  CartItem({this.quantity, this.product});

  double getFinalPrice() {
    double optionAddValue = 0;
    for (var category in this.product.selectedOptions) {
      for (var option in category.options) {
        optionAddValue += option.price;
      }
    }
    return ((this.product.product.price + optionAddValue) * quantity);
  }

  getAllOptions() {
    print(this.product);
    String selectedOptions = '';
    for (var category in this.product.selectedOptions) {
      for (var option in category.options) {
        print(option);
        selectedOptions += option.name + ', ';
      }
    }
    print(selectedOptions);
    return selectedOptions;
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

List<Address> addresses = [
  enderecoTeste,
  Address(
      name: "Trabalho",
      description:
          "R. Álvares Machado, 187,Petrópolis, Porto Alegre/RS\n CEP: 94252-652")
];

String customerName = "Bianca Lima";

List<PaymentMethod> paymentMethods = [
  PaymentMethod(name: "Pagamento na entrega", description: "Débito"),
  PaymentMethod(name: "Pagamento na entrega", description: "Dinheiro"),
];

List<CartItem> items = [];

class Cart extends StatefulWidget {
  @override
  _CartState createState() => new _CartState();
}

bool loaded = false;

class _CartState extends State<Cart> {
  FinalProductList finalProductList;
  String name = '';
  loadSharedPrefs() async {
    try {
      finalProductList = FinalProductList.fromJson(await read("cartItems"));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('tolken_code');
      print(token);
      name = prefs.getString('currentUser');
      print("Ihul");
      var noDuplicates = finalProductList.listProducts.toSet().toList();
      try {
        for (var finalProduct in noDuplicates) {
          int quantity = 0;
          for (var duplicate in finalProductList.listProducts) {
            if (finalProduct == duplicate) {
              quantity += 1;
              print(quantity);
            }
          }
          setState(() {
            items.add(CartItem(product: finalProduct, quantity: quantity));
          });
        }
      } catch (e) {
        print(e);
      }
    } catch (Excepetion) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      name = prefs.getString('currentUser');

      print("Erro");
      print(Excepetion);
    }
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

  List<String> flagOptions = ["VISA", "MASTERCARD", "ELO"];
  pullContainer() async {
    await new Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        loaded = true;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        //Para iniciar com o listView na parte de cima
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
      });
    });
  }

  @override
  void initState() {
    loadSharedPrefs();
    super.initState();
  }

  Container cardItemContainer(cardItem) {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
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
                    cardItem.product.product.name,
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
                    cardItem.getAllOptions(),
                    style: TextStyle(color: Color(0xFF413131), fontSize: 12),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(
                    "R\$: " +
                        (cardItem.getFinalPrice() / 100)
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
              padding: EdgeInsets.only(right: 3, bottom: 12),
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
              padding: EdgeInsets.only(),
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

  Container addAnotherProduct() {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFF1BD09A), borderRadius: BorderRadius.circular(4)),
      height: 75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Ainda dá tempo de adicionar\nmais alguma delicia ☺️",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800),
              )),
          Spacer(),
          Container(
            padding: EdgeInsets.only(right: 10),
            child: Container(
              height: 30,
              width: 80,
              child: Center(
                child: Text(
                  'Adicionar',
                  style: TextStyle(
                      color: Color(0xFF1BD09A),
                      fontSize: 14,
                      fontWeight: FontWeight.w800),
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4), color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  TextEditingController cupomInputController = new TextEditingController();
  TextEditingController cpfInputController = new TextEditingController();
  Card cardAddress(address, index, indexSelected) {
    return Card(
        elevation: index == indexSelected ? 0.0 : 1.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: index == indexSelected
              ? BorderSide(
                  color: Color(0xFFFF805D),
                  width: 0.7,
                )
              : BorderSide(color: Color(0x00), width: 0),
        ),
        child: GestureDetector(
          onTap: () {
            setState(() {
              selectedAddress = index;
            });
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.3,
            padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
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
        ));
  }

  GestureDetector addAddressButton() {
    return GestureDetector(
        onTap: () {},
        child: Container(
          width: 65,
          height: 65,
          alignment: Alignment.center,
          child: Icon(
            Icons.add,
            color: Colors.black,
          ),
          decoration: BoxDecoration(
              color: Color(0xFFEDF1F7),
              borderRadius: BorderRadius.circular(15)),
        ));
  }

  TextFormField cupomInput() {
    return TextFormField(
      controller: cupomInputController,
      validator: (value) => value.isEmpty ? 'Digite o cupom de desconto' : null,
      decoration: InputDecoration(
          fillColor: Color(0xFFEDF1F7),
          filled: true,
          suffixIcon: new Container(
            padding: EdgeInsets.only(right: 5),
            child: GestureDetector(
              onTap: () {
                setState(() {});
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFF1BD09A),
                    borderRadius: BorderRadius.circular(15)),
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(25.0, 20.0, 30.0, 20.0),
          hintText: "Insira o cupom",
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: Color(0xFFEDF1F7))),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color(0xFFFF805D), width: 2.0),
          )),
    );
  }

  ListView listAddress(addButton, listAdrresses) {
    List<Widget> childs = [];
    childs.add(Container(
      padding: EdgeInsets.fromLTRB(10, 10, 15, 10),
      child: Align(
        alignment: Alignment.topLeft,
        child: addButton,
      ),
    ));
    for (int i = 0; i < addresses.length; i++) {
      var address = addresses[i];
      print(address);
      childs.add(Container(
          padding: EdgeInsets.all(10),
          child: Align(
            alignment: Alignment.topCenter,
            child: cardAddress(address, i, selectedAddress),
          )));
    }
    return ListView(
      scrollDirection: Axis.horizontal,
      children: childs,
    );
  }

  double totalPrice = 0;
  Container finalPrice(items, deliveryPrice) {
    double productsPrice = 0;
    for (var item in items) {
      productsPrice += item.getFinalPrice();
    }
    totalPrice = productsPrice + deliveryPrice;

    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  "Subtotal",
                  style: TextStyle(fontSize: 16, color: Color(0Xff413131)),
                ),
              ),
              Spacer(),
              Text(
                "R\$ " +
                    (productsPrice / 100)
                        .toStringAsFixed(2)
                        .replaceAll('.', ','),
                style: TextStyle(
                  color: Color(0xFF413131),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  "Taxa de entrega",
                  style: TextStyle(fontSize: 16, color: Color(0Xff413131)),
                ),
              ),
              Spacer(),
              Text(
                "R\$ " +
                    (deliveryPrice / 100)
                        .toStringAsFixed(2)
                        .replaceAll('.', ','),
                style: TextStyle(
                  color: Color(0xFF413131),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  "Total",
                  style: TextStyle(
                      fontSize: 18,
                      color: Color(0XffFF805D),
                      fontWeight: FontWeight.w800),
                ),
              ),
              Spacer(),
              Text(
                "R\$ " +
                    (totalPrice / 100).toStringAsFixed(2).replaceAll('.', ','),
                style: TextStyle(
                    color: Color(0xFFFF805D),
                    fontSize: 18,
                    fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String dropDownValue = '';
  Container dropDownCreditCard(options) {
    return Container(
        decoration: BoxDecoration(
            color: Color(0xFFEDF1F7), borderRadius: BorderRadius.circular(12)),
        child: Container(
            padding: EdgeInsets.all(5),
            child: new Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Color(0xFFEDF1F7),
                ),
                child: DropdownButton(
                  underline: SizedBox(),
                  value: dropDownValue == '' ? null : dropDownValue,
                  isExpanded: false,
                  hint: Text("Informe a bandeira do cartão"),
                  onChanged: (newValue) {
                    setState(() {
                      dropDownValue = newValue;
                    });
                  },
                  items: options.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: EdgeInsets.only(left:10,right:10),
                          child: Text(value)),
                    );
                  }).toList(),
                ))));
  }

  AnimatedContainer cardmethod(indexCard) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 700),
        curve: Curves.easeInOutBack,
        height: 105,
        child: GestureDetector(
            onTap: () {
              setState(() {
                selectedPayment = indexCard;
                dropDownValue = '';
              });
            },
            child: Column(children: <Widget>[
              Card(
                elevation: indexCard == selectedPayment ? 0 : 1.5,
                shape: indexCard == selectedPayment
                    ? RoundedRectangleBorder(
                        side: BorderSide(
                          color: Color(0xffFF805D),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Color(0x00), width: 0)),
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Row(children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "Cartão pelo app",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xff413131),
                                    fontWeight: FontWeight.w800),
                              )),
                          Container(
                              padding: EdgeInsets.all(10),
                              child: Row(children: <Widget>[
                                Icon(Icons.credit_card),
                                Text(
                                  "**** **** **** 5285",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff413131),
                                      fontWeight: FontWeight.w300),
                                )
                              ])),
                        ],
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Center(
                          child: Text(
                            "Alterar",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ])),
              ),
            ])));
  }

  AnimatedContainer method(paymentMethod, indexCard) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 700),
        curve: Curves.easeInOutBack,
        height: indexCard == selectedPayment ? 161 : 100,
        child: GestureDetector(
            onTap: () {
              setState(() {
                selectedPayment = indexCard;
                dropDownValue = '';
              });
            },
            child: Column(children: <Widget>[
              Card(
                elevation: indexCard == selectedPayment ? 0 : 1.5,
                shape: indexCard == selectedPayment
                    ? RoundedRectangleBorder(
                        side: BorderSide(
                          color: Color(0xffFF805D),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Color(0x00), width: 0)),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            paymentMethod.name,
                            style: TextStyle(
                                fontSize: 18,
                                color: Color(0xff413131),
                                fontWeight: FontWeight.w800),
                          )),
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            paymentMethod.description,
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff413131),
                                fontWeight: FontWeight.w300),
                          )),
                    ],
                  ),
                ),
              ),
              indexCard == selectedPayment
                  ? Center(
                      child: Container(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
                      child: dropDownCreditCard(flagOptions),
                    ))
                  : Container(),
            ])));
  }

  Column allPaymentList() {
    List<Widget> cardList = [];
    cardList.add(cardmethod(0));
    for (int i = 0; i < paymentMethods.length; i++) {
      cardList.add(Center(child: method(paymentMethods[i], i + 1)));
    }
    return Column(children: cardList);
  }

  TextFormField cpfInput() {
    return TextFormField(
      controller: cpfInputController,
      validator: (value) => value.isEmpty ? 'Digite sua senha' : null,
      decoration: InputDecoration(
          fillColor: Color(0xFFEDF1F7),
          filled: true,
          suffixIcon: new Container(
            padding: EdgeInsets.only(right: 5),
            child: GestureDetector(
              onTap: () {
                setState(() {});
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFF1BD09A),
                    borderRadius: BorderRadius.circular(15)),
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(25.0, 20.0, 30.0, 20.0),
          hintText: "Informe o CPF ou CNPJ",
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: Color(0xFFEDF1F7))),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color(0xFFFF805D), width: 2.0),
          )),
    );
  }

  ScrollController _scrollController = new ScrollController();
  AnimatedContainer errorButton() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //Para animar o botão crescendo pra cima, ao invés de pra baixo, eu rolo o listView até o final
      _scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    });

    return AnimatedContainer(
      curve: Curves.easeInOutBack,
      duration: Duration(milliseconds: 700),
      height: !creditCardError ? 0 : MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0XffFA5C5C),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32), topRight: Radius.circular(32)),
      ),
      child: Container(
          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Container(
                      child: Text(
                    "Parece que algo deu errado e não \n conseguimos validar seu cartão de crédito.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w800),
                  )),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      items.clear();
                      creditCardError = false;
                      remove("cartItems");
                      loaded = false;
                    });

                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Menu()));
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 55,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Cadastrar novo cartão",
                          style: TextStyle(
                              color: Color(0xFF413131),
                              fontSize: 16,
                              fontWeight: FontWeight.w800),
                        ),
                      )),
                )
              ])),
    );
  }

  AnimatedContainer finishButton() {
    return AnimatedContainer(
        curve: Curves.easeInOutBack,
        duration: Duration(milliseconds: 700),
        height: creditCardError ? 0 : MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color(0Xff1BD09A),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32), topRight: Radius.circular(32)),
        ),
        child: GestureDetector(
          onTap: () {
            dropDownValue == ''
                ? setState(() {
                    creditCardError = true;
                  })
                : print('oi');
          },
          child: Center(
            child: Container(
              padding: EdgeInsets.only(bottom: 15),
              child: Text(
                "R\$" +
                    (totalPrice / 100).toStringAsFixed(2).replaceAll('.', ',') +
                    " Confirmar pedido",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ));
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
        duration: Duration(milliseconds: 1200),
        child: Container(
          padding: EdgeInsets.only(top: 10),
          child: SingleChildScrollView(
            reverse: true,
            controller: _scrollController,
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
                      children: items
                          .map((item) => cardItemContainer(item))
                          .toList()),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: addAnotherProduct(),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "🛵 Endereço de entrega",
                      style: TextStyle(
                          color: Color(0xFF413131),
                          fontSize: 16,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: listAddress(addAddressButton(), addresses),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "🤑 Cupom de desconto",
                      style: TextStyle(
                          color: Color(0xFF413131),
                          fontSize: 16,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: cupomInput(),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "😎 Pagamento",
                      style: TextStyle(
                          color: Color(0xFF413131),
                          fontSize: 16,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  finalPrice(items, 1000),
                  allPaymentList(),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "📝 CPF ou CNPJ na nota fiscal",
                      style: TextStyle(
                          color: Color(0xFF413131),
                          fontSize: 16,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 50),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: cpfInput(),
                    ),
                  ),
                  creditCardError ? errorButton() : finishButton(),
                ]),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      backgroundColor: Color(0xFF1BD09A),
      body: new Stack(fit: StackFit.expand, children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.1, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Pedido de",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              Text(
                name,
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w800),
              )
            ],
          ),
        ),
        Align(alignment: Alignment.bottomCenter, child: cardCart()),
      ]),
    );
  }
}
