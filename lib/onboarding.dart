import 'package:flutter/material.dart';
import 'package:sout_development/data/onboarding_images.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

final String fontFamily = 'HelveticaNeue';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<Widget> indicators = new List();
  Iterable<Contact> _contacts = [];
  List<String> addedNums = [];
  List<String> addedNamesState = [];
  var currentPage = 0;
  bool alertWidget = false;
  String alertMessage = '';

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
        _getPermissionDataContacts();
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

  Future<PermissionStatus> _requestPermissionContacts() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();

      if (await Permission.contacts.request().isGranted) {
        _getContacts();
      }

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

  Future<void> _getContacts() async {
    final Iterable<Contact> contactsList =
        (await ContactsService.getContacts()).toList();
    /*setState(() {
      _contacts = contactsList;
    });*/

    final SharedPreferences prefs = await _prefs;
    List<String> addedNumbs = [];
    List<String> addedNames = [];

    if (contactsList.isNotEmpty) {
      for (var i = 0; i < contactsList.length; i++) {
        var numbers = contactsList.elementAt(i).phones.toList();
        if (numbers.length > 0) {
          var contact = contactsList.elementAt(i).displayName.toString();
          //print(contact);
          addedNames.add(contact);
          numbers.forEach((number) {
            addedNumbs.add(number.value.toString() + '*' + contact);
          });
          print(addedNumbs);
          print(addedNames);
          /*setState(() {
            addedNums = addedNumbs;
            addedNamesState = addedNames;
          });*/

          prefs.setStringList('locallyStoredContacts', addedNumbs);
          prefs.setStringList('locallyStoredContactsVal', addedNames);
          var contacts = prefs.getStringList('locallyStoredContactsVal');
          var contacts2 = prefs.getStringList('locallyStoredContacts');
          print('========================================' + 'check it');

          print(contacts);
          print(contacts2);
        }
      }
    } else {
      prefs.setStringList('locallyStoredContacts', addedNumbs);
      prefs.setStringList('locallyStoredContactsVal', addedNames);
    }
  }

  @override
  void initState() {
    _getPermissionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      int next = controller.page.round();

      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });

    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height / 10),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.9,
              //color: Colors.red,
              child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: onboardimages.length,
                  controller: controller,
                  itemBuilder: (context, index) {
                    bool active = index == currentPage;
                    return Container(
                        //color: Colors.blue,
                        margin: EdgeInsets.only(left: 2.0, right: 2.0),
                        child: Center(
                          child: _animatedBox(active, context, index),
                        ));
                  }),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  Center(
                      child: Container(
                          width: MediaQuery.of(context).size.width / 7,
                          height: 20,
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.ease,
                                      height: 11.0,
                                      width: 10.0,
                                      color: currentPage == 0
                                          ? Color(0xFF3edd9c)
                                          : Color(0xFFecf0f1))),
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.ease,
                                      height: 11.0,
                                      width: 10.0,
                                      color: currentPage == 1
                                          ? Color(0xFF3edd9c)
                                          : Color(0xFFecf0f1))),
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.ease,
                                      height: 11.0,
                                      width: 10.0,
                                      color: currentPage == 2
                                          ? Color(0xFF3edd9c)
                                          : Color(0xFFecf0f1))),
                            ],
                          )))),
                  SizedBox(height: MediaQuery.of(context).size.height / 14),
                  Center(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        child: Container(
                          width: 190,
                          height: 55,
                          child: FlatButton(
                            child: Text('LOGIN',
                                style: TextStyle(
                                  fontSize: 18,
                                )),
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            color: Color(0xFF3edd9c),
                            textColor: Colors.white,
                            padding: EdgeInsets.all(8.0),
                          ),
                        )),
                  ),
                  SizedBox(height: 20.0),
                  Center(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        child: Container(
                          width: 190,
                          height: 55,
                          child: FlatButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/signup');
                            },
                            color: Color(0xFF3edd9c),
                            textColor: Colors.white,
                            padding: EdgeInsets.all(8.0),
                            child: Text('SIGN UP',
                                style: TextStyle(
                                  fontSize: 18,
                                )),
                          ),
                        )),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}

_animatedBox(active, context, index) {
  final double top = active ? 0 : 70;

  return AnimatedOpacity(
      opacity: active ? 1 : 0,
      duration: Duration(milliseconds: 300),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
        child: Stack(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 15.0 / 17.0,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image(
                      image: AssetImage(
                        onboardimages[index].url,
                      ),
                      fit: BoxFit.cover),
                  Positioned(
                    bottom: 1.0,
                    left: 1.0,
                    right: 1.0,
                    child: Container(
                        height: MediaQuery.of(context).size.width / 9,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                child: Text(onboardimages[index].message,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: .8,
                                        color: Colors.black.withOpacity(.6),
                                        fontSize: 15.0)))
                          ],
                        )),
                  )
                ],
              ),
            )
          ],
        ),
        height: active
            ? MediaQuery.of(context).size.height / 2
            : MediaQuery.of(context).size.height / 4,
        width: active
            ? MediaQuery.of(context).size.width / 1.1
            : MediaQuery.of(context).size.width / 2,
        margin: EdgeInsets.only(top: top, left: 5.0, right: 5.0),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: active
                ? Colors.grey.withOpacity(0.1)
                : Colors.grey.withOpacity(0),
            spreadRadius: 5,
            blurRadius: 3,
            offset: Offset(0, 1),
          )
        ]),
      ));
}
