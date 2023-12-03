import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:zheimer/ui/auth/login_screen.dart';
import 'package:zheimer/utils/utils.dart';
import 'map.dart';


class TestFamily extends StatefulWidget {
  const TestFamily({super.key});


  @override
  State<TestFamily> createState() => _TestFamilyState();
}


class _TestFamilyState extends State<TestFamily> {

  // variable location
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  @override
  void initState(){
    super.initState();
    _requestPermission();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
  }

  // Firebase Auth
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
        title: Center(child: Text("live location")),
        actions: [
          IconButton(onPressed: (){
            // logout in firebase
            _auth.signOut().then((value){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>LoginScreen()));
            }).onError((error, stackTrace) {
              // message error
              Utils().toastMessage(error.toString(),);
            });
          },
              icon: Icon(Icons.login_outlined)),
        ],
      ),
      body: Column(children: [
        Expanded(
          flex: 3,
            child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('UserData').snapshots(),
          builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
            if (!snapshot.hasData){
              return Center(child: CircularProgressIndicator(),);
            }
            return ListView.builder(itemCount: snapshot.data?.docs.length
                ,itemBuilder: (context,index){
                  return ListTile(
                    title: Text(snapshot.data!.docs[index]["Name :"].toString()),
                    subtitle: Row(
                      children: [
                        Text(snapshot.data!.docs[index]['latitude'].toString()),
                        SizedBox(width: 20,),
                        Text(snapshot.data!.docs[index]['longitude'].toString()),
                        SizedBox(width: 20,),
                      ],
                    ),
                    trailing: IconButton(icon: Icon(Icons.directions),onPressed: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Map(snapshot.data!.docs[index].id))
                      );
                    },),
                  );
                });
          },
        )),
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 20,right: 20),
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(15),
          ),
          //color: Colors.deepPurple,
          child: TextButton(onPressed: (){
            _stopListening();
          }, child: Text('stop live location',style: TextStyle(color: Colors.white),)),
        ),
        TextButton(onPressed: (){
          _listenLocation();
        }, child: Text('enable live location',style: TextStyle(color: Colors.deepPurpleAccent),)),
      ],),
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
      var user = _auth.currentUser;
      await FirebaseFirestore.instance.collection('UserData').doc(user!.uid).set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
      }, SetOptions(merge: true));
    });
  }
  _stopListening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
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


