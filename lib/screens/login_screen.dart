import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:FlavorJourney/resources/auth_methods.dart';
import 'package:FlavorJourney/screens/signup_screen.dart';
import 'package:FlavorJourney/utils/colors.dart';
import 'package:FlavorJourney/utils/global_variables.dart';
import 'package:FlavorJourney/utils/utils.dart';
import 'package:FlavorJourney/widgets/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser(String uid, String password) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: uid, password: password)
          .then((uid) => {
                //Fluttertoast.showToast(msg: "Login Successful"),
              });
      User? user = _auth.currentUser!;

      var db = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      var userData = db.data()!;

      if (userData['admin'] != 'yes') {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const ResponsiveLayout(
                  webScreenLayout: WebSreenLayout(),
                  mobileScreenLayout: MobileScreenLayout()),
            ),
            (route) => false);
      } else {
        Fluttertoast.showToast(msg: "This user id is invalid");
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  void navigateToSignup() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SignUpScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        color: Color.fromARGB(255, 255, 250, 230),
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //SVG image
                Image.asset(
                  "assets/hello.png",
                  height: 300,
                  //width: 200,
                ),
                const SizedBox(height: 5),
                //Text filed input for email
                TextFieldInput(
                    textEditingController: _emailController,
                    hintText: "Enter your email",
                    textInputType: TextInputType.emailAddress),

                //Text filed input for password
                const SizedBox(height: 24),

                TextFieldInput(
                  textEditingController: _passwordController,
                  hintText: "Enter your password",
                  textInputType: TextInputType.text,
                  isPass: true,
                ),
                const SizedBox(height: 24),
                //Button Login
                InkWell(
                  onTap: () => loginUser(
                      _emailController.text, _passwordController.text),
                  child: Container(
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : const Text("Login"),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 255, 95, 0),
                          Color.fromARGB(255, 255, 159, 102),
                        ])),
                  ),
                ),
                const SizedBox(height: 12),

                //Transitioning to Signing Up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.black),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    GestureDetector(
                      onTap: () => navigateToSignup(),
                      child: Container(
                        child: const Text(
                          " Sign up.",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
