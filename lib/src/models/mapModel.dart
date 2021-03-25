import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in_test/src/helpers/widgets_to_marker.dart';
import 'package:google_sign_in_test/src/services/google_map_service.dart';
import 'package:google_sign_in_test/src/sharedPreferences/savePreferences.dart';
import 'package:google_sign_in_test/src/theme/uber_map_theme.dart';

class MapModel with ChangeNotifier {
  LatLng _currentPosition;
  Map<String, Polyline> polylines = Map();
  Map<String, Marker> markers = Map();
  bool mapaReady = false;
  bool seguirUbicacion = false;

  Polyline _miRuta = new Polyline(
    polylineId: PolylineId("mi_ruta"),
    width: 4,
    color: Colors.transparent,
  );
  Polyline _miRutaDest = new Polyline(
    polylineId: PolylineId("mi_ruta_dest"),
    width: 4,
    color: Colors.black87,
  );

  LatLng get currentPosition => this._currentPosition;

  set currentPosition(LatLng currentPosition) {
    _currentPosition = currentPosition;
  }

  GoogleMapController _mapController;

  GoogleMapController get mapController => this._mapController;

  set mapController(GoogleMapController mapController) {
    _mapController = mapController;
  }

  void moverCamara(LatLng destiny) async {
    final cameraUpadate = CameraUpdate.newLatLng(destiny);
    this._mapController?.animateCamera(cameraUpadate);
  }

  void init(GoogleMapController controller) async {
    if (!mapaReady) {
      _mapController = controller;
      _mapController.setMapStyle(jsonEncode(uberMapTheme));
      mapaReady = true;
      await GoogleMapService().getNearbyHospitals(_currentPosition);
      buildHospitalsMarkers();

      notifyListeners();
    }
  }

  void locationUpdate(LatLng latLng) {
    _currentPosition = latLng;
    if (seguirUbicacion) {
      moverCamara(latLng);
    }
    final List<LatLng> points = [
      ...this._miRuta.points,
      latLng,
    ];
    this._miRuta = this._miRuta.copyWith(pointsParam: points);
    final currentPolylines = polylines;
    currentPolylines["mi_ruta"] = this._miRuta;
    polylines = currentPolylines;
  }

  void buildRoute(
    List<LatLng> coords,
    double distance,
    double duration,
    String nombreDest,
  ) async {
    moverCamara(coords.last);
    this._miRutaDest = this._miRutaDest.copyWith(pointsParam: coords);
    final currentPolylines = polylines;
    currentPolylines["mi_ruta_dest"] = this._miRutaDest;
    // Icono inicio
    final iconStart = await getMarkerStartIcon(duration.floor());
    final iconEnd = await getMarkerEndIcon(nombreDest, distance);

    // marcadores
    final markerInicio = Marker(
      markerId: MarkerId("inicio"),
      position: coords.first,
      icon: iconStart,
      anchor: Offset(0, 0.9),
    );
    final markerFinal = Marker(
      markerId: MarkerId("final"),
      position: coords.last,
      icon: iconEnd,
      anchor: Offset(0, 0.9),
    );
    final newMarkers = {...markers};
    newMarkers["inicio"] = markerInicio;
    newMarkers["final"] = markerFinal;
    polylines = currentPolylines;
    markers = newMarkers;

    notifyListeners();
  }

  void buildHospitalsMarkers() async {
    final icon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(15, 15)),
      "assets/doctor.png",
    );
    final response = await SavePreferences().loadNearbyPlaces();
    markers = Map<String, Marker>.fromIterable(
      response.results,
      key: (element) => element.placeId,
      value: (element) => Marker(
        markerId: MarkerId(element.placeId),
        position: LatLng(
          element.geometry.location.lat,
          element.geometry.location.lng,
        ),
        icon: icon,
        anchor: Offset(0.5, 1.0),
      ),
    );
    notifyListeners();
  }
}
