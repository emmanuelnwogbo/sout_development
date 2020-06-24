import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ContactInit {
  ContactInit(this.name, this.photo, this.numbers);

  final String name;
  final Uint8List photo;
  final numbers;
}

class ContactsProvider extends ChangeNotifier {
  List<String> _contacts = [];
  List<String> _contactLabels = [];

  final String contactId = '_id';
  final String contactNumber = 'number';
  final String contactName = 'name';
  final String numbersLength = 'lengthofnums';

  get contacts {
    return _contacts;
  }

  get contactLabels {
    return _contactLabels;
  }

  setContacts(contacts) {
    _contacts = contacts;
    notifyListeners();
  }

  setContactLabels(contactLabels) {
    _contactLabels = contactLabels;
    notifyListeners();
  }
}
