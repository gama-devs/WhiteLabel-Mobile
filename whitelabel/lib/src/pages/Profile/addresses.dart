import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:whitelabel/src/pages/Orders/cart.dart';

class ProfileAddress extends StatefulWidget {
  @override
  _ProfileAddressState createState() => new _ProfileAddressState();
}

Address enderecoTeste = Address(
    name: "Casa",
    description:
        "R. Álvares Machado, 187,Petrópolis, Porto Alegre/RS\n CEP: 94252-652");
int selectedAddress = 0;
List<Address> addresses = [
  enderecoTeste,
  Address(
      name: "Trabalho",
      description:
          "R. Álvares Machado, 187,Petrópolis, Porto Alegre/RS\n CEP: 94252-652")
];

class _ProfileAddressState extends State<ProfileAddress> {
  bool ativosSelected = true;
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
    Card cardSelectedAddress(address) {
      return Card(
          elevation: 1.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Color(0x00), width: 0),
          ),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
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

    GestureDetector returnButton = new GestureDetector(
      onTap: () {
        print("oi");
      },
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: Icon(
          Icons.arrow_back_ios,
          color: Color(0xFFFF805D),
        ),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
      ),
    );
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    GestureDetector cadastrarCupomButton = new GestureDetector(
      child: Container(
        height: 125,
        width: displayWidth(context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32), topRight: Radius.circular(32)),
          color: Color(0xFFFF805D),
        ),
        child: Center(
          child: Text("Cadastrar cupom",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 20)),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
      body: new Stack(fit: StackFit.expand, children: <Widget>[
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(20),
                child: Row(
                  children: <Widget>[
                    returnButton,
                    Spacer(),
                    Container(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.1),
                      child: Text(
                        "Endereços",
                        style: TextStyle(
                            color: Color(0xFFFF805D),
                            fontSize: 22,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    Spacer()
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32)),
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Column(children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: cardSelectedAddress(addresses[selectedAddress]),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: listAddress(addAddressButton(), addresses),
                        ),
                      ]),
                    ),
                    Spacer(),
                    cadastrarCupomButton
                  ],
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
