import 'package:flutter/material.dart';
import 'package:zheimer/firebase_services/splash_services.dart';


class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  // variable pass splashServices
  SplashServices splashScreen = SplashServices();



  void initState() {
    super.initState();
    // pass splashServices
   splashScreen.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: BoxDecoration(  // image
          image: DecorationImage(image: AssetImage("images/im.jpeg"),
              fit: BoxFit.cover

          ),
        ),

        // text welcome
        child: Container(
          margin: EdgeInsets.only(top: 430),
          alignment: Alignment.center,
          child: Text("Welcome",style: TextStyle(
            fontSize: 65,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,

          ),),
        ),

      ),
    );
  }
}
