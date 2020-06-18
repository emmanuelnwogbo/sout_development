import 'dart:async';
import 'package:flutter/foundation.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:email_validator/email_validator.dart';

class User {
  User(
      {@required this.uid,
      @required this.email,
      @required this.fullname,
      this.lat,
      this.long,
      @required this.isEmailVerified});

  final String uid;
  final String email;
  final String fullname;
  final double lat;
  final double long;
  final bool isEmailVerified;
}

class Auth with ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;

  FirebaseUser _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }

    //print(user.email);

    _validating = false;
    _authUser = user;
    _isLoggedIn = true;
    _isAuthenticated = true;
    notifyListeners();

    if (_type != 'LOGIN') {
      addUser(user.uid, _name, user.email);
      notifyListeners();
    }

    return user;
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
  bool _isAuthenticated = false;

  String get name {
    return _name = '';
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

  bool get isAuthenticated {
    return _isAuthenticated;
  }

  Future<FirebaseUser> createUserWithEmailAndPassword(email, password) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  Future<FirebaseUser> signInWithEmailAndPassword(email, password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  Future addUser(String id, String fullname, String email) async {
    Firestore.instance
        .collection('users')
        .add({'email': email, 'fullname': fullname, 'id': id});
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

    if (type == 'LOGIN') {
      signInWithEmailAndPassword(_email, _password);
    }
  }
}
