import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AlertBox extends StatelessWidget {
  AlertBox({@required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(message),
    );
  }
}
