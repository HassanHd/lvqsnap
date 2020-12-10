import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'Screens/loginscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        title: 'QSNAP',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home:AnimatedSplashScreen(
            duration: 4000,
            splash: "assats/images/logowhite.png",
            nextScreen: LoginScreen(),
            splashTransition: SplashTransition.slideTransition,
            pageTransitionType: PageTransitionType.bottomToTop,
            backgroundColor: Colors.black
        )
    );
  }
}


