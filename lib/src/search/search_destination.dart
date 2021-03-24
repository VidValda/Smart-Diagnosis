import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:google_sign_in_test/src/models/searchModel.dart';
import 'package:google_sign_in_test/src/models/search_response.dart';
import 'package:google_sign_in_test/src/models/search_result.dart';
import 'package:google_sign_in_test/src/services/traffic_service.dart';
import 'package:provider/provider.dart';

class SearchDestination extends SearchDelegate<SearchResult> {
  @override
  final String searchFieldLabel;
  final TrafficService _trafficService;
  final LatLng proximity;
  SearchDestination(this.proximity)
      : this.searchFieldLabel = "Buscar",
        this._trafficService = TrafficService();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => this.query = "",
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    final result = new SearchResult(isCanceled: true);
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () => this.close(context, result),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResultsSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchModel = Provider.of<SearchModel>(context, listen: false);
    if (query.isEmpty) {
      final result = new SearchResult(isCanceled: false, manual: true);
      final historial = searchModel.historial;
      return ListView(
        physics: BouncingScrollPhysics(),
        children: [
          if (historial != null)
            ...historial
                .map(
                  (result) => Dismissible(
                    key: Key(result.nombreDest),
                    onDismissed: (direction) =>
                        searchModel.deleteHistorial(result),
                    child: ListTile(
                      title: Text(result.nombreDest),
                      leading: Icon(Icons.history),
                      subtitle: Text(result.description),
                      onTap: () {
                        this.close(context, result);
                      },
                    ),
                  ),
                )
                .toList(),
        ],
      );
    }
    return _buildResultsSuggestions();
  }

  Widget _buildResultsSuggestions() {
    if (query.isEmpty) {
      return Container();
    }
    this._trafficService.getSugerenciasPorQuery(query.trim(), this.proximity);
    return StreamBuilder<SearchResponse>(
      stream: this._trafficService.sugerenciasStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final lugares = snapshot.data.features;
        if (lugares.isEmpty) {
          return ListTile(
            title: Text("No result for: $query"),
          );
        }
        return ListView.separated(
          itemCount: lugares.length,
          separatorBuilder: (_, __) => Divider(),
          itemBuilder: (context, index) {
            final place = lugares[index];
            return ListTile(
              title: Text(place.textEs ?? place.text),
              leading: Icon(Icons.place),
              subtitle: Text(place.placeNameEs ?? place.placeName),
              onTap: () {
                this.close(
                  context,
                  SearchResult(
                    isCanceled: false,
                    manual: false,
                    latLng: LatLng(place.center[1], place.center[0]),
                    nombreDest: place.textEs ?? place.text,
                    description: place.placeNameEs ?? place.placeName,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
