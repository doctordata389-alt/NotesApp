//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:notes/Bottom_Navigation.dart';
import 'package:notes/UI/Login_Screen.dart';
import 'dart:async';




class SplashServices {

  void islogin(BuildContext context){

    final auth=FirebaseAuth.instance;
    final user=auth.currentUser;

    if(user!=null){
      Timer(Duration(seconds: 3), ()=>
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomNavigation())));
    }else{
      Timer(Duration(seconds: 3), ()=>
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen())));
    }

  }
}