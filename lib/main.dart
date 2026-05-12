import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'core/config/ConfigProvider.dart';
import 'core/routesmanger/routesManger.dart';
import 'l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initializes on the splash screen so runApp is not blocked
  // (faster time-to-first-frame). See splashscreen.dart.

  runApp(
    ChangeNotifierProvider(
      create: (context) => ConfigProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ///This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ConfigProvider configProvider = Provider.of<ConfigProvider>(context);
    return ScreenUtilInit(
      designSize: Size(393, 841),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child)=> MaterialApp(
        debugShowCheckedModeBanner: false,
        //theme: Thememanger.light,
        //darkTheme: Thememanger.dark,
        //themeMode: configProvider.currenttheme,
        locale: Locale(configProvider.currentlanguage),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: const [
          Locale('en'),
          Locale('ar'),
        ],
        routes: Routesmanger.routes,
        initialRoute: Routesmanger.Splaschreens,
        ///FirebaseAuth.instance.currentUser== null? Routesmanger.Logins:Routesmanger.mainlayout ,
        //
      ),
    );
  }
}