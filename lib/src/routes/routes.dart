import 'package:flutter/material.dart';
import 'package:google_sign_in_test/src/pages/home_page.dart';
import 'package:google_sign_in_test/src/pages/loading_page.dart';
import 'package:google_sign_in_test/src/pages/login_page.dart';
import 'package:google_sign_in_test/src/pages/map_page.dart';
import 'package:google_sign_in_test/src/pages/register_page.dart';

Map<String, Widget Function(BuildContext)> getRoutes() => {
      "home": (BuildContext _) => HomePage(),
      "login": (BuildContext _) => LoginPage(),
      "register": (BuildContext _) => RegisterPage(),
      "loading": (BuildContext _) => LoadingPage(),
      "mapa": (BuildContext _) => MapPage(),
    };
