import 'dart:async';

import 'package:lgp/login_page.dart';
import 'package:lgp/main_page.dart';
import 'package:lgp/my_session.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  initScreen(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //         alignment: Alignment.topCenter,
        //         image: AssetImage("images/splash_image.png"),
        //         fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                "images/splash_image.png",
                fit: BoxFit.cover,
              ),
            ),
            // Container(
            //   child: Text(
            //     "PT. LIVINA GEMILANG PLASTINDO",
            //     style: TextStyle(
            //         fontWeight: FontWeight.bold,
            //         fontSize: 40,
            //         color: Color.fromARGB(255, 33, 31, 31)),
            //   ),
            // ),
            Padding(padding: EdgeInsets.only(top: 20)),
            SizedBox(
              height: 20,
            ),
            SleekCircularSlider(
              min: 0,
              max: 100,
              initialValue: 100,
              appearance: CircularSliderAppearance(
                  infoProperties: InfoProperties(
                      mainLabelStyle:
                          TextStyle(color: Colors.grey, fontSize: 15)),
                  customColors: CustomSliderColors(
                      dotColor: Colors.white,
                      progressBarColor: Color.fromARGB(255, 32, 2, 143),
                      shadowColor: Colors.white,
                      trackColor: Colors.white),
                  spinnerDuration: 5,
                  animDurationMultiplier: 5,
                  animationEnabled: true,
                  startAngle: 0,
                  angleRange: 360),
            ),
            Text(
              'Initializing App...',
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = Duration(seconds: 5);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => (isLoggedIn) ? MainPage() : LoginPage(),
        ));
  }

  Widget build(BuildContext context) {
    return initScreen(context);
  }
}
