import 'package:flutter/material.dart';
import 'package:holkar_present/screens/sing_up/SingUpScreen.dart';
import 'package:holkar_present/utils/Coolers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Present App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          background: bg,
        ),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: const SafeArea(
        child: SingUpScreen(),
      ),
    );
  }
}
