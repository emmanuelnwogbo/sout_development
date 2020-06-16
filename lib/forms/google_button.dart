import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sout_development/providers/auth.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Googlebtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    Future<void> signInWithGoogle() async {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      print(credential);
    }

    final curScaleFactor = MediaQuery.of(context).textScaleFactor;
    final String fontFamily = 'HelveticaNeue';
    final auth = Provider.of<Auth>(context);

    return ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: Container(
            width: 190,
            height: 55,
            child: OutlineButton(
                splashColor: Colors.grey,
                onPressed: () {
                  signInWithGoogle();
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                highlightElevation: 0,
                borderSide: BorderSide(color: Colors.grey),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 17,
                      width: 14,
                      child: Image(
                        image: AssetImage("assets/google_logo.png"),
                        fit: BoxFit.scaleDown
                      ),
                    ),
                    SizedBox(width: 7.0,),
                    Text(
                        'Sign in with Google',
                        style: TextStyle(
                            fontSize: 12.0 * curScaleFactor,
                            fontFamily: fontFamily,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            color: Colors.grey),
                      )
                  ],
                ))));
  }
}
