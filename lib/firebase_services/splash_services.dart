import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zheimer/patient/family/test_family.dart';
import 'package:zheimer/patient/patient_page.dart';
import 'package:zheimer/ui/page/doctor_page.dart';
import '../ui/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashServices{

  //Function Check user Doctor or Patient
  void route(BuildContext context){

    User? users = FirebaseAuth.instance.currentUser;
    var ff = FirebaseFirestore.instance.collection("Family")
        .doc(users!.uid).get()
        .then((DocumentSnapshot documentSnapshot) {
      if(documentSnapshot.exists){
        if(documentSnapshot.get("Type :") == "Family"){
          Navigator.push(context,
              MaterialPageRoute(builder: (context)=>TestFamily()));
        }
      }
    });


    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance.collection("UserData")
        .doc(user!.uid).get()
        .then((DocumentSnapshot documentSnapshot) {
      if(documentSnapshot.exists){

         if(documentSnapshot.get("Gender :") == 'Patient'){
          Navigator.push(context,
              MaterialPageRoute(builder: (context)=>PatientPage()));
        }else if (documentSnapshot.get("Gender :") == 'Doctor'){
          Navigator.push(context,
              MaterialPageRoute(builder: (context)=>DoctorPage()));
        }
         //DoctorPage

        // if(documentSnapshot.get("Gender :") == 'Doctor'){
        //   Navigator.push(context,
        //       MaterialPageRoute(builder: (context)=>DoctorPage()));
        // }else if (documentSnapshot.get("Gender :") == 'Patient'){
        //   Navigator.push(context,
        //       MaterialPageRoute(builder: (context)=>PatientPage()));
        // }
      }
    });

  }



  // Function open the program after the time(Second(3),LoginScreen)
  void isLogin(BuildContext context){

    // firebas auth
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    // Confirm whether the user is login or logout
    if(user != null){

      // check user save use Doctor or Patient
      route(context);

      // Timer(const Duration(seconds: 3),
      //         ()=>Navigator.push(context,
      //         MaterialPageRoute(builder:(context)=>DoctorPage())));
    }else{
      Timer(const Duration(seconds: 3),
              ()=>Navigator.push(context,
              MaterialPageRoute(builder:(context)=>LoginScreen())));
    }


  }
}