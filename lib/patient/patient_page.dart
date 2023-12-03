import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zheimer/patient/home_patient.dart';
import 'package:zheimer/patient/notification_patient.dart';
import 'package:zheimer/patient/setting_patient.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';


class PatientPage extends StatefulWidget {
  @override
  State<PatientPage> createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {

  //final auth = FirebaseAuth.instance;

  // index = Page HomePatient
  int index = 1;

  final screens =[
    NotificationPatient(),
    HomePatient(),
    SettingPatient(),
  ];
  @override
  Widget build(BuildContext context) {
    final items =<Widget>[
      Icon(Icons.notifications,size: 30,color: Colors.white,),
      Icon(Icons.home,size: 30,color: Colors.white,),
      Icon(Icons.settings,size: 30,color: Colors.white,),

    ];
    return Scaffold(
      backgroundColor: Colors.grey[300],
      //bottomNavigationBar
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        index: index,
        items: items,
        onTap: (index)=>setState(() {
          this.index=index;
        }),
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.deepPurpleAccent,
        color: Colors.deepPurple,
        animationDuration: Duration(milliseconds: 300),

      ),
      // First Page is = index
      body: screens[index],
    );
  }
}
