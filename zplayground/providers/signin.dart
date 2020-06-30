import 'package:flutter/foundation.dart';

class SignInForm with ChangeNotifier {

  String _email = '';
  String _password = '';

  setEmail(email) {
    _email = email;
    notifyListeners();
  }

  String get emailValue {
    return _email;
  }

  void setPassword(password) {
    _password = password;
    notifyListeners();
  }

  String get passwordValue {
    return _password;
  }
}