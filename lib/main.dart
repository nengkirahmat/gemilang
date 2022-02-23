import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lgp/login_page.dart';
import 'package:lgp/main_page.dart';
import 'package:lgp/my_session.dart';
import 'package:lgp/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void myState() async {
    MySession.instance.getStringValue("username").then((value) => setState(() {
          username = value;
        }));

    MySession.instance.getBooleanValue("loggedin").then((value) => setState(() {
          isLoggedIn = value;
        }));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    myState();
    setState(() {});
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(fontFamily: GoogleFonts.openSans().fontFamily),
        home: SplashScreen(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
