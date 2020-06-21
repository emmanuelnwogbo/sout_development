import 'package:flutter/material.dart';

import 'package:sout_development/authenticated/header.dart';
import 'package:provider/provider.dart';
import 'package:sout_development/providers/auth.dart';

import 'package:sout_development/geolocator.dart';

import 'package:geolocator/geolocator.dart';
import 'package:share/share.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool sos = false;
  List<String> _recepients = ['08157472838', '08121144100'];
  String _message;
  String _position;
  bool _allowshareLocation = false;
  bool _allowTextSos = false;

  Future<void> _createDynamicLink(bool short, Position position) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://sout.page.link',
      link: Uri.parse('http://www.google.com/maps/place/' +
          position.latitude.toString() +
          ',' +
          position.longitude.toString()),
      androidParameters: AndroidParameters(
        packageName: 'io.flutter.plugins.firebasedynamiclinksexample',
        minimumVersion: 0,
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.google.FirebaseCppDynamicLinksTestApp.dev',
        minimumVersion: '0',
      ),
    );

    Uri _url;
    final ShortDynamicLink shortLink = await parameters.buildShortLink();
    _url = shortLink.shortUrl;

    if (_allowshareLocation) {
      _shareLocation(
          'Treat as urgent! If you are getting this I need your help. See my location here: ' +
              _url.toString());

      setState(() {
        _allowshareLocation = false;
      });
    }

    if (_allowTextSos) {
      _sendSMS(
          _recepients,
          'Treat as urgent! If you are getting this I need your help. See my location here: ' +
              _url.toString());

    setState(() {
        _allowshareLocation = false;
      });
    }
  }

  Future _shareLocation(message) async {
    final RenderBox box = context.findRenderObject();
    Share.share(message,
        subject: 'this is my location,',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

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

    _createDynamicLink(true, position);
  }

  @override
  Widget build(BuildContext context) {
    final curScaleFactor = MediaQuery.of(context).textScaleFactor;
    final auth = Provider.of<Auth>(context);

    //print(auth.name.toString() + 'this is the name');

    return Material(
      child: SingleChildScrollView(
        child: Container(
            child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Color(0xFFecf0f1),
                child: Center(
                    child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 15,
                      right: 20.0,
                      left: 20.0,
                      bottom: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Header(true),
                      SizedBox(
                        height: 10.0,
                      ),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Container(
                              height: MediaQuery.of(context).size.height / 2.5,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 5,
                                      blurRadius: 3,
                                      offset: Offset(0, 1),
                                    )
                                  ]),
                              child: Stack(
                                children: <Widget>[
                                  FlatButton(
                                      onPressed: () {
                                        setState(() {
                                          _allowTextSos = true;
                                        });

                                        if (_allowTextSos) {
                                          _getLocation();
                                        }
                                      },
                                      child: AspectRatio(
                                          aspectRatio: 18.0 / 17.0,
                                          child: Image(
                                              image: AssetImage(
                                                "assets/caution.png",
                                              ),
                                              fit: BoxFit.cover))),
                                ],
                              ))),
                      Padding(
                          padding: EdgeInsets.only(
                              top: 18.0, left: 23.0, right: 23.0),
                          child: Center(
                              child: Column(
                            children: <Widget>[
                              sos
                                  ? GeolocatorView(
                                      realTimeLocation: true,
                                      sosLocationSms: true)
                                  : Container(),
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 60,
                                    child: FlatButton(
                                      child: Text('My Circle',
                                          style: TextStyle(
                                            fontSize: 20,
                                          )),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/mycircle');
                                      },
                                      color: Color(0xFF3edd9c),
                                      textColor: Colors.white,
                                      padding: EdgeInsets.all(8.0),
                                    ),
                                  )),
                              SizedBox(height: 23.0),
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 60,
                                    child: FlatButton(
                                      child: Text('Share my location',
                                          style: TextStyle(
                                            fontSize: 20,
                                          )),
                                      onPressed: () {
                                        setState(() {
                                          _allowshareLocation = true;
                                        });

                                        if (_allowshareLocation) {
                                          _getLocation();
                                        }
                                      },
                                      color: Color(0xFF3edd9c),
                                      textColor: Colors.white,
                                      padding: EdgeInsets.all(8.0),
                                    ),
                                  )),
                              SizedBox(height: 23.0),
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 60,
                                    child: FlatButton(
                                      child: Text('Emergency services',
                                          style: TextStyle(
                                            fontSize: 20,
                                          )),
                                      onPressed: () {},
                                      color: Color(0xFF3edd9c),
                                      textColor: Colors.white,
                                      padding: EdgeInsets.all(8.0),
                                    ),
                                  ))
                            ],
                          ))),
                    ],
                  ),
                ))),
          ],
        )),
      ),
    );
  }
}
