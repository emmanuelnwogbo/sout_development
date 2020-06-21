import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:provider/provider.dart';
import 'package:sout_development/providers/auth.dart';
import 'package:sout_development/providers/signup.dart';
import 'package:sout_development/providers/signin.dart';
import 'package:string_validator/string_validator.dart';

import 'package:sout_development/authenticated/dashboard.dart';

class Button extends StatelessWidget {
  Button({@required this.description});

  final String description;
  final String fontFamily = 'HelveticaNeue';

  @override
  Widget build(BuildContext context) {
    final curScaleFactor = MediaQuery.of(context).textScaleFactor;
    final auth = Provider.of<Auth>(context);
    final signupform = Provider.of<SignUpForm>(context);
    final signinform = Provider.of<SignInForm>(context);

    bool isValidSignUp = signupform.fullnameValue.isNotEmpty &&
        signupform.passwordValue.isNotEmpty &&
        signupform.passwordValue.length >= 6 &&
        signupform.passwordValue.isNotEmpty &&
        signupform.confirmpasswordValue.length >= 6 &&
        signupform.emailValue.isNotEmpty &&
        isEmail(signupform.emailValue) &&
        equals(signupform.passwordValue, signupform.confirmpasswordValue);

    bool isValidSignIn = isEmail(signinform.emailValue) &&
        signinform.passwordValue.isNotEmpty &&
        signinform.passwordValue.length >= 6;

    if (auth.isAuthenticated) {
      print('just got logged in now');
      Navigator.pushReplacementNamed(context, '/dashboard');
    }

    return description == 'SIGN UP'
        ? ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: Container(
              width: 190,
              height: 55,
              child: FlatButton(
                child: auth.isValidating
                    ? CircularProgressIndicator()
                    : Text(description,
                        style: TextStyle(
                          fontSize: 18.0 * curScaleFactor,
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        )),
                onPressed: () {
                  if (isValidSignUp) {
                    auth.setValidating(true);
                    auth.createUserWithEmailAndPassword(
                        signupform.emailValue, signupform.passwordValue);
                  }
                },
                color: !isValidSignUp
                    ? Color(0xFF3edd9c).withOpacity(.4)
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
                child: auth.isValidating
                    ? CircularProgressIndicator()
                    : Text(description,
                        style: TextStyle(
                          fontSize: 18.0 * curScaleFactor,
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        )),
                onPressed: () {
                  if (isValidSignIn) {
                    auth.setValidating(true);
                    auth.signInWithEmailAndPassword(
                        signinform.emailValue, signinform.passwordValue);
                  }
                },
                color: !isValidSignIn
                    ? Color(0xFF3edd9c).withOpacity(.4)
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
