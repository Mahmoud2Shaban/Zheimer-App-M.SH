import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zheimer/patient/patient_page.dart';
import 'package:zheimer/ui/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zheimer/ui/page/doctor_page.dart';
import 'package:zheimer/utils/utils.dart';
import '../../components/curve_cliper.dart';
import 'package:location/location.dart' as loc;



class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  // Variable Location
  final loc.Location location = loc.Location();
  // Variable Enable Location
  StreamSubscription<loc.LocationData>? _locationSubscription;



  // Key validator
  final _formKey =GlobalKey<FormState>();
  //variable textformfield
  final fullnameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  // variable Doctor & patient
  String gender="";
  //show password
  bool pass = true;
  bool confpass = true;
  // show progress
  bool loading = false;
  // Firebase Auth
  FirebaseAuth _auth = FirebaseAuth.instance;

  // realtime database
  //final databaseRef = FirebaseDatabase.instance.ref("UserData");

  // id
  String id = DateTime.now().microsecondsSinceEpoch.toString();
  // Firebase Token
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  // Variable token
  final tokening ='';


  @override
  void dispose(){
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  // function create acount with email & password & show message error & show progress when click button
  // void signup(){
  //   setState(() {
  //     loading = true;
  //   });
  //   _auth.createUserWithEmailAndPassword(
  //       email: emailController.text.trim(),
  //       password: passwordController.text.toString()).then((value) {
  //     databaseRef.child(id).set({
  //       "id :" :id,
  //       "Name :" :fullnameController.text.toString(),
  //       "Phone Number :" :phoneController.text.toString(),
  //       "Email Address :" :emailController.text.toString(),
  //       "Password :" :passwordController.text.toString(),
  //       "Gender :" :gender.toString(),
  //     }).then((value){
  //       Utils().toastMessage("Create Account Successfully");
  //       Navigator.push(context,
  //           MaterialPageRoute(builder: (context)=>DoctorPage()));
  //       setState(() {
  //         loading = false;
  //       });
  //     });
  //   }).onError((error, stackTrace){
  //     Utils().toastMessage(error.toString());
  //     setState(() {
  //       loading = false;
  //     });
  //   });
  // }

  // Firebase
  void signup() async{
    setState(() {
      loading = true;
    });
    // location sive
    final loc.LocationData _locationResult = await location.getLocation();
    //firebase create with email & password
    final newuser = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(), password: passwordController.text).then((value){
          var user = _auth.currentUser;
          // create table userData->uid
          // Get Token & Save Token in Firebase Table(UserData)
          messaging.getToken().then((tokening){
            FirebaseFirestore.instance.collection('UserData').doc(user!.uid).set({
              "id :" :id,
              "Name :" :fullnameController.text.toString(),
              "Phone Number :" :phoneController.text.toString(),
              "Email Address :" :emailController.text.toString(),
              "Password :" :passwordController.text.toString(),
              "Token":tokening,
              'latitude': _locationResult.latitude,
              'longitude': _locationResult.longitude,
              "Gender :" :gender.toString(),
            }, SetOptions(merge: true));
          } );
      // FirebaseFirestore.instance.collection('UserData').doc(user!.uid).set({
      //   "id :" :id,
      //   "Name :" :fullnameController.text.toString(),
      //   "Phone Number :" :phoneController.text.toString(),
      //   "Email Address :" :emailController.text.toString(),
      //   "Password :" :passwordController.text.toString(),
      //   "Token":tokening,
      //   "Gender :" :gender.toString(),
      // });

      // Check user Doctor or Patient
        if(value != null){
          if(gender == 'Doctor'){
            // Show Message Successfully
            Utils().toastMessage("Create Account Successfully");
            Navigator.push(context,
                MaterialPageRoute(builder: (context)=>DoctorPage()));
            // show Progress False
            setState(() {
              loading = false;
            });

          }else if(gender == 'Patient'){
            var users = _auth.currentUser;
            FirebaseFirestore.instance.collection('Family').doc(users!.uid).set({
              "id :" :id,
              "Name :" :fullnameController.text.toString(),
              "Phone Number :" :phoneController.text.toString(),
              "Email Address :" :emailController.text.toString(),
              "Password :" :passwordController.text.toString(),
              "Type :" : "Family",
            },);
            // Show Message Successfully
            Utils().toastMessage("Create Account Successfully");
            Navigator.push(context,
                MaterialPageRoute(builder: (context)=>PatientPage()));
            // show Progress False
            setState(() {
              loading = false;
            });
          }
        }

    } );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // top backgroundimage -> open(lib->components->curve_cliper)
            ClipPath(
              clipper: CurveCliper(),
              child: Image(
                width: double.infinity,
                fit: BoxFit.cover,   //casing
                image: AssetImage('images/images3.jpeg'),
              ),
            ),
            Form(
              // pass key validator
                key: _formKey,
                child: Column(
                  children: [
                    // TextFormField(Full Name)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        // variable FullName
                        controller: fullnameController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: "Full Name",
                          suffixIcon: Icon(Icons.person,color: Colors.deepPurple),
                        ),
                        // Validator check fullname
                        validator: (value){
                          if(value!.length >=3){    // less than 3 letters are not accepted
                            return null;
                          }if(value .isEmpty){
                            return 'Please enter name';
                          }else{
                            return 'Enter valid value';
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    // TextFormField(phone)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        // variable phone
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 11,
                        decoration: InputDecoration(
                          hintText: "Phone Number",
                          suffixIcon: Icon(Icons.phone,color: Colors.deepPurple),
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
                    SizedBox(height: 10,),
                    // TextFormField(email)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        // variable email
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Email",
                          suffixIcon: Icon(Icons.email,color: Colors.deepPurple),
                        ),
                        // Validator check email
                        validator: (value){
                          if(value!.isEmpty){
                            return "Enter email";
                          }
                          if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                            return "Please enter valid email";

                          }else{
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    // TextFormField(password)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        // variable password
                        controller: passwordController,
                        // Show password
                        obscureText: pass,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Password",
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  pass = !pass;  //show password & hide password
                                });
                              },
                              // Change Icon
                              icon: Icon(pass
                                  ? Icons.visibility_off
                                  : Icons.visibility,color: Colors.deepPurple,)),
                        ),
                        // validator check password
                        validator: (value){
                          if(value!.isEmpty){
                            return "Enter password";
                          }if(value.length <6){    // less than 6 are not accepted
                            return 'The password is weak';
                          }else{
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    // TextFormField(confirmpassword)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        // variable confirmpassword
                        controller: confirmpasswordController,
                        // Show confirmpassword
                        obscureText: confpass,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  confpass = !confpass;  //show password & hide password
                                });
                              },
                              // Change Icon
                              icon: Icon(confpass
                                  ? Icons.visibility_off
                                  : Icons.visibility,color: Colors.deepPurple,)),
                        ),
                        // validator check confirmpassword
                        validator: (value){
                          if(value!.isEmpty){
                            return "Enter confirm password";
                          }if(passwordController.text != confirmpasswordController.text){
                            return "Password Do not match";

                          }else{
                            return null;
                          }
                        },
                      ),
                    ),
                     Container(
                     // padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Radio(value:"Doctor", groupValue: gender, onChanged: (val){
                            setState(() {
                              gender=val!;
                            });
                          }),
                          Text("Doctor",style: TextStyle(fontSize: 25),),

                          SizedBox(width: 55,),

                          Radio(value:"Patient", groupValue: gender, onChanged: (val){
                            setState(() {
                              gender=val!;
                            });
                          }),
                          Text("Patient",style: TextStyle(fontSize: 25),)
                        ],
                      ),
                    ),
                  ],
                )
            ),
            SizedBox(height: 50,),
            Container(// MaterialButton(Sign Up)
              margin: EdgeInsets.symmetric( horizontal: 10),
              width: 340,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  // Show button 3D
                  boxShadow: [
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
              // MaterialButton(Sign Up)
              child: MaterialButton(
                // Validate Check
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    signup();
                  }
                },

                //loading ? CircularProgressIndicator(strokeWidth: 3,color: Colors.white,):
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
                Text("Sign Up",
                  style: TextStyle(color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,),
                ),
                splashColor: Colors.blue,  // change color when pressed
                color: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
              ),
            ),
            SizedBox(height: 30,),
            // Text("Already have an account?") & TextButton("Login")
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?"),
                TextButton(onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context)=>LoginScreen()));
                },
                    child: Text("Login",style: TextStyle(color: Colors.deepPurple),) )
              ],
            )
          ],
        ),
      ),
    );
  }

}
