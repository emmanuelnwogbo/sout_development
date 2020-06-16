import 'package:flutter/material.dart';

import 'package:sout_development/splash.dart';
import 'package:sout_development/main.dart';
import 'package:sout_development/onboarding.dart';
import 'package:sout_development/forms/signup.dart';
import 'package:sout_development/forms/login.dart';
import 'package:sout_development/authenticated/dashboard.dart';
import 'package:sout_development/authenticated/mycircle.dart';
import 'package:sout_development/authenticated/contacts_view.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MyHomePage());
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => Onboarding());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignUp());
      case '/login':
        return MaterialPageRoute(builder: (_) => Login());
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => Dashboard());
      case '/mycircle':
        return MaterialPageRoute(builder: (_) => MyCircle());
      case '/contacts':
        return MaterialPageRoute(builder: (_) => ContactsView());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(),
                ));
      /*case '/dashboard':
        return MaterialPageRoute(builder: (_) => Dashboard());*/
      /*case '/':
        return MaterialPageRoute(builder: (_) => MyHomePage());
      case '/signup':
        return MaterialPageRoute(builder: (_) => Signup());
      case '/login':
        return MaterialPageRoute(builder: (_) => Login());
      case '/splash':
        return MaterialPageRoute(builder: (_) => Splash());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(),
                ));*/
    }
  }
}
