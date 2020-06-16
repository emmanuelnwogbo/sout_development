import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:provider/provider.dart';
import 'package:sout_development/providers/auth.dart';

import 'package:sout_development/authenticated/dashboard.dart';

import 'package:sout_development/main.dart';

class Button extends StatelessWidget {
  Button({@required this.description});

  final String description;
  final String fontFamily = 'HelveticaNeue';

  @override
  Widget build(BuildContext context) {
    final curScaleFactor = MediaQuery.of(context).textScaleFactor;
    final auth = Provider.of<Auth>(context);

    bool isInvalidSignUp = !auth.emailIsValid ||
        auth.name == null ||
        auth.password == null ||
        auth.confirmpassword == null ||
        auth.password != null && auth.password.length < 6 ||
        auth.confirmpassword != null && auth.confirmpassword.length < 6;

    bool isInvalidLogin = !auth.emailIsValid && auth.password == null ||
        auth.password != null && auth.password.length < 6;

    if (auth.isLoggedIn) {
      Future.delayed(const Duration(milliseconds: 100), () {
        Navigator.pushReplacementNamed(context, '/dashboard');
      });
    }

    return description == 'SIGN UP'
        ? ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: Container(
              width: 190,
              height: 55,
              child: FlatButton(
                child: auth.validating
                    ? CircularProgressIndicator()
                    : Text(description,
                        style: TextStyle(
                          fontSize: 18.0 * curScaleFactor,
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        )),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/dashboard');
                  /*if (isInvalidSignUp) {
                    return;
                  }

                  auth.triggerSubmit(true, description);*/
                },
                color: isInvalidSignUp
                    ? Color(0xFF3edd9c).withOpacity(.6)
                    : Color(0xFF3edd9c),
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
              ),
            ))
        : ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: Container(
              width: 190,
              height: 55,
              child: FlatButton(
                child: auth.validating
                    ? CircularProgressIndicator()
                    : Text(description,
                        style: TextStyle(
                          fontSize: 18.0 * curScaleFactor,
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        )),
                onPressed: () {
                  if (isInvalidLogin) {
                    return;
                  }

                  auth.triggerSubmit(true, description);
                },
                color: isInvalidLogin
                    ? Color(0xFF3edd9c).withOpacity(.6)
                    : Color(0xFF3edd9c),
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
              ),
            ));
  }
}

Route _createRoute() {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Dashboard());
}
