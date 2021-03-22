import 'package:flutter/material.dart';
import 'package:google_sign_in_test/src/pages/home_page.dart';
import 'package:google_sign_in_test/src/pages/register_page.dart';

Map<String, Widget Function(BuildContext)> getRoutes() => {
      "home": (BuildContext _) => HomePage(),
      "register": (BuildContext _) => RegisterPage(),
    };
