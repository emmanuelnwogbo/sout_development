import 'package:flutter/foundation.dart';

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