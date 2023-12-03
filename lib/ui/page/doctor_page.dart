import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zheimer/ui/page/data_file.dart';
import 'package:zheimer/ui/page/home_page.dart';
import 'package:zheimer/ui/page/notification_page.dart';
import 'package:zheimer/ui/page/rays_image.dart';
import 'package:zheimer/ui/page/setting_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';


class DoctorPage extends StatefulWidget {
  @override
  State<DoctorPage> createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {

  // Firebase
  //final auth = FirebaseAuth.instance;

  // index = Page HomePage
  int index = 2;

  final screens =[
    RaysImage(),
    DataFile(),
    HomePage(),
    NotificationPage(),
    SettingPage(),
  ];
  @override
  Widget build(BuildContext context) {
    final items =<Widget>[
      Icon(Icons.camera_alt,size: 30,color: Colors.white,),
      Icon(Icons.add_circle_sharp,size: 30,color: Colors.white,),
      Icon(Icons.home,size: 30,color: Colors.white,),
      Icon(Icons.notifications,size: 30,color: Colors.white,),
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
