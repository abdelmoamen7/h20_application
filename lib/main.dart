import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/routesmanger/routesManger.dart';
import 'l10n/app_localizations.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();

  await  Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(393, 841),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child)=> MaterialApp(
        debugShowCheckedModeBanner: false,
        // theme: Thememanger.light,
        // darkTheme: Thememanger.dark,
        // themeMode: configProvider.currenttheme,
        // locale: Locale(configProvider.currentlanguage),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: [
          Locale('en'), // English
          Locale('ar'), // arabic
        ],
        routes: Routesmanger.routes,
        initialRoute: Routesmanger.Splaschreens,
        ///FirebaseAuth.instance.currentUser== null? Routesmanger.Logins:Routesmanger.mainlayout ,
        //
      ),
    );
  }
}
