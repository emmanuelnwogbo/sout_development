import 'package:flutter/material.dart';

import 'package:sout_development/forms/input.dart';
import 'package:sout_development/forms/button.dart';
import 'package:sout_development/forms/google_button.dart';

import 'package:provider/provider.dart';
import 'package:sout_development/providers/auth.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final String fontFamily = 'HelveticaNeue';

  final List<Input> signupfields = [
    Input(placeholder: 'Full Name', type: 'text', label: 'Full Name'),
    Input(placeholder: 'Email', type: 'email', label: 'Email'),
    Input(placeholder: 'Password', type: 'password', label: 'Password'),
    Input(
        placeholder: 'Confirm Password',
        type: 'password',
        label: 'Confirm Password'),
  ];

  List values = [];

  Widget returnFields() {
    return new Column(children: signupfields.map((item) => item).toList());
  }

  @override
  Widget build(BuildContext context) {
    final curScaleFactor = MediaQuery.of(context).textScaleFactor;

    return ChangeNotifierProvider(
        create: (context) => Auth(),
        child: Scaffold(
            body: Material(
                child: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                  padding: EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                  ),
                  child: Form(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Let's get started!",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 35.0 * curScaleFactor,
                                fontFamily: fontFamily)),
                        SizedBox(
                          height: 12.0,
                        ),
                        Text(
                          "You're just a few steps away from experiencing SOUT.",
                          style: TextStyle(
                              color: Colors.black.withOpacity(.5),
                              fontSize: 14.0 * curScaleFactor),
                        ),
                        Text(
                          "Create your account first:",
                          style: TextStyle(
                              color: Colors.black.withOpacity(.5),
                              fontSize: 15.0 * curScaleFactor),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        returnFields(),
                        SizedBox(height: 15),
                        Center(
                          child: Button(description: 'SIGN UP'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Center(
                              child: Text('or',
                                  style: TextStyle(
                                      fontSize: 20.0 * curScaleFactor,
                                      fontFamily: fontFamily,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.5,
                                      color: Colors.black38))),
                        ),
                        Center(child: Googlebtn()),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                            "By submitting this form, you agree to our terms of service and privacy policy.",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.black.withOpacity(.5),
                                fontSize: 11.0 * curScaleFactor,
                                fontFamily: fontFamily))
                      ],
                    ),
                  ))),
        ))));
  }
}
