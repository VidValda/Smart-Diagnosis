import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in_test/src/helpers/calculando_alert.dart';
import 'package:google_sign_in_test/src/models/mapModel.dart';
import 'package:google_sign_in_test/src/models/searchModel.dart';
import 'package:google_sign_in_test/src/models/search_result.dart';
import 'package:google_sign_in_test/src/models/ubicationModel.dart';
import 'package:google_sign_in_test/src/search/search_destination.dart';
import 'package:google_sign_in_test/src/services/traffic_service.dart';
import 'package:provider/provider.dart';
import 'package:polyline/polyline.dart' as Poly;

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildSearchBar(context);
  }

  Widget buildSearchBar(BuildContext context) {
    final ubicationModel = Provider.of<UbicationModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      width: double.infinity,
      child: GestureDetector(
        onTap: () async {
          final proximity = ubicationModel.myUbication;
          final result = await showSearch(
              context: context, delegate: SearchDestination(proximity));
          this.retornoBusqueda(context, result);
        },
        child: Container(
          padding: EdgeInsets.only(left: 10),
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 5, offset: Offset(0, 5)),
            ],
          ),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Icon(
                Icons.healing_rounded,
                color: Color(0xFF3397FF),
              ),
              Text("Busca médicos especialistas",
                  style: TextStyle(color: Colors.black87)),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: CircleAvatar(
                  child: Text("JD"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void retornoBusqueda(BuildContext context, SearchResult result) async {
    final ubicationModel = Provider.of<UbicationModel>(context, listen: false);
    final searchModel = Provider.of<SearchModel>(context, listen: false);
    final mapModel = Provider.of<MapModel>(context, listen: false);
    if (result.isCanceled) {
      return;
    }
    calculandoAlert(context);
    final start = ubicationModel.myUbication;
    final end = result.latLng;

    // final infoReponse = await TrafficService().getCordInfo(end);
    final routeResponse = await TrafficService().getCoordsStartEnd(start, end);

    if (routeResponse.code != null) {
      final geometry = routeResponse.routes[0].geometry;
      final distance = routeResponse.routes[0].distance;
      final duration = routeResponse.routes[0].duration;

      final nombreDest = result.nombreDest;

      final points = Poly.Polyline.Decode(encodedString: geometry, precision: 6)
          .decodedCoords;
      final coords = points.map((e) => LatLng(e[0], e[1])).toList();

      mapModel.buildRoute(coords, distance, duration, nombreDest);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Route not founded"),
        action: SnackBarAction(
          label: "OK",
          onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
        ),
      ));
    }
    searchModel.addHistorial(result);
    Navigator.pop(context);
  }
}
