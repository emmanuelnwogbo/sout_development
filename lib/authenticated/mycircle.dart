import 'package:flutter/material.dart';
import 'package:sout_development/authenticated/header.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Person {
  Person(this.name, this.photo);

  final String name;
  final String photo;
}

List<Person> circle = [];

class MyCircle extends StatefulWidget {
  @override
  _MyCircleState createState() => _MyCircleState();
}

class _MyCircleState extends State<MyCircle> {
  bool popUpOpen = false;
  List<String> addedNums = [];
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String truncateWithEllipsis(int cutoff, String myString) {
    if (myString == null) {
      return '';
    }

    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }

  void _getContactsStorage() async {
    final SharedPreferences prefs = await _prefs;
    var contactsFromStorage = prefs.getStringList('locallyStoredCircleVal');

    //print(contactsFromStorage.toString() + 'this is the value here');

    if (contactsFromStorage != null) {
      setState(() {
        addedNums = contactsFromStorage;
      });
    }
  }

  void _setCircleLocal() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setStringList('locallyStoredCircleVal', addedNums);
  }

  @override
  void initState() {
    _getContactsStorage();
    super.initState();
  }

  Widget build(BuildContext context) {
    _getContactsStorage();

    return Material(
        child: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Color(0xFFecf0f1),
                child: Stack(
                  children: <Widget>[
                    Center(
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
                              Header(false),
                              Padding(
                                  padding: EdgeInsets.only(left: 25.0),
                                  child: Container(
                                    child: Text('My Circle',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            letterSpacing: .8,
                                            color: Color(0xFF3edd9c),
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.w500)),
                                  )),
                              SizedBox(
                                height: 10.0,
                              ),
                              Center(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.only(
                                              left: 15.0,
                                              right: 15.0,
                                              bottom: 10.0),
                                          child: Column(
                                            children: <Widget>[
                                              addedNums != null &&
                                                      addedNums.length < 1
                                                  ? Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              1.8,
                                                      child: Center(
                                                        child: Text(
                                                            'It appears you have not added any contacts to your circle',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                letterSpacing:
                                                                    .8,
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                      ))
                                                  : Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              1.8,
                                                      child: ListView.builder(
                                                          reverse: false,
                                                          itemCount:
                                                              addedNums?.length,
                                                          itemBuilder:
                                                              (_, int index) {
                                                            return Container(
                                                                padding:
                                                                    EdgeInsets.only(
                                                                        bottom:
                                                                            10.0),
                                                                decoration: BoxDecoration(
                                                                    border: Border(
                                                                        bottom: BorderSide(
                                                                            color: Colors
                                                                                .black12))),
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 10,
                                                                        bottom:
                                                                            10),
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height /
                                                                    15,
                                                                child: Stack(
                                                                  children: <
                                                                      Widget>[
                                                                    Positioned(
                                                                        top:
                                                                            1.0,
                                                                        left:
                                                                            1.0,
                                                                        bottom:
                                                                            1.0,
                                                                        right:
                                                                            1.0,
                                                                        child:
                                                                            Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: <
                                                                              Widget>[
                                                                            SizedBox(
                                                                              width: 20.0,
                                                                            ),
                                                                            Text(truncateWithEllipsis(18, addedNums[index]),
                                                                                textAlign: TextAlign.start,
                                                                                style: TextStyle(letterSpacing: .8, color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w400))
                                                                          ],
                                                                        )),
                                                                    Positioned(
                                                                        right:
                                                                            1.0,
                                                                        bottom:
                                                                            1.0,
                                                                        child: GestureDetector(
                                                                            onTap: () {
                                                                              var placeholderArr = addedNums;
                                                                              placeholderArr.remove(addedNums[index]);

                                                                              setState(() {
                                                                                addedNums = placeholderArr;
                                                                              });

                                                                              _setCircleLocal();
                                                                            },
                                                                            child: Container(
                                                                              child: Icon(
                                                                                Icons.remove_circle,
                                                                                color: Color(0xFF3edd9c),
                                                                                size: 22.0,
                                                                              ),
                                                                            ))),
                                                                  ],
                                                                ));
                                                          })),
                                              SizedBox(
                                                height: 30.0,
                                              ),
                                              ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 60,
                                                    child: FlatButton(
                                                      child: Text(
                                                          'Add to your circle',
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                          )),
                                                      onPressed: () {
                                                        Navigator.pushNamed(
                                                            context,
                                                            '/contacts');
                                                      },
                                                      color: Color(0xFF3edd9c),
                                                      textColor: Colors.white,
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                    ),
                                                  )),
                                              SizedBox(
                                                height: 40.0,
                                              ),
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
                                                  spreadRadius: 5,
                                                  blurRadius: 3,
                                                  offset: Offset(0, 1),
                                                )
                                              ]))))
                            ],
                          )),
                    ),
                    Positioned(
                      top: popUpOpen
                          ? MediaQuery.of(context).size.height / 2
                          : MediaQuery.of(context).size.height,
                      right: popUpOpen ? 10.0 : 0,
                      left: popUpOpen ? 10.0 : 0,
                      bottom: popUpOpen ? 70.0 : 70,
                      child: AnimatedOpacity(
                          opacity: popUpOpen ? 1 : 0,
                          duration: Duration(milliseconds: 200),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: popUpOpen
                                  ? Container(
                                      color: Color(0xFF3edd9c),
                                      child: Stack(
                                        children: <Widget>[
                                          Positioned(
                                              top: 1.0,
                                              left: 1.0,
                                              right: 1.0,
                                              bottom: 1.0,
                                              child: Container(
                                                //height: 300.0,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              1.3,
                                                          height: 60,
                                                          child: FlatButton(
                                                            child: Text(
                                                                'Add from contacts',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal)),
                                                            onPressed: () {
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  '/contacts');
                                                            },
                                                            color: Colors.white,
                                                            textColor: Color(
                                                                0xFF3edd9c),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                          ),
                                                        )),
                                                    ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              1.3,
                                                          height: 60,
                                                          child: FlatButton(
                                                            child: Text(
                                                                'Add manually',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal)),
                                                            onPressed: () {},
                                                            color: Colors.white,
                                                            textColor: Color(
                                                                0xFF3edd9c),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                  ],
                                                ),
                                              )),
                                          Positioned(
                                              right: 10.0,
                                              top: 10.0,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100.0),
                                                  child: Container(
                                                      height: 25.0,
                                                      width: 25.0,
                                                      color: Colors.white,
                                                      padding: EdgeInsets.only(
                                                          left: 7.4),
                                                      child: Center(
                                                          child: FlatButton(
                                                              child: Icon(
                                                                Icons.cancel,
                                                                color: Color(
                                                                    0xFF3edd9c),
                                                                size: 22.0,
                                                                textDirection:
                                                                    TextDirection
                                                                        .rtl,
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  popUpOpen =
                                                                      false;
                                                                });
                                                              })))))
                                        ],
                                      ))
                                  : Container())),
                    )
                  ],
                ))));
  }
}
