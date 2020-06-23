import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:http/http.dart' as http;
import 'package:whitelabel/src/pages/CEP/cep.dart';
import 'package:whitelabel/src/pages/Login/login.dart';

class AddressFields {
  String name;
  String description;
  String cep;

  AddressFields({this.name, this.description});
}

class Address extends StatefulWidget {
  final String value;
  Address({Key key, this.value}) : super(key: key);
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
  List<AddressFields> listAdrreses = [];
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
  bool rememberMe = false;

  void _onRememberMeChanged(bool newValue) => setState(() {
        rememberMe = newValue;

        if (rememberMe) {
          // TODO: Here goes your functionality that remembers the user.
        } else {
          // TODO: Forget the user
        }
      });

  var _textController = new TextEditingController();

  void initState() {
    _textController.addListener(() {
      //here you have the changes of your textfield
      texto = Uri.encodeFull(_textController.text);

      //use setState to rebuild the widget
      setState(() {
        getData(context);
      });
    });

    setState(() {
      _textController.text = widget.value;
      texto = Uri.encodeFull(_textController.text);
    });
    super.initState();
  }

  Future getData(BuildContext context) async {
    print(texto);
    try {
      http.Response response = await http.get(
        Uri.decodeFull("https://api.mapbox.com/geocoding/v5/mapbox.places/" +
            texto +
            ".json?bbox=-73,-33,-34.0,5.5&access_token=pk.eyJ1IjoiZGVsaXZlcnlhZSIsImEiOiJja2F3eHlnZ2IwMDB3MnBudzV3OGx3eDA5In0.42k6GoeW3xZIySLKeBx22Q"),
        headers: {
          "Accept": "application/json",
        },
      );
      Map<String, dynamic> jsonData = json.decode(response.body);
      List<dynamic> data = jsonData['features'];
      listAdrreses.clear();
      for (int i = 0; i < 5 && i < data.length; i++) {
        listAdrreses.add(AddressFields(
            name: data[i]['text'], description: data[i]['place_name']));
      }
    } catch (e) {
      print(e);
    }
  }

  Widget Descricao() {
    return (Container(
        color: Color(0xFFF8F6F8),
        height: MediaQuery.of(context).size.height * 0.2,
        child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 0, bottom: 40)),
                new GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    Timer(
                        Duration(seconds: 0),
                        () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (BuildContext context) => Cep())));
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: 40,
                    height: 40,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Color(0xFFFF805D),
                        )),
                  ),
                ),
                Spacer(),
                AnimatedContainer(
                    height: 50,
                    duration: Duration(milliseconds: 700),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    width: displayWidth(context) * 0.7,
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(
                                color: Color(0xFFF8F6F8),
                              )),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: Color(0xFFFF805D), width: 2.0),
                          ),
                          fillColor: Colors.white,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFFFF805D),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              _textController.clear();
                            },
                            icon: Icon(Icons.cancel),
                            color: Color(0xFF868484),
                          ),
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
            ))));
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
                    color: Color(0xFF413131),
                    fontSize: 19,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    ));
  }

  var numberController = new TextEditingController();
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
              controller: numberController,
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
          padding: EdgeInsets.only(left: 30.0, top: 15.0),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: displayWidth(context) * 0.75,
            height: displayHeight(context) * 0.08,
            child: Text('Endereço sem número',
                style: TextStyle(
                    color: Color(0xFF413131),
                    fontSize: 16,
                    fontWeight: FontWeight.normal)),
          ),
        ),
        Checkbox(
            activeColor: Color(0xFFFF805D),
            value: rememberMe,
            onChanged: _onRememberMeChanged),
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
                          color: Color(0xFF413131),
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

  Widget Item(name, description, cep) {
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
            FocusScope.of(context).unfocus();
            setState(() {
              nameAddress = name;
              descriptionAddress = description;
              escolha = true;
            });
          },
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: displayWidth(context) * 0.75,
                  child: Text(name,
                      style: TextStyle(
                          color: Color(0xFF413131),
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
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                  color: isInvalid ? Color(0xFFFA5C5C) : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0),
                  )),
              width: displayWidth(context),
              height: MediaQuery.of(context).viewInsets.bottom != 0
                  ? displayHeight(context) * 1
                  : isInvalid
                      ? displayHeight(context) * 0.35
                      : displayHeight(context) * 0.65,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: displayWidth(context) * 0.8,
                          
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
                              color:
                                  isInvalid ? Colors.white : Color(0xFF413131),
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
                                  padding:
                                      EdgeInsets.only(left: 15.0, top: 5.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Complemento (caso tenha)",
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
                                  padding:
                                      EdgeInsets.only(left: 15.0, top: 5.0),
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
                                    bottom: 10.0, left: 30, right: 30),
                                child: Container(
                                    width: displayWidth(context) * 0.8,
                                    height: displayHeight(context) * 0.08,
                                    child: FlatButton(
                                      color: Color(0xFFFF805D),
                                      onPressed: () {
                                        print('oi');
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
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
                                              BorderRadius.circular(12)),
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
                                                builder:
                                                    (BuildContext context) =>
                                                        Login()));
                                      },
                                      child: Text('Não, obrigado.',
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Color(0xFF413131),
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
                ),
              ),
            ),
          ],
        )));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: isInvalid
          ? Color(0xFFF8F6F8)
          : isValid ? Color(0xFF1BD09A) : Color(0xFFF8F6F8),
      body: new Stack(fit: StackFit.expand, children: <Widget>[
        Column(
          children: <Widget>[
            !isValid
                ? SizedBox.shrink()
                : Container(
                    height: 20,
                  ),
            MediaQuery.of(context).viewInsets.bottom != 0
                ? SizedBox.shrink()
                : !isValid
                    ? SizedBox.shrink()
                    : Container(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.05,
                            top: 20,
                            right: MediaQuery.of(context).size.width * 0.15),
                        child: Row(children: <Widget>[
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            width: 40,
                            height: 40,
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        escolha = false;
                                        isValid = false;
                                        isInvalid = false;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.arrow_back_ios,
                                      color: Color(0xFFFF805D),
                                    ))),
                          ),
                          Spacer(),
                          Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
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
                          Spacer(),
                        ])),
            MediaQuery.of(context).viewInsets.bottom != 0
                ? SizedBox.shrink()
                : !isValid
                    ? SizedBox.shrink()
                    : Container(
                        width: 300,
                        child: Padding(
                          padding: EdgeInsets.only(top: 34, bottom: 30,),
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
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32))),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 10,
                    ),
                    escolha == false && isValid == false && isInvalid == false
                        ? SizedBox.shrink()
                        : isValid ? SizedBox.shrink() : Number(),
                    escolha == false && isValid == false && isInvalid == false
                        ? Column(
                            children: listAdrreses.length > 0
                                ? listAdrreses
                                    .map((produto) => Item(produto.name,
                                        produto.description, produto.cep))
                                    .toList()
                                : [SizedBox.shrink()],
                          )
                        : SizedBox.shrink(),
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
                )),
          ],
        ),
        isValid
            ? Positioned.fill(
                child: Card(),
              )
            : escolha == false && isValid == false && isInvalid == false
                ? SizedBox.shrink()
                : isValid
                    ? SizedBox.shrink()
                    : new Positioned(
                        child: new Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Container(
                              padding: EdgeInsets.only(
                                  bottom: 70.0, left: 30, right: 30),
                              child: Container(
                                  width: displayWidth(context) * 0.8,
                                  height: displayHeight(context) * 0.08,
                                  child: FlatButton(
                                    disabledColor: Color(0x99FF805D),
                                    color: Color(0xFFFF805D),
                                    onPressed: !rememberMe &&
                                            numberController.text == ''
                                        ? null
                                        : () {
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
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  )),
                            )),
                      ),
      ]),
    );
  }
}