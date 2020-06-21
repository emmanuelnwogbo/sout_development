import 'package:flutter/foundation.dart';
import 'dart:typed_data';

class ContactInit {
  ContactInit(this.name, this.photo, this.numbers);

  final String name;
  final Uint8List photo;
  final numbers;
}

class ContactsProvider extends ChangeNotifier {
  List<ContactInit> _contacts = [];
  List _phonenums = [];

  List get contacts {
    return _contacts;
  }

  List get phonenums {
    return _phonenums;
  }

  void setContacts(String name, Uint8List photo, numbers) {
    var nums = _phonenums;
    var contact = new ContactInit(name, photo, numbers);
    var contactsArr = _contacts;

    numbers.forEach((number) => {nums.add(number),});
    _phonenums = nums;
    contactsArr.add(contact);
    _contacts = contactsArr;
    print(contact.toString());
    print(_contacts.toString());

    notifyListeners();
  }
}
