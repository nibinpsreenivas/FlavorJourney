import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:FlavorJourney/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 250, 230),
      body: Center(
        child: AnimatedSplashScreen(
          splash: SizedBox(height: 400, child: Image.asset("assets/hello.png")),
          nextScreen: LoginScreen(),
          splashTransition: SplashTransition.scaleTransition,
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}
