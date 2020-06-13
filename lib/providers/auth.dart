import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:email_validator/email_validator.dart';

class User {
  User({@required this.uid});
  final String uid;
}

class Auth with ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }

    print(user);
    _validating = false;
    _authUser = user;
    _isLoggedIn = true;
    
    notifyListeners();

    return User(uid: user.uid);
  }

  String _name;
  String _email;
  String _password;
  String _confirmpassword;
  bool _submit = false;
  String _type;
  bool _emailIsValid = false;
  bool _validating = false;
  FirebaseUser _authUser;
  bool _isLoggedIn = false;
  bool _initGoogleSignIn = false;

  String get name {
    return _name;
  }

  String get email {
    return _email;
  }

  String get password {
    return _password;
  }

  String get confirmpassword {
    return _confirmpassword;
  }

  bool get submit {
    return _submit;
  }

  bool get validating {
    return _validating;
  }

  String get type {
    return _type;
  }

  FirebaseUser get getUser {
    return _authUser;
  }

  bool get emailIsValid {
    return _emailIsValid;
  }

  bool get isLoggedIn {
    return _isLoggedIn;
  }

  bool get googleSignIn {
    return _initGoogleSignIn;
  }

  Future<User> createUserWithEmailAndPassword(email, password) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  void addName(name) {
    _name = name;
    notifyListeners();
  }

  void addEmail(email) {
    _email = email;

    final bool isValid = EmailValidator.validate(_email);

    isValid ? _emailIsValid = true : _emailIsValid = false;

    notifyListeners();
  }

  void addPassword(password) {
    _password = password;
    notifyListeners();
  }

  void addConfirmpassword(confirmpassword) {
    _confirmpassword = confirmpassword;
    notifyListeners();
  }

  void initGoogleSignIn() {
    _initGoogleSignIn = true;
    notifyListeners();
  }

  void triggerSubmit(value, type) {
    //type means sign up or login
    _submit = submit;
    _type = type;
    _validating = true;
    notifyListeners();

    if (type == 'SIGN UP') {
      createUserWithEmailAndPassword(_email, _password);
    }
  }
}
