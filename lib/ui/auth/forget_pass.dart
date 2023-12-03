import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zheimer/components/curve_cliper.dart';


class ForgetPass extends StatefulWidget {
  @override
  State<ForgetPass> createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {

  //variable Email
  final emailcontroller = TextEditingController();

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
          // text message
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
            //Enter Your Email and we will send you a password reset link
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text("Enter Your Email and we will send you a password reset link",
                textAlign: TextAlign.center,),
            ),
            SizedBox(height: 10,),
            //TextFormField(E-mail address)
            Container(
              margin: EdgeInsets.only(top: 5,left: 15,right: 15),
              child: TextFormField(
                controller: emailcontroller,   // variable email
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: "E-mail",
                    hintText: "E-mail address",
                    suffixIcon:Icon(Icons.mail),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    )
                ),
              ),
            ),
            SizedBox(height: 30,),
            //MaterialButton(Reset Password)
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
              child: MaterialButton(onPressed: passwordReset,
                splashColor: Colors.blue,  // change color when pressed
                color: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Text("Reset Password",
                  style: TextStyle(color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                )
                  ,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
