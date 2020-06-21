import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:provider/provider.dart';
import 'package:sout_development/providers/auth.dart';
import 'package:sout_development/providers/signup.dart';
import 'package:sout_development/providers/signin.dart';

class Input extends StatefulWidget {
  Input(
      {@required this.placeholder,
      @required this.type,
      @required this.label,
      @required this.authType});

  final String placeholder;
  final String type;
  final String label;
  final String email = 'email';
  final String authType;

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  final _inputControl = TextEditingController();
  final String fontFamily = 'HelveticaNeue';
  String _value;
  FocusNode _focus = new FocusNode();

  bool error = false;

  @override
  Widget build(BuildContext context) {
    final curScaleFactor = MediaQuery.of(context).textScaleFactor;

    final auth = Provider.of<Auth>(context);
    final signupform = Provider.of<SignUpForm>(context);
    final signinform = Provider.of<SignInForm>(context);

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
              onTap: () {},
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    top: 1.0,
                    left: 4.0,
                    bottom: _focus.hasFocus || _value != null ? null : 1.0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                    child: Center(
                        child: Padding(
                            padding: EdgeInsets.only(
                              left: 10.0,
                              top: _focus.hasFocus || _value != null ? 5.0 : 0,
                            ),
                            child: Text(widget.placeholder,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: fontFamily,
                                  letterSpacing: .8,
                                  color: Colors.black.withOpacity(.2),
                                  fontSize: _focus.hasFocus || _value != null
                                      ? 12 * curScaleFactor
                                      : 15 * curScaleFactor,
                                )))),
                  ),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(.3),
                      child: Container(
                          height: MediaQuery.of(context).size.width * 0.14,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                            ),
                            //color: Color(0xFFBFBFBF),
                          ),
                          child: Center(
                              child: TextField(
                            onChanged: (value) {
                              setState(() {
                                _value = value;
                              });

                              if (widget.authType == 'signup') {
                                if (widget.placeholder == 'Email') {
                                  signupform.setEmail(_value);
                                }

                                if (widget.placeholder == 'Full Name') {
                                  signupform.setFullname(_value);
                                }

                                if (widget.placeholder == 'Password') {
                                  signupform.setPassword(_value);
                                }

                                if (widget.placeholder == 'Confirm Password') {
                                  signupform.setConfirmPassword(_value);
                                }
                              }

                              if (widget.authType == 'login') {
                                print('hello from login' + _value.toString());
                                widget.placeholder == 'Email'
                                    ? signinform.setEmail(_value)
                                    : signinform.setPassword(_value);
                              }
                            },
                            controller: _inputControl,
                            focusNode: _focus,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 14, bottom: 0, top: 11, right: 15),
                            ),
                            //controller: _amountController,
                            keyboardType: widget.placeholder == 'Password' ||
                                    widget.placeholder == 'Confirm Password'
                                ? TextInputType.text
                                : TextInputType.emailAddress,
                            obscureText: widget.placeholder == 'Password' ||
                                    widget.placeholder == 'Confirm Password'
                                ? true
                                : false,
                            //onSubmitted: (_) => _submitData(),
                          ))))
                ],
              )),
          SizedBox(
              //height: 15.0,
              //height: 0,
              ),
          error
              ? Padding(
                  padding: EdgeInsets.only(top: 0, left: 15.0, bottom: 0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(_value != null ? '' : '',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.red,
                        )),
                  ))
              : SizedBox(
                  height: widget.placeholder == 'Confirm Password' ? 5 : 15,
                ),
          widget.placeholder == 'Confirm Password'
              ? Text(
                  "Password must be at least 8 characters with numbers or symbols.",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.black.withOpacity(.5),
                      fontSize: 11.0 * curScaleFactor,
                      fontFamily: fontFamily))
              : SizedBox(
                  height: 0,
                )
        ],
      ),
    );
  }
}
