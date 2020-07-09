import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:whitelabel/src/pages/CEP/cep.dart';
import 'package:whitelabel/src/pages/Menu/categoryAll.dart';
import 'package:whitelabel/src/pages/Menu/menu.dart';
import 'package:whitelabel/src/pages/Menu/principal.dart';
import 'package:whitelabel/src/pages/Login/login.dart';
import 'package:whitelabel/src/pages/Onboarding/Onboarding.dart';
import 'package:whitelabel/src/pages/Orders/cart.dart';
import 'package:whitelabel/src/pages/Profile/addresses.dart';
import 'package:whitelabel/src/pages/Splash/splash.dart';
import 'src/pages/Splash/splash.dart';

void main() {
  runApp(MaterialApp(
/*      home: Cep() */
      home: Splash()));
}