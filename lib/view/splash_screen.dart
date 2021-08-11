import 'dart:async';

import 'package:flutter/material.dart';
import '../resources/images.dart';
import '../route/route_manager.dart';


class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {

    Timer(const Duration(seconds: 2), () {
      _openHomePage();
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(Images.appIcon),
            fit: BoxFit.contain,
          ),
          gradient: LinearGradient(
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            colors: <Color>[
              Color(0xFF0556c1),
              Color(0xFF0e96e4),
            ],
            stops: [0.5, 0.0]
          ),
        ),
      ),
    );
  }


  void _openHomePage() {
    Navigator.pop(context);
    Navigator.of(context).pushNamed(RouteManager.HOME_PAGE_ROUTE);
  }
}