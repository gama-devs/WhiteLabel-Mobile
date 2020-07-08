import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whitelabel/src/pages/Coupom/registerCoupom.dart';
import 'package:http/http.dart' as http;

class Coupom extends StatefulWidget {
  @override
  _CoupomState createState() => new _CoupomState();
}

class _CoupomState extends State<Coupom> {
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
    GestureDetector ativosButton = new GestureDetector(
      onTap: () {
        print("oi");
        setState(() {
          ativosSelected = true;
        });
      },
      child: Container(
        height: displayHeight(context) * 0.07,
        width: displayWidth(context) * 0.4,
        decoration: BoxDecoration(
            color: ativosSelected ? Color(0xFFFF805D) : Color(0x7FFF805D),
            borderRadius: BorderRadius.circular(32)),
        child: Center(
          child: Text(
            "Ativos",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );

    GestureDetector indisponiveisButton = new GestureDetector(
      onTap: () {
        print("oi");
        setState(() {
          ativosSelected = false;
        });
      },
      child: Container(
        height: displayHeight(context) * 0.07,
        width: displayWidth(context) * 0.4,
        decoration: BoxDecoration(
            color: !ativosSelected ? Color(0xFFFF805D) : Color(0x7FFF805D),
            borderRadius: BorderRadius.circular(32)),
        child: Center(
          child: Text(
            "Indisponiveis",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );

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
      onTap: () {
        print("Cadastrar cupom");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => RegisterCoupom()));
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
                        "Cupons",
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
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              ativosButton,
                              indisponiveisButton
                            ],
                          ),
                        ],
                      ),
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
