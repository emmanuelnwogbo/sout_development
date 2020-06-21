import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sout_development/providers/models/user.dart';

class Auth with ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  String _id;
  String _token;
  bool _isAuthenticated = false;
  bool _isValidating = false;
  User _user;

  setId(id) {
    _id = id;
    notifyListeners();
  }

  String get id {
    return _id;
  }

  setToken(token) {
    _token = token;
    notifyListeners();
  }

  String get token {
    return _token;
  }

  setValidating(value) {
    _isValidating = value;
    notifyListeners();
  }

  bool get isValidating {
    return _isValidating;
  }

  setAuthentication(value) {
    _isAuthenticated = value;
    notifyListeners();
  }

  bool get isAuthenticated {
    return _isAuthenticated;
  }

  setUser(user) {
    _user = new User(
        uid: user.uid,
        email: user.email,
        fullname: user.displayName,
        isEmailVerified: user.isEmailVerified);

    setAuthentication(true);
    setValidating(false);
    notifyListeners();

    print(
        _user.fullname.toString() + 'this is a new user yo or not in the auth provider');
  }

  User get user {
    return _user;
  }

  FirebaseUser _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }

    setUser(user);
    notifyListeners();

    return user;
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
}
