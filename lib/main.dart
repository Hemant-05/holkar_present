import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:holkar_present/firebase_options.dart';
import 'package:holkar_present/screens/SplashScreen.dart';
import 'package:holkar_present/utils/Coolers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        child: SplashScreen(),
      ),
    );
  }
}
