import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

class ContactsView extends StatefulWidget {
  @override
  _ContactsViewState createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
  final String fontFamily = 'HelveticaNeue';

  Iterable<Contact> _contacts;

  Future<void> _getContacts() async {
    //Make sure we already have permissions for contacts when we get to this
    //page, so we can just retrieve it
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

                  return Container(
                      height: 65,
                      child: Card(
                          child: Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Center(
                          child: Row(children: <Widget>[
                            Container(
                                child: CircleAvatar(
                              backgroundImage: MemoryImage(contact.avatar),
                            )),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              contact.displayName,
                              textAlign: TextAlign.start,
                            )
                          ]),
                        ),
                      )));
                })
            : Center(
                child: const CircularProgressIndicator(
                    backgroundColor: Color(0xFF3edd9c))));
  }
}
