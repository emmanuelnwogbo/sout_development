import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:sout_development/splash.dart';
import 'package:sout_development/router.dart';
import 'package:sout_development/authenticated/dashboard.dart';

import 'package:provider/provider.dart';
import 'package:sout_development/providers/auth.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void _setTargetPlatformForDesktop() {
  TargetPlatform targetPlatform;
  if (Platform.isMacOS) {
    targetPlatform = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    targetPlatform = TargetPlatform.android;
  }
  if (targetPlatform != null) {
    debugDefaultTargetPlatformOverride = targetPlatform;
  }
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) _setTargetPlatformForDesktop();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => Auth(),
        child: MaterialApp(
          title: 'Flutter Demo',
          onGenerateRoute: Router.generateRoute,
          initialRoute: '/',
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Helvetica',
            primarySwatch: createMaterialColor(Color(0xFF3edd9c)),
            primaryColor: createMaterialColor(Color(0xFF3edd9c)),
            accentColor: Color(0xFFecf0f1),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          //home: MyHomePage(),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    //print(credential);
  }

  void signOutGoogle() async {}

  void initState() {
    super.initState();
    //signInWithGoogle();
  }

  //void _incrementCounter() {}

  @override
  Widget build(BuildContext context) {
    bool dev = false;
    final auth = Provider.of<Auth>(context);

    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).accentColor,
              child: auth.isLoggedIn
                  ? Dashboard()
                  : Splash())), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
