import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class uitils{
  static void ShowLoading( BuildContext context){
    showDialog(context: context, builder:(context)=>AlertDialog(content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child:CircularProgressIndicator(),
        ),
      ],
    ),
    ),
    );

  }
  static void hideDialog(BuildContext context){
    Navigator.pop(context);
  }
  static void   ShowToastMassage(String message,Color color){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: color,
        textColor:color,
        fontSize: 16.0
    );


  }
}