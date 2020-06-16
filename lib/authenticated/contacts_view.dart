import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

class ContactsView extends StatefulWidget {
  @override
  _ContactsViewState createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
  final String fontFamily = 'HelveticaNeue';

  Iterable<Contact> _contacts;
  List<String> addedNums = [];
  List<int> addedNumsIndex = [];

  Future<void> _getContacts() async {
    final Iterable<Contact> contacts =
        (await ContactsService.getContacts()).toList();
    setState(() {
      _contacts = contacts;
      print(_contacts);
    });
  }

  @override
  void initState() {
    _getContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final curScaleFactor = MediaQuery.of(context).textScaleFactor;

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

                  return GestureDetector(
                      onTap: () {
                        if (addedNumsIndex.contains(index)) {
                          List<int> addedNumsIndexArr = addedNumsIndex;
                          List<String> addedNumsArr = addedNums;

                          for (var i = 0; i < numbers.length; i++) {
                            var value = numbers.elementAt(i).value;
                            debugPrint(value);
                            addedNumsArr.remove(value);
                          }

                          addedNumsIndexArr.remove(index);

                          setState(() {
                            addedNumsIndex = addedNumsIndexArr;
                            addedNums = addedNumsArr;
                          });
                        } else {
                          List<int> addedNumsIndexArr = addedNumsIndex;
                          List<String> addedNumsArr = addedNums;

                          for (var i = 0; i < numbers.length; i++) {
                            var value = numbers.elementAt(i).value;
                            debugPrint(value);
                            addedNumsArr.add(value);
                          }

                          addedNumsIndexArr.add(index);
                          setState(() {
                            addedNumsIndex = addedNumsIndexArr;
                            addedNums = addedNumsArr;
                          });
                        }
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
                                  addedNumsIndex.contains(index)
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
