
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:h20_application/services/FirebaseServcies/firebaseService.dart';
import 'package:provider/provider.dart';

import 'core/config/ConfigProvider.dart';
import 'core/routesmanger/routesManger.dart';
import 'l10n/app_localizations.dart';
import 'models/UserModel.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();


  await  Firebase.initializeApp();
  if(FirebaseAuth.instance.currentUser!=null){
    UserModel.currentUser=await Fairebaeservices.getUserId(FirebaseAuth.instance.currentUser!.uid);
  }
  runApp(ChangeNotifierProvider(
      create: (context)=>ConfigProvider(),
      child: const MyApp()));
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