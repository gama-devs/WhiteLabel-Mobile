import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whitelabel/src/pages/Coupom/coupom.dart';
import 'package:http/http.dart' as http;

class RegisterCoupom extends StatefulWidget {
  @override
  _RegisterCoupomState createState() => new _RegisterCoupomState();
}

class _RegisterCoupomState extends State<RegisterCoupom> {
  bool cupomClicked = false;
  bool foundCoupom = false;
  Size displaySize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  double displayHeight(BuildContext context) {
    return displaySize(context).height;
  }

  double displayWidth(BuildContext context) {
    return displaySize(context).width;
  }

  TextEditingController cupomInputController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    TextFormField cupomInput() {
      return TextFormField(
        controller: cupomInputController,
        validator: (value) => value.isEmpty ? 'Digite o codigo do Cupom' : null,
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
            hintText: "Código",
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(color: Color(0xFFEDF1F7))),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide:
                  const BorderSide(color: Color(0xFFFF805D), width: 2.0),
            )),
      );
    }

    AnimatedContainer successRegistration = new AnimatedContainer(
      curve: Curves.easeInOutBack,
      duration: Duration(milliseconds: 850),
      height: cupomClicked ? 185 : 40,
      decoration: BoxDecoration(
          color: !foundCoupom ? Color(0XFFFF5755) : Color(0XFF1BD09A),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32), topRight: Radius.circular(32))),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(padding: EdgeInsets.only(top:5),child:!foundCoupom
            ? Text(
                "Infelizmente o cupom não é valido!",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800),
              )
            : Text(
                "Cupom adicionado com sucesso",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800),
              ),
      )),
    );
    GestureDetector returnButton = new GestureDetector(
      onTap: () {
        print("oi");
        setState(() {
          cupomClicked = false;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Coupom()));
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
      onTap: () {
        print("Cadastrar");
        if (cupomInputController.text == 'valido') {
          setState(() {
            cupomClicked = true;
            foundCoupom = true;
          });
        } else if (cupomInputController.text == '') {
          setState(() {
            cupomClicked = false;
          });
        } else {
          setState(() {
            cupomClicked = true;
            foundCoupom = false;
          });
        }
      },
      child: Container(
        height: 125,
        width: displayWidth(context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32), topRight: Radius.circular(32)),
          color: Color(0xFFFF805D),
        ),
        child: Center(
          child: Text("Cadastrar",
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
                        "Cadastrar cupom",
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
                child: SingleChildScrollView(
                    child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            'assets/mulhercelular.png',
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 0.5,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Text(
                              "Aqueles descontos\nque dão água na boca",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xFFFF805D),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(
                              "Informe o código\ndo cupom de desconto",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF413131),
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: cupomInput(),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        height: 195,
                        child: Stack(
                          children: <Widget>[
                            successRegistration,
                            cadastrarCupomButton,
                          ],
                          alignment: Alignment.bottomCenter,
                        ))
                  ],
                )),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
