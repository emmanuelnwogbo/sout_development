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

  Iterable<Contact> _contacts = [];
  List<String> addedNums = [];

  Future<void> _getContacts() async {
    final Iterable<Contact> contacts =
        (await ContactsService.getContacts()).toList();
    setState(() {
      _contacts = contacts;
    });
  }

  void setContactsToStorage() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setStringList('locallyStoredContacts', addedNums);
  }

  void _getContactsStorage() async {
    final SharedPreferences prefs = await _prefs;
    var contacts = prefs.getStringList('locallyStoredContacts');

    if (contacts != null) {
      setState(() {
        addedNums = contacts;
      });
    }
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
    _getContacts();
    _getContactsStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final curScaleFactor = MediaQuery.of(context).textScaleFactor;
    final contactsProvider = Provider.of<ContactsProvider>(context);

    return _contacts != null && _contacts.length > 0
        ? Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        height: 20,
                        child: Center(
                            child: Padding(
                          padding: EdgeInsets.only(
                              top: 10.0, left: 12.0, right: 12.0),
                          child: Text('Add contacts to your circle',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                letterSpacing: .8,
                                color: Colors.black.withOpacity(.6),
                                fontSize: 15.0 * curScaleFactor,
                                fontFamily: fontFamily,
                                fontWeight: FontWeight.w700,
                              )),
                        )))
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height - 20,
                  child: new ListView.builder(
                    reverse: false,
                    itemCount: _contacts.length,
                    itemBuilder: (_, int index) {
                      var numbers = _contacts.elementAt(index).phones.toList();
                      return _contacts.elementAt(index).phones.length > 0
                          ? GestureDetector(
                              onTap: () {
                                numbers.forEach((number) {
                                  var nums = addedNums;
                                  nums.contains(number.value.toString())
                                      ? nums.remove(number.value.toString())
                                      : nums.add(number.value.toString());
                                  setState(() {
                                    addedNums = nums;
                                  });
                                });

                                setContactsToStorage();
                              },
                              child: Container(
                                  height: 65,
                                  child: Card(
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Container(
                                                        child: CircleAvatar(
                                                      backgroundImage:
                                                          MemoryImage(_contacts
                                                              .elementAt(index)
                                                              .avatar),
                                                    )),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                        truncateWithEllipsis(
                                                            18,
                                                            _contacts
                                                                .elementAt(
                                                                    index)
                                                                .displayName),
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          fontSize: 13.0 *
                                                              curScaleFactor,
                                                          fontFamily:
                                                              fontFamily,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          letterSpacing: 1.5,
                                                        )),
                                                  ],
                                                ),
                                                addedNums.contains(_contacts
                                                        .elementAt(index)
                                                        .phones
                                                        .toList()[0]
                                                        .value
                                                        .toString())
                                                    ? Container(
                                                        child: Icon(
                                                          Icons.check,
                                                          color:
                                                              Color(0xFF3edd9c),
                                                          size: 22.0,
                                                        ),
                                                      )
                                                    : Container()
                                              ],
                                            ),
                                          )))))
                          : Container();
                    },
                  ),
                )
              ],
            ))
        : Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            child: Center(
                child: const CircularProgressIndicator(
                    backgroundColor: Color(0xFF3edd9c))),
          );
  }
}
