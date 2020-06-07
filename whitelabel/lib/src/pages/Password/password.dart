import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whitelabel/src/pages/Login/login.dart';

class Password extends StatefulWidget {
  @override
  _PasswordState createState() => new _PasswordState();
}

class _PasswordState extends State<Password> {
  var tolken;
getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('tolken_code');
    tolken = token;
  }
  //Abrindo o bottomSheet ao iniciar a tela
  @override
  void initState() {
    super.initState();
    getToken();}
  bool isPassword = true;
  bool isSuccesfull = false;
  bool hide = false;
var maskFormatter = new MaskTextInputFormatter(mask: '#####-####', filter: { "#": RegExp(r'[0-9]') });
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    Container textCadastro = Container(
      width: 270,
      child: Text(
        'Você acessou sua conta com uma senha provisória.',
        style: TextStyle(
            color: Color(
              0xFFFF805D,
            ),
            fontSize: 20,
            height: 1.2,
            fontWeight: FontWeight.w700),
        textAlign: TextAlign.center,
      ),
    );

    Container textInstruction1 = Container(
      width: 270,
      child: Text(
        'Informe seu celular cadastrado\n para enviarmos uma senha provisória',
        style: TextStyle(
            color: Color(
              0xFF413131,
            ),
            fontSize: 14,
            fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );

    Container textInstruction2 = Container(
      width: 270,
      child: Text(
        'Para sua maior segurança,                                    cadastre uma nova senha.',
        style: TextStyle(
            color: Color(
              0xFF413131,
            ),
            fontSize: 16,
            fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );

    Container textInstruction3 = Container(
      width: 270,
      child: Text(
        'Desejo cadastrar depois',
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: Color(
            0xFF413131,
          ),
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );

    GestureDetector returnButton = GestureDetector(
      onTap: () {
        if (isSuccesfull)
          setState(() {
            isPassword = false;
            isSuccesfull = false;
          });
        else if (!isPassword)
          setState(() {
            isPassword = true;
            isSuccesfull = false;
          });
      },
      child: 
       new GestureDetector(
            onTap: () {
             Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Login()
        ));
            },
            child:
      Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child:
         Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        decoration: BoxDecoration(
            color: Color(0xFFFF805D), borderRadius: BorderRadius.circular(12)),
      ),)
    );

    Container textPassword = Container(
      width: 270,
      child: Text(
        'Esqueceu sua senha?\nNão tem problema!',
        style: TextStyle(
            color: Color(
              0xFFFF805D,
            ),
            fontSize: 22,
            height: 1.2,
            fontWeight: FontWeight.w700),
        textAlign: TextAlign.center,
      ),
    );

    Container textNewPassword = Container(
      width: 270,
      child: Text(
        'Nova Senha cadastrada com sucesso!',
        style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            height: 1,
            fontWeight: FontWeight.w700),
        textAlign: TextAlign.center,
      ),
    );

    Container emoji = Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 15),
          child: Text(
            '🔒',
            style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                height: 1,
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ));

    TextFormField celInput = TextFormField(
      validator: (value) => value.isEmpty ? 'Digite seu celular' : null,
         inputFormatters: [maskFormatter],
      decoration: InputDecoration(
          fillColor: Color(0xFFEDF1F7),
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(25.0, 20.0, 30.0, 20.0),
          hintText: "Seu número de celular",
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(
                color: Color(0xFFEDF1F7),
              )),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color(0xFFFF805D), width: 2.0),
          )),
    );
    TextFormField senhaInput = TextFormField(
      validator: (value) => value.isEmpty ? 'Digite sua senha' : null,
      obscureText: hide ? true : false,
      decoration: InputDecoration(
          fillColor: Color(0xFFEDF1F7),
          filled: true,
          suffixIcon: new GestureDetector(
            onTap: () {
              setState(() {
                hide = !hide;
              });
            },
            child:
                hide ? Icon(Icons.visibility_off) : Icon(Icons.remove_red_eye),
          ),
          contentPadding: EdgeInsets.fromLTRB(25.0, 20.0, 30.0, 20.0),
          hintText: "Nova Senha",
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: Color(0xFFEDF1F7))),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color(0xFFFF805D), width: 2.0),
          )),
    );

    Material bottomButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      color: Color(0xFFFF805D),
      child: MaterialButton(
        minWidth: double.infinity,
        padding: EdgeInsets.fromLTRB(40.0, 40, 40.0, 40.0),
        onPressed: () {
          print(tolken);
          if (isPassword)
            setState(() {
              isPassword = false;
              isSuccesfull = false;
            });
          else
            setState(() {
              isPassword = false;
              isSuccesfull = true;
            });
        },
        child: Text(isPassword ? "Enviar" : "Cadastrar",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
      ),
    );

    Card passwordChangeCard = Card(
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
          width: double.infinity,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 30),
                  child: Column(
                    children: <Widget>[
                      textCadastro,
                      SizedBox(
                        height: 15,
                      ),
                      textInstruction2,
                      SizedBox(
                        height: 20,
                      ),
                      senhaInput,
                      SizedBox(
                        height: 20,
                      ),
                      textInstruction3,
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                bottomButton,
              ])),
    );

    Card passwordForgottenCard = Card(
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30, top: 30),
              child: Column(
                children: <Widget>[
                  textPassword,
                  SizedBox(
                    height: 30,
                  ),
                  textInstruction1,
                  SizedBox(
                    height: 30,
                  ),
                  celInput,
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Spacer(),
            bottomButton,
          ])),
    );

    Card passwordSuccesfulCard = Card(
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
          color: Color(0xFF1BD09A),
          width: MediaQuery.of(context).size.width,
          child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30, top: 30),
              child: Column(
                children: <Widget>[
                  textNewPassword,
                  SizedBox(
                    height: 30,
                  ),
                  emoji,
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
            Spacer(),
          ])),
    );

    return Scaffold(
      body: new Stack(fit: StackFit.expand, children: <Widget>[
        Container(
            height: MediaQuery.of(context).size.height,
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage("assets/bg.png"), fit: BoxFit.cover)),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 40),
                    child: returnButton,
                  ),
                  Spacer(),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 700),
                    height: MediaQuery.of(context).viewInsets.bottom != 0 ? 380 : isSuccesfull ? 200 : 400,
                    curve: Curves.easeInOutBack,
                    child: isPassword
                        ? passwordForgottenCard
                        : isSuccesfull
                            ? passwordSuccesfulCard
                            : passwordChangeCard,
                  ),
                ])),
      ]),
    );
  }
}
