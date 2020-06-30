import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:sout_development/widgets/alert.dart';

import 'package:sout_development/data/onboarding_images.dart';

final String fontFamily = 'HelveticaNeue';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  List<Widget> indicators = new List();
  var currentPage = 0;
  bool alertWidget = false;
  String alertMessage = '';
  PermissionStatus _permissionStatus = PermissionStatus.undetermined;

  PageController controller =
      PageController(initialPage: 0, viewportFraction: 1);

  Future<PermissionStatus> _requestPermission() async {
    final PermissionStatus permission = await Permission.location.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.location].request();

      if (await Permission.location.request().isGranted) {
        print('this is granted permission here');
      } else {
        print('this is not granted permission here');
        setState(() {
          alertWidget = true;
          alertMessage =
              'are you sure? Sout needs your location to function properly';
        });
      }

      return permissionStatus[Permission.location] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }

  Future<PermissionStatus> _getPermissionData() async {
    final PermissionStatus permissionStatus = await _requestPermission();
    //print(permissionStatus);
    return permissionStatus;
  }

  @override
  void initState() {
    _getPermissionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Text('hello world'),
          alertWidget ? AlertBox(message: alertMessage) : Container(),
        ],
      ),
    ));
  }
}
