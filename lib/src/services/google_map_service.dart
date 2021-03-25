import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in_test/src/models/nearby_search_response.dart';
import 'package:google_sign_in_test/src/sharedPreferences/savePreferences.dart';
import 'package:http/http.dart' as http;

class GoogleMapService {
  GoogleMapService._private();
  static final GoogleMapService _instance = GoogleMapService._private();
  factory GoogleMapService() {
    return _instance;
  }

  final String _apiKey = "AIzaSyDwQMAfM4Mp0nstjXUa_h7wmbUB-k2F8-M";
  final String _authority = "maps.googleapis.com";

  Future<NearbySearchResponse> getNearbyHospitals(LatLng position) async {
    final uri = Uri.https(
      _authority,
      "/maps/api/place/nearbysearch/json",
      {
        "location": "${position.latitude},${position.longitude}",
        "radius": "5000",
        "type": "hospital",
        "key": _apiKey,
        "language": "es",
      },
    );

    try {
      final resp = await http.get(
        uri,
        headers: {"Connection": "keep-alive"},
      );
      final nearbyResp = nearbySearchResponseFromJson(resp.body);
      SavePreferences().saveNearbyPlaces(resp.body);
      return nearbyResp;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
