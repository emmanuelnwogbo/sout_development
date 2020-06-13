import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:provider/provider.dart';
import 'package:sout_development/providers/auth.dart';

import 'package:sout_development/authenticated/dashboard.dart';

class Button extends StatelessWidget {
  Button({@required this.description});

  final String description;
  final String fontFamily = 'HelveticaNeue';

  @override
  Widget build(BuildContext context) {
    final curScaleFactor = MediaQuery.of(context).textScaleFactor;

    final auth = Provider.of<Auth>(context);

    if (auth.isLoggedIn) {
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new Dashboard()));
    }

    return ClipRRect(
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
              /*Navigator.of(context)
                                            .push(_dashboardRoute());*/
              //Navigator.pushNamed(context, '/dashboard');
              if (!auth.emailIsValid) {
                return;
              }

              auth.triggerSubmit(true, description);
            },
            color: !auth.emailIsValid
                ? Color(0xFF3edd9c).withOpacity(.6)
                : Color(0xFF3edd9c),
            textColor: Colors.white,
            padding: EdgeInsets.all(8.0),
          ),
        ));
  }
}
