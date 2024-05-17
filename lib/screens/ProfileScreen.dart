import 'package:flutter/material.dart';
import 'package:holkar_present/utils/Constants.dart';
import 'package:holkar_present/utils/Custom/HeightGap.dart';
import 'package:holkar_present/utils/Custom/ProfileImage.dart';
import 'package:holkar_present/utils/Custom/ProfileItemWidget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Image.asset(back_icon),
        ),
        title: Text('Name'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              edit_icon,
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            const ProfileImage(file: null, size: 200),
            const HeightGap(height: 30),
            ProfileItemWidget(left: 'Section :- ', right: 'M-13'),
            ProfileItemWidget(left: 'Semester :- ', right: '2nd'),
            ProfileItemWidget(left: 'Number :- ', right: '9098765432'),
            ProfileItemWidget(
                left: 'Email :- ', right: 'hemantsahu123@gmail.com'),
          ],
        ),
      ),
    );
  }
}
