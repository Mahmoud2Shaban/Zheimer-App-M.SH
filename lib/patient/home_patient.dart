import 'dart:convert';
import 'dart:io';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zheimer/ui/auth/login_screen.dart';
import 'package:zheimer/utils/utils.dart';

import 'package:http/http.dart' as http;


class HomePatient extends StatefulWidget {
  @override
  State<HomePatient> createState() => _HomePatientState();
}

class _HomePatientState extends State<HomePatient> {




  // Show Progress
  bool loading = false;

  // Firebase
  final auth = FirebaseAuth.instance;
  File? _file;  // pass camera
// function check camera and gallary
  Future pickercamera (type) async{
    var myfile ;
    if(type == 'camera'){
      //storage image in camera
      myfile = await ImagePicker().pickImage(source: ImageSource.camera);
    }else{
      //storage image in studio
      myfile = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    if(myfile != null){
      setState(() {
        //pass image taken from the camera
        _file = File(myfile.path);
      });
    }

  }

  // Function Check X-rays in Model Web
  Future<void> predict() async {
    // Show Progress True
    setState(() {
      loading = true;
    });
    // Variable Pass link Web
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://new-app1.herokuapp.com/prediction/'),
    );
    // Image Path
    var image = _file;
    var stream = http.ByteStream(image!.openRead());
    // Length Image
    var length = await image.length();
    // open image in web pass Length & stream & filename & image pass & Cancel (/)
    var multipartFile = http.MultipartFile(
      'image', stream, length, filename: image.path.split('/').last,
    );
    // Variable add multipartFile in web
    request.files.add(multipartFile);
    // Send Data
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    // pass Class Jeson
    final result = jsonDecode(response.body) as Map<String, dynamic>;
    // Show Progress False
    setState(() {
      loading = false;
    });
    // Show Message
   // Utils().toastMessage(result.values.toString().substring(1,result.values.toString().length-1));
    print(result.values.toString().substring(1,result.values.toString().length-1));

    //
    if(result.values.toString().substring(1,result.values.toString().length-1) == "NonDemented"){
      showDialog(context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text(result.values.toString().substring(1,result.values.toString().length-1),),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('"Non Demented" is a term used to describe individuals who do not exhibit any signs of dementia or cognitive impairment. This term is often used in research studies to refer to individuals who are used as a comparison group for those who have dementia or cognitive impairment'),
                  SizedBox(height: 10,),
                ],
              ),
              //Row( Send & Close )
              actions: [
                TextButton(onPressed:(){
                  Navigator.of(context).pop();
                },
                  child: Text('Close'),),
              ],
            );
          });

    }else if (result.values.toString().substring(1,result.values.toString().length-1) == "VeryMildDemented"){
      showDialog(context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text(result.values.toString().substring(1,result.values.toString().length-1),),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('"Very Mild Demented" A very early stage of cognitive impairment that indicates or does not indicate'
                      ' Demented The very early stage of cognitive impairment is difficult to detect and may only be '
                      'noticeable to the individual experiencing it. Symptoms of mild cognitive impairment may include '
                      'slight forgetfulness, difficulty finding words, and slight difficulty with complex tasks.'
                      '\n \n Percentage from 15% \t to \t 20%'),
                  SizedBox(height: 10,),
                ],
              ),
              //Row( Send & Close )
              actions: [
                TextButton(onPressed:(){
                  Navigator.of(context).pop();
                },
                  child: Text('Close'),),
              ],
            );
          });
    }
    else if (result.values.toString().substring(1,result.values.toString().length-1) == "MildDemented"){
      showDialog(context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text(result.values.toString().substring(1,result.values.toString().length-1),),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('"Mild Demented" Mild or early stage cognitive impairment(Demented) \n Mild Cognitive (MCI) '
                      'Deterioration in cognitive function that is noticeable but not severe enough to interfere with '
                      'daily activities \n \n Percentage from 10% \t to \t 20%'),
                  SizedBox(height: 10,),
                ],
              ),
              //Row( Send & Close )
              actions: [
                TextButton(onPressed:(){
                  Navigator.of(context).pop();
                },
                  child: Text('Close'),),
              ],
            );
          });
    }else if (result.values.toString().substring(1,result.values.toString().length-1) == "ModerateDemented"){
      showDialog(context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text(result.values.toString().substring(1,result.values.toString().length-1),),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('"Moderate Demented" Moderate to severe cognitive impairment as a result of dementia refers'
                      ' to the deterioration of cognitive function, which is severe enough to interfere with daily '
                      'activities and also represents a significant impairment in memory, language and other cognitive '
                      'functions and may have difficulty in carrying out activities of daily life such as (dressing and eating).'
                      ' Mood and behavior changes, depression and anxiety \n \n Percentage from 10% \t to \t 25%'),
                  SizedBox(height: 10,),
                ],
              ),
              //Row( Send & Close )
              actions: [
                TextButton(onPressed:(){
                  Navigator.of(context).pop();
                },
                  child: Text('Close'),),
              ],
            );
          });
    }


    // if (response.statusCode == 200) {
    //   String responseBody = await response.stream.bytesToString();
    //   print(responseBody);
    // } else {
    //   print(response.reasonPhrase);
    //   print(response);
    //   print(length);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          automaticallyImplyLeading: false,
          title: Center(
            child: Text("Home",
              style: TextStyle(color: Colors.white,
                  fontSize: 25),),
          ),
          actions: [
            IconButton(onPressed: (){
              // logout in firebase
              auth.signOut().then((value){
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            // Show Image
            Container(
              margin: EdgeInsets.all(15),
              child: Center(child:_file == null ? Text("Image Not Selected") : Image.file(_file!) ,),
            ),
            //  MaterialButton(Upload Image)
            Container(
              width: double.infinity,
                margin: EdgeInsets.only(bottom:30,left: 20,right: 20),
                child: MaterialButton(onPressed:predict,
                    child:loading
                        ? Row(  //show text ("loading") && progress
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Loading...", style: TextStyle(fontSize: 20,color: Colors.white),),

                        SizedBox(width: 10,),

                        CircularProgressIndicator(
                          color: Colors.white,),
                      ],
                    ):
                    Text("Upload",
                      style: TextStyle(color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,),
                    ),
                  splashColor: Colors.blue,  // change color when pressed
                  color: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                )
            ),

          ],
        ),
        floatingActionButton:SpeedDial(
          backgroundColor: Colors.deepPurpleAccent,
          icon: Icons.camera_alt,
          overlayOpacity: 0.4,    // degree of transparency
          spaceBetweenChildren: 12,   // space icons children
          overlayColor: Colors.deepPurpleAccent,   // background
          children: [
            SpeedDialChild(     // icon Camera click open camera
              child: IconButton(onPressed:(){pickercamera("camera");},icon: Icon(Icons.camera_alt,size: 30,),),
            ),
            SpeedDialChild( //icon gallary click open Studio
              child: IconButton(onPressed:(){pickercamera("gallary");},icon: Icon(Icons.photo_album,size: 30,),),
            )
          ],
        )
    );

  }
}

// Show Classes in Model Ai
class modelResalt {
  String? classes;

  modelResalt({this.classes});

  modelResalt.fromJson(Map<String, dynamic> json) {
    classes = json['classes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['classes'] = this.classes;
    return data;
  }
}
