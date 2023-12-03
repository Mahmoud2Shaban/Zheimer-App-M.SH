import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zheimer/patient/patient_page.dart';
import 'package:zheimer/ui/auth/signup_screen.dart';
import 'package:zheimer/ui/page/doctor_page.dart';
import 'package:zheimer/ui/auth/forget_pass.dart';
import 'package:zheimer/patient/family/family_login.dart';
import 'package:zheimer/utils/utils.dart';
import '../../components/curve_cliper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  // Key validator
  final _formKey =GlobalKey<FormState>();
  //variable textformfield
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  //show password
  bool pass = true;
  //show progress
  bool loading = false;
  // Firebase Auth
  FirebaseAuth _auth = FirebaseAuth.instance;

  // realtime database
  //final databaseRef = FirebaseDatabase.instance.ref("UserData");

  // Function Realtime Database

  // void login(){
  //   setState(() {
  //     loading = true;
  //   });
  //   _auth.signInWithEmailAndPassword(
  //       email: emailController.text.trim(),
  //       password: passwordController.text.toString()).then((value){
  //         Utils().toastMessage(value.user!.email.toString());
  //         Navigator.push(context,
  //             MaterialPageRoute(builder: (context)=>DoctorPage()));
  //         setState(() {
  //           loading = false;
  //         });
  //   }).onError((error, stackTrace) {
  //     debugPrint(error.toString());
  //     Utils().toastMessage(error.toString());
  //     setState(() {
  //       loading = false;
  //     });
  //   });
  // }

  //Function Check user Doctor or Patient
  void route(){
    // Show Progress True
    setState(() {
      loading = true;
    });
    try{
      User? user = FirebaseAuth.instance.currentUser;
      // Table Name(UserData)
      var kk = FirebaseFirestore.instance.collection("UserData")
          .doc(user!.uid).get()
          .then((DocumentSnapshot documentSnapshot) {
        if(documentSnapshot.exists){
          if(documentSnapshot.get("Gender :") == 'Doctor'){
            Navigator.push(context,
                MaterialPageRoute(builder: (context)=>DoctorPage()));
            // Show Progress False
            setState(() {
              loading = false;
            });
          }else{
            Navigator.push(context,
                MaterialPageRoute(builder: (context)=>PatientPage()));
            // Show Progress False
            setState(() {
              loading = false;
            });
          }
        }
      });
    }catch(error){
      debugPrint(error.toString());
      // Show Message Error
      Utils().toastMessage(error.toString());
      // Show Progress False
      setState(() {
        loading = false;
      });
    }
  }
  // Function Login in Firebase Database
  void login(){
    setState(() {
      loading = true;
    });
    // signInWithEmailAndPassword
    _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.toString()).then((value){
          // Show Message Name User
      Utils().toastMessage(value.user!.email.toString());
      // Function Check Doctor or Patient
      route();
      // Show Progress False
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      // Show Message Error
      Utils().toastMessage(error.toString());
      // Show Progress False
      setState(() {
        loading = false;
      });
    });
  }
  // Firebase Token
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState(){
    super.initState();
    messaging.getToken().then((token){
      print("the token is :" + token!);
    } );
  }

  @override
  void dispose(){
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }



  @override
  Widget build(BuildContext context) {
    // return page
    return WillPopScope(
      onWillPop: ()async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
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
              SizedBox(height: 90,),
              Form(
                // pass key validator
                  key: _formKey,
                  child: Column(
                    children: [
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
                            return null;
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
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  )
              ),
              //TextButton(Forgot password?)
              Container(
                alignment: Alignment.topRight,
                child: TextButton(onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context)=>ForgetPass()));
                },
                child: Text("Forgot password?",style: TextStyle(color: Colors.deepPurple),),),
              ),

              SizedBox(height: 50,),
              //MaterialButton(Login)
              Container(
              margin: EdgeInsets.symmetric( horizontal: 10),
              width: 340,
              height: 50,
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
              // MaterialButton(login)
              child: MaterialButton(
                // Validate Check
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    login();
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
                Text("Login",
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
              SizedBox(height: 15,),
              //TextButton(I Am Family)
              Container(
                margin: EdgeInsets.only(left: 40),
                alignment: Alignment.topLeft,
                child: TextButton(onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context)=>FamilyPage()));
                },
                  child: Text("I am family",style: TextStyle(color: Colors.deepPurple),),),
              ),
              //SizedBox(height: 100,),
              SizedBox(height: 35,),
              // Text("Don't have an account?") & TextButton("Sign Up")
              Container(
                margin: EdgeInsets.only(top: 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(onPressed: (){
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context)=>SignUpScreen()));
                    },
                        child: Text("Sign Up",style: TextStyle(color: Colors.deepPurple),) )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
