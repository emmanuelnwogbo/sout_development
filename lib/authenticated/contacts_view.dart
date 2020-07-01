import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:provider/provider.dart';
import 'package:sout_development/providers/contacts.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String fontFamily = 'HelveticaNeue';

class ContactsView extends StatefulWidget {
  @override
  _ContactsViewState createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<String> addedNums = [];
  List<String> addedNumsActive = [];
  String currentText = '';

  void _getContactsStorage() async {
    final SharedPreferences prefs = await _prefs;
    var contacts = prefs.getStringList('locallyStoredContactsVal');
    var circleNames = prefs.getStringList('locallyStoredCircleVal');

    if (contacts != null) {
      setState(() {
        addedNums = contacts.toSet().toList();
        addedNumsActive = circleNames != null ? circleNames : [];
      });
    }
  }

  void _setCircleLocal() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setStringList('locallyStoredCircleVal', addedNumsActive);
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
    _getContactsStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final curScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Material(
        child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 40.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                            child: Padding(
                          padding: EdgeInsets.only(
                              top: 10.0, left: 12.0, right: 12.0),
                          child: Text('Add contacts to your circle',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                letterSpacing: .8,
                                color: Colors.black,
                                fontSize: 18.0 * curScaleFactor,
                                fontFamily: fontFamily,
                                fontWeight: FontWeight.w700,
                              )),
                        )))
                  ],
                ),
                ClipRRect(
                    borderRadius: BorderRadius.circular(1),
                    child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                            child: TextField(
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(fontSize: 19),
                                  hintText: 'Search contacts',
                                  suffixIcon: Icon(Icons.search),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(20),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    currentText = value;
                                  });
                                })),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(color: Colors.black.withOpacity(.6)),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(1),
                              topRight: Radius.circular(1),
                              bottomLeft: Radius.circular(1),
                              bottomRight: Radius.circular(1)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ))),
                Container(
                  height: MediaQuery.of(context).size.height - 135,
                  child: new ListView.builder(
                    reverse: false,
                    itemCount: addedNums.length,
                    itemBuilder: (_, int index) {
                      var item = addedNums[index];
                      return item
                              .trim()
                              .toLowerCase()
                              .contains(currentText.trim().toLowerCase())
                          ? GestureDetector(
                              onTap: () {
                                var newArr = addedNumsActive;
                                newArr.contains(item)
                                    ? newArr.remove(item)
                                    : newArr.add(item);
                                setState(() {
                                  addedNumsActive = newArr;
                                });

                                _setCircleLocal();
                              },
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 5.0, bottom: 5.0, left: 10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(1),
                                          topRight: Radius.circular(1),
                                          bottomLeft: Radius.circular(1),
                                          bottomRight: Radius.circular(1)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    height: 45,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(width: 10.0),
                                            Text(truncateWithEllipsis(18, item),
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize:
                                                      13.0 * curScaleFactor,
                                                  fontFamily: fontFamily,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 1.5,
                                                ))
                                          ],
                                        ),
                                        addedNumsActive.contains(item)
                                            ? Container(
                                                child: Center(
                                                  child: Icon(
                                                    Icons.check,
                                                    color: Color(0xFF3edd9c),
                                                    size: 22.0,
                                                  ),
                                                ),
                                              )
                                            : Container()
                                      ],
                                    ),
                                  )),
                            )
                          : Container();
                    },
                  ),
                )
              ],
            )));
  }
}
