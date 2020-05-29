import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {

  bool isLogin = true;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    Container textCadastro = Container(
      width: 270,
      child: Text(
        'Vamos criar sua conta? É rápido! Igual nossa entrega.',
        style: TextStyle(
            color: Color(
              0xFFFF805D,
            ),
            fontSize: 20,
            height: 1.2,
            fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );

    Container textInstruction = Container(
      width: 270,
      child: Text(
        'Preencha os dados abaixo e enviariamos uma confirmação via SMS.',
        style: TextStyle(
          color: Color(
            0xFF413131,
          ),
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      ),
    );

    GestureDetector returnButton = GestureDetector(
      onTap: (){
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 700),
        curve:Curves.fastOutSlowIn,
        width: isLogin? 0 :40,
        height: isLogin? 0:40,
        alignment: isLogin? Alignment.centerRight:Alignment.center,
        child: isLogin? Container() : Icon(Icons.arrow_back_ios,color: Colors.white,),
        decoration: BoxDecoration(
          color: isLogin? Color(0x00FF805D): Color(0xFFFF805D),
          borderRadius: BorderRadius.circular(10)
        ),),
    );

    Container textLogin = Container(
      width: 270,
      child: Text(
        'Realize seu login e aproveite nosso Aplicativo.',
        style: TextStyle(
            color: Color(
              0xFFFF805D,
            ),
            fontSize: 22,
            height: 1.2,
            fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );

    TextFormField celInput = TextFormField(
      validator: (value) => value.isEmpty ? 'Digite seu celular' : null,
      decoration: InputDecoration(
          fillColor: Color(0xFFEDF1F7),
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(25.0, 10.0, 30.0, 10.0),
          hintText: "Celular",
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
      decoration: InputDecoration(
          fillColor: Color(0xFFEDF1F7),
          filled: true,
          suffixIcon: Icon(Icons.remove_red_eye),
          contentPadding: EdgeInsets.fromLTRB(25.0, 10.0, 30.0, 10.0),
          hintText: "Senha",
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: Color(0xFFEDF1F7))),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color(0xFFFF805D), width: 2.0),
          )),
    );

    Container textForgetPassword = Container(
      child: Text(
        'Esqueci minha senha',
        style: TextStyle(
          color: Color(
            0xFF413131,
          ),
          fontSize: 13,
          height: 1.2,
        ),
        textAlign: TextAlign.center,
      ),
    );

    Container textCreateAccount = Container(
        child: GestureDetector(
      onTap: () {
        print(isLogin);
        setState(() {
          isLogin = false;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Ainda não tem conta?',
            style: TextStyle(color: Color(0xFFFF805D), fontSize: 14),
          ),
          Text(
            'Crie agora mesmo!',
            style: TextStyle(
                color: Color(0xFFFF805D),
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ));
    TextFormField emailInput = TextFormField(
      validator: (value) => value.isEmpty ? 'Digite seu e-mail' : null,
      decoration: InputDecoration(
          fillColor: Color(0xFFEDF1F7),
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(25.0, 10.0, 30.0, 10.0),
          hintText: "Seu e-mail",
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

    TextFormField nameInput = TextFormField(
      validator: (value) => value.isEmpty ? 'Digite seu nome' : null,
      decoration: InputDecoration(
          fillColor: Color(0xFFEDF1F7),
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(25.0, 10.0, 30.0, 10.0),
          hintText: "Seu nome",
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

    Material bottomButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      color: Color(0xFFFF805D),
      child: MaterialButton(
        minWidth: double.infinity,
        padding: EdgeInsets.fromLTRB(40.0, 40, 40.0, 40.0),
        onPressed: () {
          setState(() {
            isLogin = !isLogin;
          });
        },
        child: Text(isLogin ? "Entrar" : "Cadastrar",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16)),
      ),
    );

    Card cadastroCard = Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
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
                    height: 13,
                  ),
                  textInstruction,
                  SizedBox(
                    height: 13,
                  ),
                  celInput,
                  SizedBox(
                    height: 10,
                  ),
                  emailInput,
                  SizedBox(
                    height: 10,
                  ),
                  nameInput,
                  SizedBox(
                    height: 10,
                  ),
                  senhaInput,
                  SizedBox(
                    height: 5,
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

    Card loginCard = Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30, top: 30),
              child: Column(
                children: <Widget>[
                  textLogin,
                  SizedBox(
                    height: 10,
                  ),
                  celInput,
                  SizedBox(
                    height: 10,
                  ),
                  senhaInput,
                  SizedBox(
                    height: 5,
                  ),
                  Row(children: <Widget>[Spacer(), textForgetPassword]),
                  SizedBox(
                    height: 15,
                  ),
                  textCreateAccount,
                ],
              ),
            ),
            Spacer(),
            bottomButton,
          ])),
    );


    return Scaffold(
      body: new Stack(fit: StackFit.expand, children: <Widget>[
        SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: new AssetImage("assets/backgroundpizza.png"),
                      fit: BoxFit.cover)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left:20,top:40),child: returnButton,),
                    Spacer(),
                    AnimatedContainer(
                        duration: Duration(milliseconds: 700),
                        height: isLogin ? 400 : 490,
                        curve: Curves.easeInOutBack,
                        child: isLogin ? loginCard : cadastroCard),
                  ])),
        )
      ]),
    );
  }
}
