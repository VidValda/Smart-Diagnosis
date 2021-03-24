import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UbicationModel with ChangeNotifier {
  bool following = true;
  bool existUbication = false;
  LatLng _myUbication;

  StreamSubscription<Position> _positionSubscription;

  LatLng get myUbication => this._myUbication;

  void initFollowing() {
    _positionSubscription = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 4,
    ).listen((event) {
      final newUbication = LatLng(event.latitude, event.longitude);
      _myUbication = newUbication;
      existUbication = true;
      print(newUbication);
      notifyListeners();
    });
  }

  void disposeFollowing() {
    _positionSubscription?.cancel();
  }
}
