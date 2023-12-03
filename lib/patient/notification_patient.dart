import 'dart:async';

import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';


class NotificationPatient extends StatefulWidget {
  @override
  State<NotificationPatient> createState() => _NotificationPatientState();
}

class _NotificationPatientState extends State<NotificationPatient> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
        title: Center
          (child: Text("Notification",
          style: TextStyle(color: Colors.white,
              fontSize: 25),),),
      ),
      body: Center(
        child: Text("Notification",style: TextStyle(fontSize: 60),),


      ),
    );
  }
}
