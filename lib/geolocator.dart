import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:android_intent/android_intent.dart';

import 'package:flutter_sms/flutter_sms.dart';

class GeolocatorView extends StatefulWidget {
  final bool realTimeLocation;
  final bool sosLocationSms;

  GeolocatorView(
      {@required this.realTimeLocation, @required this.sosLocationSms});

  @override
  _GeolocatorViewState createState() => _GeolocatorViewState();
}

class _GeolocatorViewState extends State<GeolocatorView> {
  List<String> circle = ['08033426880', '08157472838', '08121144100'];
  String _message;
  String _position;

  void _sendSMS(List<String> recipents, String body) async {
    try {
      String _result = await sendSMS(message: body, recipients: recipents);
      setState(() => _message = _result);
    } catch (error) {
      setState(() => _message = error.toString());
    }
  }

  Future _getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _position = '$position';
    });

    final bool realTimeLOcation = widget.realTimeLocation;
    final bool sosLocationSms = widget.sosLocationSms;
    debugPrint('$realTimeLOcation, $sosLocationSms');

    print(realTimeLOcation);
    print(sosLocationSms);

    if (sosLocationSms) {
      _sendSMS(circle, _position);
    }

    print(position);
  }
  /*
  Future _gpsService() async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
      if (!(await Geolocator().isLocationServiceEnabled())) {
        print('please enable geolocation');
      }

      return null;
    } else
      return true;
  }*/

  @override
  void initState() {
    _getLocation();
    //_gpsService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
