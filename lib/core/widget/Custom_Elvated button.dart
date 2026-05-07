
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../colorsmanger/colorsmanger.dart';
class Coustom_Elvated_Button extends StatelessWidget {
  const Coustom_Elvated_Button({super.key,required this.text,required this.onPress});
  final String text;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return   ElevatedButton(

        style: ElevatedButton.styleFrom(
          backgroundColor: Colorsmanger.Blue,
          foregroundColor: Colorsmanger.Whiteblue,
        ),
        onPressed: onPress,
        child: Text(text,style:GoogleFonts.inter(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white),)
    );
  }

}
