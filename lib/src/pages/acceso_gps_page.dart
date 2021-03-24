import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AccesoGPSPage extends StatefulWidget {
  @override
  _AccesoGPSPageState createState() => _AccesoGPSPageState();
}

class _AccesoGPSPageState extends State<AccesoGPSPage>
    with WidgetsBindingObserver {
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
      if (await Permission.location.isGranted) {
        Navigator.pushReplacementNamed(context, "loading");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Es necesario el GPS para usar esta app"),
            SizedBox(height: 20),
            MaterialButton(
              height: 50,
              color: Colors.black,
              textColor: Colors.white,
              child: Text(
                "Solicitar Acceso",
                style: TextStyle(fontSize: 15),
              ),
              shape: StadiumBorder(),
              elevation: 3,
              onPressed: () async {
                final status = await Permission.location.request();
                accesoGPS(status);
              },
            ),
          ],
        ),
      ),
    );
  }

  void accesoGPS(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        Navigator.pushReplacementNamed(context, "mapa");
        break;

      case PermissionStatus.limited:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
        openAppSettings();
    }
  }
}
