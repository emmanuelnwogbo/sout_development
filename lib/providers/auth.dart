import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sout_development/providers/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  String _id;
  String _token;
  bool _isAuthenticated = false;
  bool _isValidating = false;
  User _user;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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
    String displayname = '';
    user.displayName == null
        ? displayname = user.email
        : displayname = user.displayName;

    _user = new User(
        uid: user.uid,
        email: user.email,
        displayname: displayname,
        isEmailVerified: user.isEmailVerified);

    saveId(_user.uid, _user.email, _user.isEmailVerified, _user.displayname);

    setAuthentication(true);
    setValidating(false);
    notifyListeners();
  }

  User get user {
    return _user;
  }

  void saveId(id, email, isverified, name) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('soutuserid', id);
    prefs.setString('soutuseremail', email);
    prefs.setString('soutusername', name.toString());
    prefs.setString('soutuserverification', isverified.toString());
  }

  void retrieveuserdetails() async {
    final SharedPreferences prefs = await _prefs;
    String soutUserid = prefs.getString('soutuserid');
    String soutUseremail = prefs.getString('soutuseremail');
    String soutUserverifi = prefs.getString('soutuserverification');
    String soutUsername = prefs.getString('soutusername');

    if (soutUserid != null) {
      setUserFromLocal(soutUserid, soutUseremail, soutUserverifi, soutUsername);
      notifyListeners();
    }
  }

  void setUserFromLocal(id, email, isverified, name) {
    User user = new User(
        uid: id, email: email, displayname: name, isEmailVerified: isverified);
    setUser(user);
  }

  FirebaseUser _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }

    setUser(user);
    setId(user.uid);
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
