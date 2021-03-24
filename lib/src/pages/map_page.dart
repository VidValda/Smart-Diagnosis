import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in_test/src/models/mapModel.dart';
import 'package:google_sign_in_test/src/models/ubicationModel.dart';
import 'package:google_sign_in_test/src/services/traffic_service.dart';
import 'package:google_sign_in_test/src/widgets/search_bar.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void initState() {
    Provider.of<UbicationModel>(context, listen: false).initFollowing();
    super.initState();
  }

  @override
  void dispose() {
    TrafficService().closeStream();
    Provider.of<UbicationModel>(context, listen: false).disposeFollowing();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ubicationModel = Provider.of<UbicationModel>(context);
    final mapModel = Provider.of<MapModel>(context, listen: false);
    return Scaffold(
      body: Stack(
        children: [
          Center(child: buildMap(ubicationModel)),
          SafeArea(
            child: Align(
              alignment: Alignment(0, -0.97),
              child: SearchBar(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          mapModel.moverCamara(ubicationModel.myUbication);
        },
        child: Icon(
          Icons.my_location_rounded,
          color: Color(0xFF3397FF),
        ),
      ),
    );
  }

  Widget buildMap(UbicationModel ubicationModel) {
    if (ubicationModel.existUbication) {
      final mapModel = Provider.of<MapModel>(context);
      mapModel.locationUpdate(ubicationModel.myUbication);
      final cameraPosition = new CameraPosition(
        target: ubicationModel.myUbication,
        zoom: 15,
      );
      return GoogleMap(
        initialCameraPosition: cameraPosition,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        onCameraMove: (position) {},
        polylines: mapModel.polylines.values.toSet(),
        markers: mapModel.markers.values.toSet(),
        onMapCreated: mapModel.init,
      );
    }
    return Text("Ubicando....");
  }
}
