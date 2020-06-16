import 'package:flutter/material.dart';

import 'package:sout_development/forms/input.dart';
import 'package:sout_development/forms/button.dart';
import 'package:sout_development/forms/google_button.dart';

import 'package:provider/provider.dart';
import 'package:sout_development/providers/auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final String fontFamily = 'HelveticaNeue';
  final List<Input> loginfields = [
    Input(placeholder: 'Email', type: 'email', label: 'Email'),
    Input(placeholder: 'Password', type: 'password', label: 'Password')
  ];

  Widget returnFields() {
    return new Column(children: loginfields.map((item) => item).toList());
  }

  @override
  Widget build(BuildContext context) {
    final curScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Material(
        child: SingleChildScrollView(
      child: ChangeNotifierProvider(
          create: (context) => Auth(),
          child: Center(
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
                          returnFields(),
                          SizedBox(height: 15),
                          Center(
                            child: Button(description: 'LOGIN'),
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
                        ],
                      ),
                    ))),
          )),
    ));
  }
}
