import 'package:flutter/cupertino.dart';

import '../../fetures/auth/login/login.dart';
import '../../fetures/auth/register/register.dart';
import '../../fetures/auth/forget_Password/forgetPassword.dart';
import '../../fetures/mainlayout/mainlayout.dart';
import '../../fetures/screens/onbording/onbording.dart';
import '../../fetures/screens/splashscreen.dart';

abstract class Routesmanger {
  static const String Logins = "/login";
  static const String mainlayout = "/main_layout";
  static const String Registes = "/register";
  static const String Splaschreens = "/splashscreen";
  static const String Onbording = "/onbording";
  static const String forgetPassword = "/forgetpassword";

  static Map<String, WidgetBuilder> routes = {
    Logins: (context) => const Login(),
    Registes: (context) => const Register(),
    mainlayout: (context) => const MainLayout(),
    Splaschreens: (context) => const Splashscreen(),
    Onbording: (context) => const OnBoarding(),
    forgetPassword: (context) => const forgetpassword(),
  };
}
