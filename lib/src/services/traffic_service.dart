import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:google_sign_in_test/src/helpers/debouncer.dart';
import 'package:google_sign_in_test/src/models/info_response.dart';
import 'package:google_sign_in_test/src/models/route_response.dart';
import 'package:google_sign_in_test/src/models/search_response.dart';

class TrafficService {
  //singleton
  TrafficService._private();
  static final TrafficService _instance = TrafficService._private();
  factory TrafficService() {
    return _instance;
  }

  final debouncer = Debouncer<String>(duration: Duration(milliseconds: 400));
  final StreamController<SearchResponse> _sugerenciasStreamController =
      StreamController<SearchResponse>.broadcast();

  Stream<SearchResponse> get sugerenciasStream =>
      this._sugerenciasStreamController.stream;
  void closeStream() {
    _sugerenciasStreamController.close();
  }

  final String _baseUrl = "https://api.mapbox.com/directions/v5";
  final String _baseUrlDir = "https://api.mapbox.com/geocoding/v5";
  final String _apiKey =
      "pk.eyJ1IjoidmlkdmFsZGEiLCJhIjoiY2ttbXc4bHZrMWl0bzJwcnc1dHh4NWozZyJ9.H1ZJBDV3zgiIPjZd2iGAZw";

  Future<RouteResponse> getCoordsStartEnd(LatLng start, LatLng end) async {
    print(start);
    print(end);
    final coordString =
        "${start.longitude},${start.latitude};${end.longitude},${end.latitude}";
    final url = "$_baseUrl/mapbox/driving/$coordString";
    final uri = Uri.https(
      "api.mapbox.com",
      "/directions/v5/mapbox/driving/$coordString",
      {
        "alternatives": "true",
        "geometries": "polyline6",
        "steps": "false",
        "access_token": this._apiKey,
        "language": "es",
      },
    );
    try {
      final resp = await http.get(
        uri,
        headers: {"Connection": "keep-alive"},
      );
      final data = routeResponseFromJson(resp.body);
      return data;
    } catch (e) {
      return RouteResponse();
    }
  }

  Future<SearchResponse> getResultsQuery(String query, LatLng proximity) async {
    print("Searching..");
    final uri = Uri.https(
      "api.mapbox.com",
      "/geocoding/v5/mapbox.places/$query.json",
      {
        "access_token": this._apiKey,
        "autocomplete": "true",
        "proximity": "${proximity.longitude},${proximity.latitude}",
        "language": "es",
      },
    );
    try {
      final resp = await http.get(
        uri,
        headers: {"Connection": "keep-alive"},
      );
      final searchResponse = searchResponseFromJson(resp.body);
      return searchResponse;
    } catch (e) {
      return SearchResponse(features: []);
    }
  }

  void getSugerenciasPorQuery(String busqueda, LatLng proximidad) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final resultados = await this.getResultsQuery(value, proximidad);
      this._sugerenciasStreamController.add(resultados);
    };

    final timer = Timer.periodic(Duration(milliseconds: 200), (_) {
      debouncer.value = busqueda;
    });

    Future.delayed(Duration(milliseconds: 201)).then((_) => timer.cancel());
  }

  Future<InfoResponse> getCordInfo(LatLng latLng) async {
    final coordString = "${latLng.longitude},${latLng.latitude}";
    final url = "$_baseUrlDir/mapbox.places/$coordString.json";
    try {
      final resp = await http.get(
        Uri.parse(url),
        headers: {
          "access_token": _apiKey,
          "language": "es",
        },
      );
      final data = infoResponseFromJson(resp.body);
      return data;
    } catch (e) {
      return InfoResponse();
    }
  }
}
