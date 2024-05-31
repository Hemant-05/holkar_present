import 'package:flutter/material.dart';
import 'package:holkar_present/utils/Custom/ProfileImage.dart';

class StudentCard extends StatelessWidget {
  const StudentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 450,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Hemant sahu',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            ProfileImage(file: null, size: 150, fileUrl: ''),
            Container(
              height: 150,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Roll No. :- 66',
                      style: cusStyle()),
                  Text('Father\'s name :- Mr. Shankar lal sahu',
                      style: cusStyle()),
                  Text('Contact :- 9098752169',
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
