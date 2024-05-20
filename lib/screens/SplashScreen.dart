import 'dart:async';

import 'package:flutter/material.dart';
import 'package:holkar_present/screens/LogInScreen.dart';
import 'package:holkar_present/utils/Constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LogInScreen(),));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: bg,
      body: Center(
        child: Image.asset(holkar_logo),
      ),
    );
  }
}
