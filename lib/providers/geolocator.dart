import 'package:flutter/foundation.dart';

class GeolocationProvider with ChangeNotifier {
  bool _locationOn = true;
  var _position;

  get locationOn {
    return _locationOn;
  }

  get position {
    return _position;
  }

  setPosition(position) {
    _position = position;
    notifyListeners();
  }

  setLocation() {
    _locationOn ? _locationOn = false : _locationOn = true;
    notifyListeners();
  }
}
