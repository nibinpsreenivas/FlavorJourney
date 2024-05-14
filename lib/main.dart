import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:FlavorJourney/SplashScreen.dart';
import 'package:FlavorJourney/providers/user_provider.dart';
import 'package:FlavorJourney/responsive/mobile_screen_layout.dart';
import 'package:FlavorJourney/responsive/responsive_layout_screen.dart';
import 'package:FlavorJourney/responsive/web_screen_layout.dart';
import 'package:FlavorJourney/screens/login_screen.dart';
import 'package:FlavorJourney/utils/colors.dart';
import 'package:FlavorJourney/utils/my_theme.dart';

import 'package:provider/provider.dart';
import 'package:camera/camera.dart';

List<CameraDescription>? cameras;
void main() async {
 

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 255, 250, 230)));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
      ],
      builder: (context, _) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Hellogram',
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return const ResponsiveLayout(
                        webScreenLayout: WebSreenLayout(),
                        mobileScreenLayout: MobileScreenLayout());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('${snapshot.error}'),
                    );
                  }
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  );
                }

                return SplashScreen();
              },
            ));
      },
    );
  }
}
