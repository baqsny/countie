import 'dart:async';

import 'package:countie/screens/sign_in_screen.dart';
import 'package:countie/services/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import 'HomePage.dart';

var finalToken;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SecureStorage secureStorage = SecureStorage();
  @override
  void initState() {
    secureStorage.readSecureData("token").then((value) {
      finalToken = value;
    });
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            PageTransition(
                child: finalToken == null ? LoginScreen() : HomePage(),
                type: PageTransitionType.rightToLeftWithFade,
                duration: Duration(milliseconds: 1000))));
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(),
              SizedBox(
                child: Text(
                  "Countie",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 40),
                  ),
                ),
              ),
              LinearProgressIndicator(
                minHeight: 20,
              )
            ]),
      ),
    );
  }
}
