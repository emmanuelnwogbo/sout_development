import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:sout_development/onboarding.dart';
import 'package:sout_development/router.dart';

import 'package:provider/provider.dart';
import 'package:sout_development/providers/auth.dart';
import 'package:sout_development/providers/signup.dart';
import 'package:sout_development/providers/signin.dart';
import 'package:sout_development/providers/geolocator.dart';
import 'package:sout_development/providers/contacts.dart';

import 'package:shared_preferences/shared_preferences.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (context) => Auth(),
        ),
        ChangeNotifierProvider<GeolocationProvider>(
          create: (context) => GeolocationProvider(),
        ),
        ChangeNotifierProvider<ContactsProvider>(
          create: (context) => ContactsProvider(),
        ),
        ChangeNotifierProvider<SignUpForm>(
          create: (context) => SignUpForm(),
        ),
        ChangeNotifierProvider<SignInForm>(
          create: (context) => SignInForm(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        onGenerateRoute: Router.generateRoute,
        //initialRoute: '/',
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Helvetica',
          primarySwatch: createMaterialColor(Color(0xFF3edd9c)),
          primaryColor: createMaterialColor(Color(0xFF3edd9c)),
          accentColor: Color(0xFFecf0f1),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String _isAuthenticated;

  void retrieveuserdetails() async {
    final SharedPreferences prefs = await _prefs;
    String soutUserid = prefs.getString('soutuserid');

    if (soutUserid != null) {
      setState(() {
        _isAuthenticated = 'true';
      });
    } else {
      setState(() {
        _isAuthenticated = 'false';
      });
    }
  }

  void initState() {
    super.initState();
    retrieveuserdetails();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);

    if (_isAuthenticated == 'true') {
      auth.retrieveuserdetails();

      Future.delayed(const Duration(milliseconds: 1), () {
        Navigator.pushReplacementNamed(context, '/dashboard');
      });
    }

    return _isAuthenticated == 'true'
        ? Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor,
          )
        : Scaffold(
            body: SingleChildScrollView(
                child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).accentColor,
                    child: _isAuthenticated != null
                        ? Onboarding()
                        : Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            color: Theme.of(context).primaryColor,
                          ))), // This trailing comma makes auto-formatting nicer for build methods.
          );
  }
}
