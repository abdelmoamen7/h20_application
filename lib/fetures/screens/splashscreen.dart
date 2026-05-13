import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/assetsmanger/assetsmanger.dart';
import '../../core/colorsmanger/colorsmanger.dart';
import '../../core/routesmanger/routesManger.dart';
import '../../services/FirebaseServcies/firebaseService.dart';
import '../../services/NotificationService/notification_service.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    // Defer until after the first frame so the splash UI paints immediately
    WidgetsBinding.instance.addPostFrameCallback((_) => navigatestate());
  }

  void navigatestate() async {
    // Prefs + Firebase in parallel after first paint (main no longer awaits Firebase).
    final boot = await Future.wait<Object?>([
      SharedPreferences.getInstance(),
      Firebase.apps.isEmpty
          ? Firebase.initializeApp()
          : Future<FirebaseApp>.value(Firebase.app()),
    ]);
    final prefs = boot[0] as SharedPreferences;

    if (!mounted) return;

    // Warm profile cache without blocking navigation.
    unawaited(Fairebaeservices.prefetchCurrentUserProfile());

    // Update daily streak (fire-and-forget — never blocks navigation)
    unawaited(Fairebaeservices.updateStreak());

    // Schedule daily reminders if user is logged in
    if (FirebaseAuth.instance.currentUser != null) {
      unawaited(NotificationService.scheduleDailyReminders());
    }

    final User? firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      // User is authenticated in Firebase
      final bool onboardingCompleted =
          prefs.getBool('onboardingCompleted') ?? false;

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