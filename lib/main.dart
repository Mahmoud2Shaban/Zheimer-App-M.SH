import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zheimer/provider/theme_settings.dart';
import 'package:zheimer/ui/auth/login_screen.dart';
import 'package:zheimer/ui/first_page.dart';

void main() async{

  //firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Disaply Notification
  await AndroidAlarmManager.initialize();

  // Change theme & Save Theme
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final isDark = sharedPreferences.getBool('is_dark') ?? false;

  runApp(MyApp(isDark: isDark));
}

class MyApp extends StatelessWidget {
  // Variable Change Theme
  final bool isDark;
  const MyApp({super.key,
  required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Change Theme
      create: (context) => ThemeSettings(isDark),
      builder: (context, snapshot) {
        //final settings = context.read<ThemeSettings>();
        final settings = Provider.of<ThemeSettings>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          // theme color
          theme: settings.currentTheme,
          //home: LoginScreen(),
          home: SplashScreen(),
          //home: LoginScreen(),
        );
      },
    );
  }
}


