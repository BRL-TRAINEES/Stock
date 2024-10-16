import 'package:flutter/material.dart';
import 'package:stock_app/Pages/HomePage.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';


class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
          splash: Container(
            child: Lottie.asset('assests/Animations/Animation - 1729096221336.json',
            fit: BoxFit.cover,
              height: 800,
            ),
          ),
          nextScreen: HomePage(),
        splashIconSize: 290,
        backgroundColor: Color.fromRGBO(40, 50, 90,1),
      )
    );
  }
}
