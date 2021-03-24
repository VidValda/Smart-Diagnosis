import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in_test/src/helpers/navegar_fadein.dart';
import 'package:google_sign_in_test/src/pages/acceso_gps_page.dart';
import 'package:google_sign_in_test/src/pages/map_page.dart';
import 'package:permission_handler/permission_handler.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (await Geolocator.isLocationServiceEnabled()) {
        Navigator.pushReplacement(
            context, navegarMapaFadeIn(context, MapPage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkGpsLoaction(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Center(child: Text(snapshot.data));
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/1489.gif"),
                  Text("Cargando"),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<String> checkGpsLoaction(BuildContext context) async {
    final permiso = await Permission.location.isGranted;
    final gpsActivo = await Geolocator.isLocationServiceEnabled();

    if (permiso && gpsActivo) {
      Navigator.pushReplacement(context, navegarMapaFadeIn(context, MapPage()));
    } else if (!permiso) {
      Navigator.pushReplacement(
          context, navegarMapaFadeIn(context, AccesoGPSPage()));
      return "de permiso del gps";
    } else if (!gpsActivo) {
      return "Active el gps";
    }
    return "";
  }
}
