import 'package:google_sign_in_test/src/models/nearby_search_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavePreferences {
  SavePreferences._private();

  static SavePreferences _instance = SavePreferences._private();

  factory SavePreferences() {
    return _instance;
  }

  void saveNearbyPlaces(String data) async {
    final sharedInstance = await SharedPreferences.getInstance();
    await sharedInstance.remove("places");
    await sharedInstance.setString("places", data);
  }

  Future<NearbySearchResponse> loadNearbyPlaces() async {
    final sharedInstance = await SharedPreferences.getInstance();
    final resp = sharedInstance.getString("places");
    final response = nearbySearchResponseFromJson(resp);
    return response;
  }
}
