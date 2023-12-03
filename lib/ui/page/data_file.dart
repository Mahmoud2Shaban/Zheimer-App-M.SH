import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zheimer/utils/utils.dart';


class DataFile extends StatefulWidget {
  @override
  State<DataFile> createState() => _DataFileState();
}

class _DataFileState extends State<DataFile> {

  // Key validator
  final _formKey =GlobalKey<FormState>();
  //variable textformfield
  final fullnameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final chronicController = TextEditingController();
  final proviousController = TextEditingController();
  final diagnosisController = TextEditingController();
  //variable date_birth
  TextEditingController date_birth = TextEditingController();
  //variable discolsure_date
  TextEditingController discolsure_date = TextEditingController();
  // variable male & female
  String gender="";
  // varible date of birth
  DateTime dateTime=DateTime.now();
  //variable Discolsure Date
  DateTime dateTimes=DateTime.now();
  //show progress
  bool loading = false;
  // Firebase Auth
  FirebaseAuth _auth = FirebaseAuth.instance;

  // realtime database
  //final databaseRef = FirebaseDatabase.instance.ref("PatientData");

  // id
  String id = DateTime.now().microsecondsSinceEpoch.toString();


  // function save patient data& show message error & show progress when click button
  // Realtime Database
  // void savedata(){
  //   setState(() {
  //     loading = true;
  //   });
  //     databaseRef.child(id).set({
  //       "id :" :id,
  //       "Name :" :fullnameController.text.toString(),
  //       "Address :" :addressController.text.toString(),
  //       "Phone Number :" :phoneController.text.toString(),
  //       "Date Of Birth :" :date_birth.text.toString(),
  //       "Discolsure Date :" :discolsure_date.text.toString(),
  //       "Chronic Diseases :" :chronicController.text.toString(),
  //       "Provious Operations :" :proviousController.text.toString(),
  //       "Diagnosis :" :diagnosisController.text.toString(),
  //       "Gender :" :gender.toString(),
  //     }).then((value){
  //       setState(() {
  //         Utils().toastMessage("Data saved successfully");
  //         loading = false;
  //         fullnameController.clear();
  //         addressController.clear();
  //         phoneController.clear();
  //         date_birth.clear();
  //         discolsure_date.clear();
  //         chronicController.clear();
  //         proviousController.clear();
  //         diagnosisController.clear();
  //       });
  //     }).onError((error, stackTrace){
  //     Utils().toastMessage(error.toString());
  //     setState(() {
  //       loading = false;
  //       fullnameController.clear();
  //       addressController.clear();
  //       phoneController.clear();
  //       date_birth.clear();
  //       discolsure_date.clear();
  //       chronicController.clear();
  //       proviousController.clear();
  //       diagnosisController.clear();
  //     });
  //   });
  // }


  // Firebase
  // Database name table PatientData
  CollectionReference users = FirebaseFirestore.instance.collection('PatientData');
  void Savedata(){
    // Show Progress True
    setState(() {
      loading = true;
    });
    // add data inside the user's email
    String? email = FirebaseAuth.instance.currentUser!.email;
    // name table database data
    users.doc(email).collection('data').add({
      "id" :id,
      "Name" :fullnameController.text.toString(),
      "Address" :addressController.text.toString(),
      "Phone Number" :phoneController.text.toString(),
      "Date Of Birth" :date_birth.text.toString(),
      "Discolsure Date" :discolsure_date.text.toString(),
      "Chronic Diseases" :chronicController.text.toString(),
      "Provious Operations" :proviousController.text.toString(),
      "Diagnosis" :diagnosisController.text.toString(),
      "Gender" :gender.toString(),
      'Time' : DateTime.now(),
    }).then((value){
      setState(() {
        // show Message Successfully and clear data
        Utils().toastMessage("Data saved successfully");
        // Show Progress False & Clear Data
        loading = false;
        fullnameController.clear();
        addressController.clear();
        phoneController.clear();
        date_birth.clear();
        discolsure_date.clear();
        chronicController.clear();
        proviousController.clear();
        diagnosisController.clear();
      });
    }).onError((error, stackTrace){
      // show Message error and clear data
      Utils().toastMessage(error.toString());
      // Show Progress False & Clear Data
      setState(() {
        loading = false;
        fullnameController.clear();
        addressController.clear();
        phoneController.clear();
        date_birth.clear();
        discolsure_date.clear();
        chronicController.clear();
        proviousController.clear();
        diagnosisController.clear();
      });
    });
  }

  // Image
  File? selectedImage;
  //Image
  String base64Image = "";
// function check camera and gallary
  Future<void> chooseImage(type) async{
    var image;
    if(type == 'camera'){
      //storage image in camera
      image = await ImagePicker().pickImage(source: ImageSource.camera);
    }else{
      //storage image in Gallery
      image = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    if(image != null){
      setState(() {
        //pass image taken from the camera
        selectedImage = File(image.path);
        //print(selectedImage.toString());
        base64Image =base64Encode(selectedImage!.readAsBytesSync());
      });
    }
  }


// Function Model
  // Future<void> makeRequest() async {
  //   var url = Uri.parse("http://127.0.0.1:8000/predict");
  //   var imagePath = "images/images3.jpeg";
  //   print(imagePath);
  //   var file = imagePath;
  //   var length = await file.length;
  //   print(length);
  //   var request = http.MultipartRequest('POST', url)
  //     ..files.add(await http.MultipartFile.fromPath('file', imagePath));
  //   var response = await request.send();
  //   var responseBody = await response.stream.bytesToString();
  //   var jsonResponse = jsonDecode(responseBody);
  //   print("ZHIMAR Type for this Image is : ${jsonResponse['class']}");
  // }


// Function Model
  // Future<void> predict() async {
  //   var request = http.MultipartRequest(
  //     'POST',
  //     Uri.parse('https://new-app1.herokuapp.com/prediction/'),
  //   );
  //
  //   var image = selectedImage;
  //   var stream = http.ByteStream(image!.openRead());
  //   var length = await image.length();
  //
  //   var multipartFile = http.MultipartFile(
  //     'image', stream, length, filename: image.path.split('/').last,
  //   );
  //
  //   request.files.add(multipartFile);
  //
  //   var streamedResponse = await request.send();
  //   var response = await http.Response.fromStream(streamedResponse);
  //   final result = jsonDecode(response.body) as Map<String, dynamic>;
  //   print(result.values.toString().substring(1,result.values.toString().length-1));
  //
  //   // if (response.statusCode == 200) {
  //   //   String responseBody = await response.stream.bytesToString();
  //   //   print(responseBody);
  //   // } else {
  //   //   print(response.reasonPhrase);
  //   //   print(response);
  //   //   print(length);
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text("Patient Data",
            style: TextStyle(color: Colors.white,fontSize: 25),),),
      ),
      body: Form(
        // pass key validator
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              //TextFormField(Patient Triple Name)
              Container(
                margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                width: double.infinity,
                child: TextFormField(
                  // pass variable patient_name
                  controller:fullnameController ,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: "Patient Triple Name",
                    suffixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    )
                  ),
                  // Validator check fullname
                  validator: (value){
                    if(value!.length >=6){    // less than 6 letters are not accepted
                      return null;
                    }if(value .isEmpty){
                      return 'Please enter name';
                    }else{
                      return 'Enter valid value';
                    }
                  },
                ),
              ),
              //TextFormField(Address)
              Container(
                margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                width: double.infinity,
                child: TextFormField(
                  // pass variable address
                  controller: addressController,
                  keyboardType: TextInputType.streetAddress,
                  decoration: InputDecoration(
                      hintText: "Address",
                      suffixIcon: Icon(Icons.add_location),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      )
                  ),
                  // Validator check address
                  validator: (value){
                    if(value!.isEmpty){
                      return "Enter address";
                    }else{
                      return null;
                    }
                  },
                ),
              ),
              //TextFormField(Phone Number)
              Container(
                margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                width: double.infinity,
                child: TextFormField(
                  // pass variable phone_number
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 11,
                  decoration: InputDecoration(
                      hintText: "Phone Number",
                      suffixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      )
                  ),
                  // Validator check phone
                  validator: (value){
                    if(value!.isEmpty){
                      return "Enter phone";
                    }if(value.length <11){   // less than 11 digits are not accepted
                      return "Please enter valid phone";
                    }else{
                      return null;
                    }
                  },
                ),
              ),
              //TextFormField(Date of Birth)
              Container(
                margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                width: double.infinity,
                child: TextFormField(
                  //read only
                  readOnly: true,
                  // pass variable date_birth
                  controller: date_birth,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                      hintText: "Date of Birth",
                      suffixIcon:  IconButton(onPressed: () {
                        setState(() {
                          // click icon show date
                          showDatePicker(context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now(),).then((value) {
                            setState(() {
                              dateTime=value!;
                              // show data in textfromfield
                              final DateFormat formatter = DateFormat("dd-MM-yyyy");
                              final String formatted = formatter.format(value);
                              date_birth.text=formatted;
                            });
                          });
                        });
                      },icon: Icon(Icons.date_range,),),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      )
                  ),
                  // Validator check Date of Birth
                  validator: (value){
                    if(value!.isEmpty){
                      return "Enter Date of Birth";
                    }else{
                      return null;
                    }
                  },
                ),
              ),
              //TextFormField(Discolsure Date)
              Container(
                margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                width: double.infinity,
                child: TextFormField(
                  // read only
                  readOnly: true,
                  // pass variable discolsure_date
                  controller: discolsure_date,
                  decoration: InputDecoration(
                      hintText: "Discolsure Date",
                      suffixIcon: IconButton(onPressed: (){
                        setState(() {
                          //click icon show date
                          showDatePicker(context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now(),).then((value) {
                            setState(() {
                              dateTimes=value!;
                              // show data in textfromfield
                              final DateFormat formatter = DateFormat("dd-MM-yyyy");
                              final String formatted = formatter.format(value);
                              discolsure_date.text=formatted;

                            });
                          });
                        });
                      },icon: Icon(Icons.date_range,),),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      )
                  ),
                  // Validator check Discolsure Date
                  validator: (value){
                    if(value!.isEmpty){
                      return "Enter Discolsure Date";
                    }else{
                      return null;
                    }
                  },
                ),
              ),
              //TextFormField(Chronic Diseases)
              Container(
                margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                width: double.infinity,
                child: TextFormField(
                  // pass variable chronic_diseases
                  controller: chronicController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: "Chronic Diseases",
                      suffixIcon: Icon(Icons.lightbulb),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      )
                  ),
                  // Validator check Chronic Diseases
                  validator: (value){
                    if(value!.isEmpty){
                      return "Enter Chronic Diseases";
                    }else{
                      return null;
                    }
                  },
                ),
              ),
              //TextFormField(Provious Operations)
              Container(
                margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                width: double.infinity,
                child: TextFormField(
                  // pass variable previous_operations
                  controller: proviousController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      hintText: "Provious Operations",
                      suffixIcon: Icon(Icons.lightbulb),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      )
                  ),
                  // Validator check provious Operation
                  validator: (value){
                    if(value!.isEmpty){
                      return "Enter provious Operation";
                    }else{
                      return null;
                    }
                  },
                ),
              ),
              //TextFormField(Diagnosis)
              Container(
                margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                child: TextFormField(
                  maxLines: 5,
                  controller: diagnosisController,  // pass variable diagnosis
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: "Diagnosis",
                      border: OutlineInputBorder(
                        //borderRadius: BorderRadius.circular(15),
                      )
                  ),
                  // Validator check Diagnosis
                  validator: (value){
                    if(value!.isEmpty){
                      return "Enter Diagnosis";
                    }else{
                      return null;
                    }
                  },
                ),
              ),
              // Radio(Male & Female
              Container(
                // padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Radio(value:"Male", groupValue: gender, onChanged: (val){
                      setState(() {
                        gender=val!;
                      });
                    }),
                    Text("Male",style: TextStyle(fontSize: 25),),

                    SizedBox(width: 55,),

                    Radio(value:"Female", groupValue: gender, onChanged: (val){
                      setState(() {
                        gender=val!;
                      });
                    }),
                    Text("Female",style: TextStyle(fontSize: 25),)
                  ],
                ),
              ),


              // Container(
              //   margin: EdgeInsets.only(top: 20,right: 15,left: 15),
              //   height: 400,
              //   width: double.infinity,
              //
              //   decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(10),
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.deepPurple,
              //           spreadRadius: 1,
              //           blurRadius: 8,
              //           offset: Offset(4,2),
              //         ),
              //         BoxShadow(
              //           color: Colors.white54,
              //           spreadRadius: 2,
              //           blurRadius: 8,
              //           offset: Offset(-4,-4),
              //
              //         ),
              //       ]
              //   ),
              //   child:  Column(
              //     //crossAxisAlignment: CrossAxisAlignment.end,
              //     children: [
              //       Container(
              //         margin: EdgeInsets.all(15),
              //         height: 250,
              //         width: 280,
              //         child: Center(child:selectedImage == null ? Text("Image Not Selected") : Image.file(selectedImage!) ,),
              //       ),
              //       TextButton(onPressed:predict, child: Text("Upload")),
              //       //(){uploadImg([selectedImage!]);}
              //
              //       SizedBox(height: 5,),
              //       //SizedBox(height: 20,),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //         children: [
              //           Container(
              //             //margin: EdgeInsets.only(top: 80),
              //             // Camera
              //             child: FloatingActionButton(
              //               onPressed: (){
              //                 chooseImage("camera");
              //                 },
              //               child: Icon(Icons.camera_alt),
              //             backgroundColor: Colors.deepPurpleAccent,
              //             ), //camera
              //           ),
              //
              //           Container(
              //              // margin: EdgeInsets.only(top: 80),
              //               // Gallary
              //               child: FloatingActionButton(
              //                 onPressed: (){
              //                   chooseImage("Gallery");
              //                 },
              //                 child: Icon(Icons.photo_album),
              //                 backgroundColor: Colors.deepPurpleAccent,
              //               )
              //           )
              //         ],
              //       ),
              //     ],
              //   ),
              //
              // ),

              // MaterialButton(Save)
              Container(
                margin: EdgeInsets.symmetric( vertical: 30,horizontal: 10),
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      // Show button 3D
                      BoxShadow(
                        color: Colors.deepPurple,
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(4,4),
                      ),
                      BoxShadow(
                        color: Colors.white,
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(-4,-4),
                      ),
                    ]
                ),
                child: MaterialButton(
                  onPressed: (){
                    if(_formKey.currentState!.validate()){
                      Savedata();
                    }
                  },
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
                Text("Save Data",
                  style: TextStyle(color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,),
                ),
                    splashColor: Colors.blue,  // change color when pressed
                    color: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),),
              )

            ],
          ),
        ),
      ),
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
