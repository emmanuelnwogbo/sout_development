import 'package:flutter/foundation.dart';

class GeolocationProvider with ChangeNotifier {
  Map _realTimeLongLat;
  bool _realTimeLocationOn = false;

  Map get realTimeLongLat {
    return _realTimeLongLat;
  }

  bool get realTimeLongLatOn {
    return _realTimeLocationOn;
  }

  void setrealTimeLongLat(Map longLat) {
    _realTimeLongLat = longLat;
    notifyListeners();
  }

  void setrealLocationStatus(bool val) {
    _realTimeLocationOn = val;
    notifyListeners();
  }
}
