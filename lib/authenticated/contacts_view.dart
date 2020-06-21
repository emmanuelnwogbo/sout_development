import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:sout_development/providers/contacts.dart';
import 'package:provider/provider.dart';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ContactsView extends StatefulWidget {
  @override
  _ContactsViewState createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
  final String fontFamily = 'HelveticaNeue';

  Iterable<Contact> _contacts;
  List<String> addedNums = ['08033426880'];
  List<int> addedNumsIndex = [];

  Future<void> _getContacts() async {
    final Iterable<Contact> contacts =
        (await ContactsService.getContacts()).toList();
    setState(() {
      _contacts = contacts;
    });

    //final appDir = await syspaths.getApplicationDocumentsDirectory();
  }

  @override
  void initState() {
    _getContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final curScaleFactor = MediaQuery.of(context).textScaleFactor;
    final contactProv = Provider.of<ContactsProvider>(context);

    return Container(
        //height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color(0xFFecf0f1),
        child: _contacts != null
            ? ListView.builder(
                itemCount: _contacts?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  Contact contact = _contacts?.elementAt(index);
                  var numbers = contact.phones.toList();
                  var addedNumsArr = addedNums;

                  numbers.forEach((number) {
                    if (contactProv.phonenums.contains(number)) {
                      addedNumsArr.add(number.toString());

                      setState(() {
                        addedNums = addedNumsArr;
                      });
                    }
                  });

                  return GestureDetector(
                      onTap: () {
                        print(contact);
                        var numbersArr = [];
                        for (var i = 0; i < numbers.length; i++) {
                          var value = numbers.elementAt(i).value;
                          debugPrint(value.toString());
                          numbersArr.add(value);
                        }
                        contactProv.setContacts(
                            contact.displayName, contact.avatar, numbersArr);
                      },
                      child: Container(
                          height: 65,
                          decoration: addedNumsIndex.contains(index)
                              ? new BoxDecoration(
                                  boxShadow: [
                                    new BoxShadow(
                                      spreadRadius: .1,
                                      color: Color(0xFF3edd9c).withOpacity(.3),
                                      blurRadius: .3,
                                    ),
                                  ],
                                )
                              : new BoxDecoration(),
                          child: Card(
                              child: Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(children: <Widget>[
                                    Container(
                                        child: CircleAvatar(
                                      backgroundImage:
                                          MemoryImage(contact.avatar),
                                    )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(contact.displayName,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 13.0 * curScaleFactor,
                                          fontFamily: fontFamily,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.5,
                                        ))
                                  ]),
                                  addedNums.contains(numbers[0])
                                      ? Container(
                                          child: Icon(
                                            Icons.check,
                                            color: Color(0xFF3edd9c),
                                            size: 22.0,
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                          ))));
                })
            : Center(
                child: const CircularProgressIndicator(
                    backgroundColor: Color(0xFF3edd9c))));
  }
}
