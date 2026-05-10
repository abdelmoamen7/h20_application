import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/assetsmanger/assetsmanger.dart';
import '../../core/colorsmanger/colorsmanger.dart';
import '../../core/routesmanger/routesManger.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    navigatestate();
  }

  void navigatestate() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    User? firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      // User is authenticated in Firebase
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool onboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;

      if (onboardingCompleted) {
        Navigator.pushReplacementNamed(context, Routesmanger.mainlayout);
      } else {
        Navigator.pushReplacementNamed(context, Routesmanger.Onbording);
      }
    } else {
      // User not logged in
      Navigator.pushReplacementNamed(context, Routesmanger.Logins);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 250,
              child: Image(image: AssetImage(Imagemanger.logoimage)),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colorsmanger.Blue),
            ),
          ],
        ),
      ),
    );
  }
}