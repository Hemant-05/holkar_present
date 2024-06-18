import 'package:flutter/material.dart';
import 'package:holkar_present/utils/Custom/ProfileImage.dart';

class StudentCard extends StatelessWidget {
  const StudentCard({super.key, required this.map});
  final Map<String,dynamic> map;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 450,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white60,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20,top: 10),
                  child: Text(
                    map['roll'],
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            ProfileImage(file: null, size: 150, fileUrl: map['profile']),
            Text(
              map['name'],
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 150,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Email :- ${map['email']}',
                      style: cusStyle()),
                  Text('Number :- ${map['number']}',
                      style: cusStyle()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  TextStyle cusStyle([FontWeight weight = FontWeight.w600, double size = 16]) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
    );
  }
}
