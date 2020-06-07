import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:whitelabel/src/pages/Login/login.dart';
import 'package:whitelabel/src/pages/Onboarding/Onboarding.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (c, a1, a2) => Onboarding(),
                transitionsBuilder: (c, anim, a2, child) =>
                    FadeTransition(opacity: anim, child: child),
                transitionDuration: Duration(milliseconds: 500),
              ),
            ));
  }

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      body: new Stack(fit: StackFit.expand, children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: new BoxDecoration(
              image: new DecorationImage(
                  image: new AssetImage("assets/Splash.png"),
                  fit: BoxFit.cover)),
        ),
      ]),
    );
  }
}
