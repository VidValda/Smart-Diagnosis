import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in_test/src/models/mapModel.dart';
import 'package:google_sign_in_test/src/models/searchModel.dart';
import 'package:google_sign_in_test/src/models/signInRegister.dart';
import 'package:google_sign_in_test/src/models/ubicationModel.dart';
import 'package:google_sign_in_test/src/models/userModel.dart';
import 'package:google_sign_in_test/src/routes/routes.dart';
import 'package:google_sign_in_test/src/theme/theme.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Container(
            child: Text("Algo salió mal, reinicia"),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => SignInRegisterModel()),
              ChangeNotifierProvider(create: (_) => UserModel()),
              ChangeNotifierProvider(create: (_) => MapModel()),
              ChangeNotifierProvider(create: (_) => SearchModel()),
              ChangeNotifierProvider(create: (_) => UbicationModel()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Material App',
              initialRoute: "loading",
              routes: getRoutes(),
              theme: getTheme(),
            ),
          );
        }
        return Container(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
