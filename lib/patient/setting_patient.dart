import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:zheimer/provider/theme_settings.dart';
import 'package:zheimer/ui/auth/login_screen.dart';

import '../../utils/utils.dart';
import 'package:location/location.dart' as loc;

class SettingPatient extends StatefulWidget {
  @override
  State<SettingPatient> createState() => _SettingPatientState();
}

class _SettingPatientState extends State<SettingPatient> {

  // Firebase
  final auth = FirebaseAuth.instance;
  //variable Email
  final emailcontroller = TextEditingController();
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  @override
  void initState(){
    super.initState();
    _requestPermission();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
  }

  @override
  void dispose(){
    emailcontroller.dispose();
    super.dispose();
  }
  // function create a new password from the link
  Future passwordReset() async{
    try{
      // send link in email to be done new password
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailcontroller.text.trim());
      // show Message Password reset link send! Check your email
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content:  Text("Password reset link send! Check your email"),
        );
      });
      // show message if the email is wrong or not available
    }on FirebaseAuthException catch(e){
      print(e);
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content:  Text(e.message.toString()),
        );
      });
    }
  }
  // Change Theme
  void _toggleTheme(){
    final settings = Provider.of<ThemeSettings>(context,listen: false);
    settings.toggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
        title: Center
          (child: Text("settings",
          style: TextStyle(color: Colors.white,
              fontSize: 25),),),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16,top: 25,right: 16),
        child: ListView(
          children: [
            Row(
              children: [
                Icon(Icons.person,color: Colors.green,),
                SizedBox(width: 8,),
                Text("account",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)
              ],
            ),
            Divider(height: 15,thickness: 2,),

            SizedBox(height: 40,),
            // showDialog( Change Password )
            GestureDetector(
              onTap: (){
                showDialog(context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Text("Change Password"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Enter Your Email and we will send you a password reset link'),
                            SizedBox(height: 10,),
                            Container(
                              margin: EdgeInsets.only(top: 5,left: 8,right: 8),
                              child: TextFormField(
                                controller: emailcontroller,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    labelText: "E-mail",
                                    hintText: "user@example.com",
                                    suffixIcon:Icon(Icons.mail),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )
                                ),
                              ),
                            ),
                          ],
                        ),
                        //Row( Send & Close )
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(onPressed: passwordReset, child: Text('Send')),
                              TextButton(onPressed:(){
                                Navigator.of(context).pop();
                              },
                                child: Text('Close'),)
                            ],
                          ),
                        ],
                      );
                    });
              },
              //Text("change password")
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("change password",style: TextStyle(
                    fontSize: 22,fontWeight: FontWeight.w500,
                  ),),
                  Icon(Icons.lock_outline,)
                ],
              ),
            ),
            SizedBox(height: 40,),
            //Text("Themes")
            GestureDetector(
              // Change Theme
              onTap: _toggleTheme,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Themes",style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),),
                  Icon(Icons.brightness_4_outlined,),
                ],
              ),
            ),
            SizedBox(height: 40,),
            // Text("Language")
            GestureDetector(
              onTap: (){

              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Language",style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),),
                  Icon(Icons.language,),
                ],
              ),
            ),
            SizedBox(height: 40,),
            GestureDetector(
              onTap: (){
                Timer.periodic(Duration(seconds: 10), (timer) {
                  _listenLocation();
                  print('Function executed every 4 seconds');});

              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Update live location",style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),),
                  Icon(Icons.edit_location_outlined)
                ],
              ),
            ),
            SizedBox(height: 40,),
            // Text("LogOut")
            GestureDetector(
              onTap: (){
                auth.signOut().then((value){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>LoginScreen()));
                }).onError((error, stackTrace) {
                  // Show Message Error
                  Utils().toastMessage(error.toString(),);
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("LogOut",style: TextStyle(
                    color: Colors.red,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),),
                  Icon(Icons.login_outlined,color: Colors.red,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      var user = auth.currentUser;
      await FirebaseFirestore.instance.collection('UserData').doc(user!.uid).set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
      }, SetOptions(merge: true));
    });
  }



  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }



}
