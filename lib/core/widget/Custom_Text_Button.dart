
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../colorsmanger/colorsmanger.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({super.key,required this.texts, required this.onTap});
  final String? texts;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context){
    return    GestureDetector(
      onTap:onTap,
      child:      Text(texts!,style: GoogleFonts.inter(fontSize: 16,fontWeight: FontWeight.w500, decoration: TextDecoration.underline,color: Colorsmanger.Blue),),

    );
  }
}
