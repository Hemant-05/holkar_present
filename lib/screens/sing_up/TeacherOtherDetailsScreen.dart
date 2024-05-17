import 'package:flutter/material.dart';
import 'package:holkar_present/screens/HomeScreen.dart';
import 'package:holkar_present/utils/Custom/AuthElevetedButton.dart';
import 'package:holkar_present/utils/Custom/HeightGap.dart';
import 'package:holkar_present/utils/Custom/ProfileImage.dart';

class TeacherOtherDetailsScreen extends StatefulWidget {
  const TeacherOtherDetailsScreen({super.key, required this.details});

  final Map<String, dynamic> details;

  @override
  State<TeacherOtherDetailsScreen> createState() =>
      _TeacherOtherDetailsScreenState();
}

class _TeacherOtherDetailsScreenState extends State<TeacherOtherDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Welcome \n${widget.details['name'].split(' ').first} Sir',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                ProfileImage(
                  file: widget.details['file'],
                  size: 120,
                ),
              ],
            ),
            Expanded(child: SingleChildScrollView(
              child: Column(
                children: [
                  const HeightGap(height: 20),
                  Text(
                    '${widget.details['name'].split(' ').first} sir please enter the details',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const HeightGap(height: 20),
                ],
              ),
            ),),
            const HeightGap(height: 10),
            AuthElevatedButton(
                text: 'Create an Account',
                fun: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                }),
            const HeightGap(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
