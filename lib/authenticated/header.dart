import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sout_development/providers/auth.dart';
import 'package:sout_development/providers/geolocator.dart';

import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Header extends StatefulWidget {
  Header(this.nameVisible);
  final bool nameVisible;

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool locationTracking = false;
  String username = '';

  final geolocator = Geolocator();
  final locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  Position _positionStream;

  Future getRealTimeLocation() async {
    StreamSubscription<Position> positionStream = geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      setState(() {
        _positionStream = position;
      });
    });
  }

  String truncateWithEllipsis(int cutoff, String myString) {
    if (myString == null) {
      return '';
    }

    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }

  @override
  void initState() {
    super.initState();
    getRealTimeLocation();

    setState(() {
      locationTracking = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final curScaleFactor = MediaQuery.of(context).textScaleFactor;
    final auth = Provider.of<Auth>(context);
    final geolocation = Provider.of<GeolocationProvider>(context);

    void getlocalid() async {
      final SharedPreferences prefs = await _prefs;
      String soutUserid = prefs.getString('soutuserid');
      String soutUsername = prefs.getString('soutusername');
      if (soutUserid != null) {
        setState(() {
          username = soutUsername;
        });
      }
    }

    if (auth.user == null) {
      getlocalid();
    }

    if (_positionStream != null) {
      geolocation.setPosition(_positionStream);
    }

    if (geolocation.locationOn) {
      setState(() {
        locationTracking = true;
      });
    } else {
      locationTracking = false;
    }

    return Container(
        height: MediaQuery.of(context).size.height / 12,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    auth.user == null
                        ? truncateWithEllipsis(4, username)
                        : truncateWithEllipsis(4, auth.user.displayname),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        letterSpacing: .8,
                        color: Colors.black.withOpacity(.7),
                        fontSize: 33.0 * curScaleFactor,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 1.2),
                widget.nameVisible
                    ? Text('',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            letterSpacing: .8,
                            color: Colors.black.withOpacity(.5),
                            fontSize: 10.0 * curScaleFactor,
                            fontWeight: FontWeight.bold))
                    : Text('')
              ],
            ),
            Container(
              width: 100.0,
              height: 50.0,
              //color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('My location',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          letterSpacing: .8,
                          color: Colors.black.withOpacity(.5),
                          fontSize: 10 * curScaleFactor,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 1.4),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Container(
                        height: 28.0,
                        width: 70.0,
                        color: Colors.white,
                        child: FlatButton(
                            onPressed: () {
                              geolocation.setLocation();
                            },
                            padding: EdgeInsets.all(0.0),
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                    top: 1.0,
                                    left: 12.0,
                                    right: 12.0,
                                    bottom: 1.0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        AnimatedOpacity(
                                            opacity: locationTracking ? 1 : 0,
                                            duration:
                                                Duration(milliseconds: 500),
                                            child: Text('ON')),
                                        AnimatedOpacity(
                                            opacity: locationTracking ? 0 : 1,
                                            duration:
                                                Duration(milliseconds: 500),
                                            child: Text('OFF'))
                                      ],
                                    )),
                                AnimatedPositioned(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease,
                                    top: 1.0,
                                    right: locationTracking ? 1.0 : 40.0,
                                    bottom: 1.0,
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        child: Container(
                                          width: 28.0,
                                          height: 28.0,
                                          child: FlatButton(
                                            child: Text(
                                              '',
                                            ),
                                            onPressed: () {
                                              geolocation.setLocation();
                                            },
                                            color: locationTracking
                                                ? Color(0xFF3edd9c)
                                                : Colors.red.withOpacity(.9),
                                            padding: EdgeInsets.all(8.0),
                                          ),
                                        )))
                              ],
                            )),
                      )),
                ],
              ),
            )
          ],
        ));
  }
}
