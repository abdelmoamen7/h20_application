import 'package:flutter/material.dart';
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

  void navigatestate(){
    Future.delayed(Duration(seconds: 2),(){
      Navigator.pushReplacementNamed(context, Routesmanger.Logins);
    }
    );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorsmanger.Whiteblue,
      body:
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 200,),
          Container(
              width: 200,
              height: 250,
              child: Image(image: AssetImage(Imagemanger.logoimage,),)),

        ],
      ),
    );

  }
}
//Text("Laungauge",style: GoogleFonts.inter(fontSize: 16,fontWeight: FontWeight.w500,color: Colorsmanger.darkblue),)