import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:http/http.dart' as http;
import 'package:whitelabel/src/pages/CEP/cep.dart';
import 'package:whitelabel/src/pages/Login/login.dart';

class AddressFields{
  String name;
  String description;
  String cep;

  AddressFields({this.name,this.description});
}

class Address extends StatefulWidget {
  @override
  _AddressState createState() => new _AddressState();
}

class _AddressState extends State<Address> {

  String nameAddress = '';
  String descriptionAddress = '';
  String cepAdress = '';
  Size displaySize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  double displayHeight(BuildContext context) {
    return displaySize(context).height;
  }

  double displayWidth(BuildContext context) {
    return displaySize(context).width;
  }

  bool isSwitched = true,
      isValid = false,
      isInvalid = false,
      check = false,
      escolha = false;
  List <AddressFields> listAdrreses = [];
  String value = "";
  String texto = "";
  var arr = [];
  String description = ' ',
      str = '',
      fullresp = '',
      numero = '',
      complement = 'Apto 1',
      lat = '',
      long = '',
      zip_code = '',
      address = '',
      fullobj = ' ';

  var _textController = new TextEditingController();

  void initState() {
    _textController.addListener(() {
      //here you have the changes of your textfield
      print("value: ${_textController.text}");
      texto = Uri.encodeFull(_textController.text);
      print(texto);
      
      //use setState to rebuild the widget
      setState(() {
        getData(context);
      });
    });
    super.initState();
  }

  Future getData(BuildContext context) async {
    try {
      http.Response response = await http.get(
        Uri.encodeFull("https://api.mapbox.com/geocoding/v5/mapbox.places/" +
            texto +
            ".json?bbox=-73,-33,-34.0,5.5&access_token=pk.eyJ1IjoiZGVsaXZlcnlhZSIsImEiOiJja2F3eHlnZ2IwMDB3MnBudzV3OGx3eDA5In0.42k6GoeW3xZIySLKeBx22Q"),
        headers: {
          "Accept": "application/json",
        },
      );
      Map<String,dynamic> jsonData = json.decode(response.body);
      List<dynamic> data = jsonData['features'];
      for (int i=0;i<5 || i<data.length;i++){
        listAdrreses.add(AddressFields(name: data[i]['text'],description: data[i]['place_name']));
      }
    } catch (e) {
      print(e);
    }
  }

  Widget Descricao() {
    return (Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 0.0, bottom: 40)),
        new GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            /*    Timer(
                Duration(seconds: 0),
                () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => Cep()))); */
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: displayWidth(context) * 0.2,
            child: Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFFFF805D),
                )),
          ),
        ),
        AnimatedContainer(
            duration: Duration(milliseconds: 300),
            decoration: BoxDecoration(
                color: Color(0xFFEDF1F7),
                borderRadius: BorderRadius.all(Radius.circular(12))),
            width: displayWidth(context) * 0.7,
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xFFFF805D),
                  ),
                  border: InputBorder.none,
                  hintText: "Digite o endereço",
                  hintStyle: TextStyle(
                      color: Color(0xFF413131),
                      fontSize: 16,
                      fontWeight: FontWeight.normal)),
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Color(0xFF413131),
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
              onChanged: (text) {
                value = text;
              },
            )),
      ],
    ));
  }

  Widget Number() {
    return (Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: displayWidth(context) * 0.9,
          child: Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text('Por gentileza, informe o número.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    ));
  }

  Widget NumberTextField() {
    return (Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: displayWidth(context) * 0.9,
          height: 55,
          decoration: BoxDecoration(
              color: Color(0xFFEDF1F7),
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Padding(
            padding: EdgeInsets.only(left: 15.0, top: 5.0),
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Número",
                  hintStyle: TextStyle(
                      color: Color(0xFF413131),
                      fontSize: 16,
                      fontWeight: FontWeight.normal)),
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Color(0xFF413131),
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
              onChanged: (text) {
                value = text;
              },
            ),
          ),
        ),
      ],
    ));
  }

  Widget NumberButton() {
    return (Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 40.0, top: 15.0),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: displayWidth(context) * 0.75,
            height: displayHeight(context) * 0.08,
            child: Text('Endereço sem número',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal)),
          ),
        ),
        Checkbox(
          value: check,
          onChanged: (check) {
            setState(() {
              check = !check;
            });
          },
        ),
      ],
    ));
  }

  Widget Continue() {
    return (Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: displayWidth(context) * 0.9,
                height: displayHeight(context) * 0.08,
                child: FlatButton(
                  color: Colors.white,
                  onPressed: () {
                    print('oi');
                  },
                  child: Text('Desejo acessar mesmo assim',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.white,
                          width: 1,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(20)),
                )),
            Container(
                width: displayWidth(context) * 0.9,
                child: FlatButton(
                  onPressed: () {
                    print('oi');
                  },
                  child: Text('Utilizar outro endereço de entrega.',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                  textColor: Colors.white,
                )),
          ],
        ),
      ],
    ));
  }

  Widget Item(name,description,cep) {
    print(name);
    print(description);
    print(cep);
    return (Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 15.0, right: 20),
                child: Icon(Icons.location_on))
          ],
        ),
        new GestureDetector(
          onTap: () {
            setState(() {
              nameAddress = name;
              descriptionAddress = description;
              escolha = true;
            });
          },
          child: Column(
            children:[
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: displayWidth(context) * 0.75,
                  child: Text(name,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.normal)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 0.0),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: displayWidth(context) * 0.75,
                  child: Text(description,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.normal)),
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }

  Widget Card() {
    return (Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.bounceInOut,
              decoration: BoxDecoration(
                  color: isInvalid ? Color(0xFFFA5C5C) : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0),
                  )),
              width: displayWidth(context),
              height: isInvalid
                  ? displayHeight(context) * 0.35
                  : displayHeight(context) * 0.66,
              child: SingleChildScrollView(child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 43.0)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: displayWidth(context) * 0.9,
                        child: Text(
                          isInvalid
                              ? 'Ah, que pena.\nAinda não atendemos sua região.'
                              : isValid
                                  ? 'Que tal já salvar o endereço\n para suas compras?'
                                  : 'Informe o CEP de entrega.',
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            fontSize: 19.0,
                            fontWeight: FontWeight.bold,
                            color: isInvalid ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  isInvalid
                      ? SizedBox.shrink()
                      : Padding(padding: EdgeInsets.only(top: 43.0)),
                  isInvalid
                      ? SizedBox.shrink()
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: displayWidth(context) * 0.9,
                              child: Text(
                                nameAddress,
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFFFF805D),
                                ),
                              ),
                            ),
                          ],
                        ),
                  isInvalid
                      ? SizedBox.shrink()
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: displayWidth(context) * 0.9,
                              child: Text(
                                descriptionAddress,
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFFFF805D),
                                ),
                              ),
                            ),
                          ],
                        ),
                  isInvalid
                      ? SizedBox.shrink()
                      : Padding(padding: EdgeInsets.only(top: 43.0)),
                  isInvalid
                      ? SizedBox.shrink()
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: displayWidth(context) * 0.8,
                              height: 55,
                              decoration: BoxDecoration(
                                  color: Color(0xFFEDF1F7),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: Padding(
                                padding: EdgeInsets.only(left: 15.0, top: 5.0),
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Complemento(caso tenha)",
                                      hintStyle: TextStyle(
                                          color: Color(0xFF413131),
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal)),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color(0xFF413131),
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                  onChanged: (text) {
                                    value = text;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                  isInvalid
                      ? SizedBox.shrink()
                      : Padding(padding: EdgeInsets.only(top: 13.0)),
                  isInvalid
                      ? SizedBox.shrink()
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFFEDF1F7),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              width: displayWidth(context) * 0.8,
                              height: 55,
                              child: Padding(
                                padding: EdgeInsets.only(left: 15.0, top: 5.0),
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Nome do endereço (ex.casa)",
                                      hintStyle: TextStyle(
                                          color: Color(0xFF413131),
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal)),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color(0xFF413131),
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                  onChanged: (text) {
                                    value = text;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                  isInvalid
                      ? Padding(padding: EdgeInsets.only(top: 21.0))
                      : Padding(padding: EdgeInsets.only(top: 13.0)),
                  isInvalid
                      ? Continue()
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                  bottom: 20.0, left: 30, right: 30),
                              child: Container(
                                  width: displayWidth(context) * 0.8,
                                  height: displayHeight(context) * 0.08,
                                  child: FlatButton(
                                    color: Color(0xFFFF805D),
                                    onPressed: () {
                                      print('oi');
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  Login()));
                                    },
                                    child: Text('Salvar',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700)),
                                    textColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Color(0xFFFF805D),
                                            width: 1,
                                            style: BorderStyle.solid),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  )),
                            )
                          ],
                        ),
                  isInvalid
                      ? SizedBox.shrink()
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                  bottom: 70.0, left: 30, right: 30),
                              child: Container(
                                  width: displayWidth(context) * 0.8,
                                  height: displayHeight(context) * 0.03,
                                  child: FlatButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      print('oi');
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  Login()));
                                    },
                                    child: Text('Não, obrigado.',
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                    textColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.white,
                                            width: 1,
                                            style: BorderStyle.solid),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  )),
                            )
                          ],
                        )
                ],
              ),),
            ),
          ],
        )));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:
          isInvalid ? Colors.white : isValid ? Color(0xFF1BD09A) : Colors.white,
      body: new Stack(fit: StackFit.expand, children: <Widget>[
        isValid
            ? Positioned.fill(
                child: Card(),
              )
            : new Positioned(
                child: new Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                      padding:
                          EdgeInsets.only(bottom: 70.0, left: 30, right: 30),
                      child: Container(
                          width: displayWidth(context) * 0.8,
                          height: displayHeight(context) * 0.08,
                          child: FlatButton(
                            color: Color(0xFFFF805D),
                            onPressed: () {
                              print('oi');
                              setState(() {
                                isValid = true;
                              });
                            },
                            child: Text('Confirmar',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700)),
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Color(0xFFFF805D),
                                    width: 1,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(20)),
                          )),
                    )),
              ),
        Column(
          children: <Widget>[
            Container(
              height: 50,
            ),
            !isValid
                ? SizedBox.shrink()
                : Container(
                    height: 20,
                  ),
            !isValid
                ? SizedBox.shrink()
                : Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: EdgeInsets.only(top: 14),
                      child: Text(
                        '🛵',
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    )),
            !isValid
                ? SizedBox.shrink()
                : Container(
                    width: 300,
                    child: Padding(
                      padding: EdgeInsets.only(top: 14),
                      child: Text(
                        'Maravilha!\n Nós atendemos sua região',
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                          fontSize: 19.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )),
            isValid ? SizedBox.shrink() : Descricao(),
            Container(
              height: 50,
            ),
            escolha == false && isValid == false && isInvalid == false
                ? SizedBox.shrink()
                : isValid ? SizedBox.shrink() : Number(),
            escolha == false && isValid == false && isInvalid == false ? Column(
              children: listAdrreses.length > 0 ? listAdrreses
          .map((produto) => Item(produto.name,produto.description,produto.cep))
          .toList(): [SizedBox.shrink()],
            ): SizedBox.shrink(),
            Container(
              height: 50,
            ),
            escolha == false
                ? SizedBox.shrink()
                : isValid ? SizedBox.shrink() : NumberTextField(),
            Container(
              height: 20,
            ),
            escolha == false
                ? SizedBox.shrink()
                : isValid ? SizedBox.shrink() : NumberButton(),
          ],
        ),
      ]),);
  }
}
