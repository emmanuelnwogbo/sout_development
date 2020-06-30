import 'package:flutter/foundation.dart';

class User {
  User(
      {@required this.uid,
      @required this.email,
      @required this.displayname,
      this.lat,
      this.long,
      @required this.isEmailVerified});

  final String uid;
  final String email;
  final String displayname;
  final double lat;
  final double long;
  final bool isEmailVerified;
}