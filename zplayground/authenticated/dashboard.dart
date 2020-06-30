import 'package:flutter/material.dart';

import 'package:sout_development/authenticated/header.dart';
import 'package:provider/provider.dart';

import 'package:geolocator/geolocator.dart';
import 'package:share/share.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:sout_development/providers/geolocator.dart';
import 'package:sout_development/providers/contacts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<String> _recepients = [];
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> _createDynamicLinkAndSmsLocation(
      bool short, Position position) async {
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

    final SharedPreferences prefs = await _prefs;
    var contacts = prefs.getStringList('locallyStoredContacts');

    setState(() {
      contacts == null ? _recepients = [] : _recepients = contacts;
    });

    _sendSMS(
        _recepients,
        'Treat as urgent! If you are getting this I need your help. See my location here: ' +
            _url.toString());
  }

  Future<void> _createDynamicLinkAndShareLocation(
      bool short, Position position) async {
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

    _shareLocation(
        'Treat as urgent! If you are getting this I need your help. See my location here: ' +
            _url.toString());
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
    } catch (error) {}
  }

  Future<PermissionStatus> _requestPermissionContacts() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }

  Future<PermissionStatus> _getPermissionDataContacts() async {
    final PermissionStatus permissionStatus =
        await _requestPermissionContacts();
    //print(permissionStatus);
    return permissionStatus;
  }

  @override
  void initState() {
    _getPermissionDataContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final curScaleFactor = MediaQuery.of(context).textScaleFactor;
    final geolocation = Provider.of<GeolocationProvider>(context);
    final contactsProvider = Provider.of<ContactsProvider>(context);

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
                      GestureDetector(
                          onTap: () {
                            if (!geolocation.locationOn) {
                              geolocation.setLocation();
                            }

                            _createDynamicLinkAndSmsLocation(
                                true, geolocation.position);
                          },
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 2.5,
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
                                            _createDynamicLinkAndSmsLocation(
                                                true, geolocation.position);
                                          },
                                          child: AspectRatio(
                                              aspectRatio: 18.0 / 17.0,
                                              child: Image(
                                                  image: AssetImage(
                                                    "assets/caution.png",
                                                  ),
                                                  fit: BoxFit.cover))),
                                      Positioned(
                                        top: 10.0,
                                        left: 1.0,
                                        right: 1.0,
                                        child: Container(
                                            child: Center(
                                                child: Text('PANIC BUTTON',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        letterSpacing: .8,
                                                        color: Colors.black
                                                            .withOpacity(.6),
                                                        fontSize: 15.0 *
                                                            curScaleFactor,
                                                        fontWeight:
                                                            FontWeight.w300)))),
                                      )
                                    ],
                                  )))),
                      Padding(
                          padding: EdgeInsets.only(
                              top: 18.0, left: 23.0, right: 23.0),
                          child: Center(
                              child: Column(
                            children: <Widget>[
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
                              GestureDetector(
                                  onTap: () {
                                    if (!geolocation.locationOn) {
                                      geolocation.setLocation();
                                    }

                                    _createDynamicLinkAndShareLocation(
                                        true, geolocation.position);
                                  },
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 60,
                                        child: FlatButton(
                                          child: Text('Share my location',
                                              style: TextStyle(
                                                fontSize: 20,
                                              )),
                                          onPressed: () {
                                            _createDynamicLinkAndShareLocation(
                                                true, geolocation.position);
                                          },
                                          color: Color(0xFF3edd9c),
                                          textColor: Colors.white,
                                          padding: EdgeInsets.all(8.0),
                                        ),
                                      ))),
                              SizedBox(height: 23.0),
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
