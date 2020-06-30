import 'package:flutter/material.dart';
import 'package:sout_development/onboarding.dart';
import 'dart:async';

const timeout = const Duration(seconds: 3);
const ms = const Duration(milliseconds: 1);

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void handleTimeout() {
      Navigator.of(context).pushReplacement(_createRoute());
    }

    startTimeout([int milliseconds]) {
      var duration = milliseconds == null ? timeout : ms * milliseconds;
      return new Timer(duration, handleTimeout);
    }

    startTimeout();
    return Center(
        child: Container(
          color: Theme.of(context).primaryColor,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Center(
        child: Image.asset(
          "assets/logo.png",
          height: 300,
          width: 200,
          fit: BoxFit.cover,
        ),
      ),
    ));
  }
}

Route _createRoute() {
  return PageRouteBuilder (pageBuilder: (context, animation, secondaryAnimation) => Onboarding());
}
