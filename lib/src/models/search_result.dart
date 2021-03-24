import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:meta/meta.dart';

class SearchResult {
  final bool isCanceled;
  final bool manual;
  final LatLng latLng;
  final String nombreDest;
  final String description;

  SearchResult({
    @required this.isCanceled,
    this.manual,
    this.latLng,
    this.nombreDest,
    this.description,
  });
}
