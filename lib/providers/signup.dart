import 'package:flutter/foundation.dart';

class SignUpForm with ChangeNotifier {

  String fullname = '';
  String email = '';
  String password = '';
  String confirmpassword = '';

  setFullname(_fullname) {
    fullname = _fullname;
    notifyListeners();
  }

  String get fullnameValue {
    return fullname;
  }

  setEmail(_email) {
    email = _email;
    notifyListeners();
  }

  String get emailValue {
    return email;
  }

  setPassword(_password) {
    password = _password;
    notifyListeners();
  }

  String get passwordValue {
    return password;
  }

  setConfirmPassword(_confirmpassword) {
    confirmpassword = _confirmpassword;
    notifyListeners();
  }

  String get confirmpasswordValue {
    return confirmpassword;
  }
}
