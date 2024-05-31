import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:holkar_present/FirebaseMeth/FirebaseAuthServices.dart';
import 'package:holkar_present/screens/LogInScreen.dart';
import 'package:holkar_present/utils/Constants.dart';
import 'package:holkar_present/utils/Custom/AuthElevetedButton.dart';
import 'package:holkar_present/utils/Custom/HeightGap.dart';
import 'package:holkar_present/utils/Custom/ProfileImage.dart';
import 'package:holkar_present/utils/Custom/ProfileItemWidget.dart';
import 'package:holkar_present/utils/models/StuedntModel.dart';
import 'package:holkar_present/utils/models/TeacherModel.dart';
import 'package:holkar_present/utils/models/UserModel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.model});

  final UserModel model;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel? model;
  bool isStudent = true;
  Student? student;
  Teacher? teacher;
  bool isYou = true;


  @override
  void initState() {
    super.initState();
    isStudent = widget.model.role == role[2];
    model = widget.model;
    if(_auth.currentUser!.uid == model!.uid){
      isYou = true;
    }else{
      isYou = false;
    }
    if (isStudent) {
      student = model!.object as Student;
    } else {
      teacher = model!.object as Teacher;
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuthServices services =
        FirebaseAuthServices(auth: FirebaseAuth.instance);
    String sec = '';
    String sem = '';
    String sub = '';
    if (!isStudent) {
      sem = getValue(teacher!.semesters);
      sec = getValue(teacher!.sections);
      sub = getValue(teacher!.subjects);
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset(back_icon),
        ),
        title: Text(
          widget.model.name,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          isYou? IconButton(
            onPressed: () {},
            icon: Image.asset(
              edit_icon,
            ),
          ) : Container() ,
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Hero(
                  tag: 'profile',
                  child: ProfileImage(
                    file: null,
                    size: 200,
                    fileUrl: widget.model.profile,
                  ),
                ),
                isStudent
                    ? Column(
                        children: [
                          const HeightGap(height: 30),
                          ProfileItemWidget(
                            left: 'Email :- ',
                            right: model!.email,
                          ),
                          ProfileItemWidget(
                            left: 'Name :- ',
                            right: model!.name,
                          ),
                          ProfileItemWidget(
                            left: 'Roll No. :- ',
                            right: student!.roll,
                          ),
                          ProfileItemWidget(
                            left: 'Subject :- ',
                            right: student!.subject,
                          ),
                          ProfileItemWidget(
                            left: 'Section :- ',
                            right: student!.section,
                          ),
                          ProfileItemWidget(
                            left: 'Semester :- ',
                            right: student!.semester,
                          ),
                          ProfileItemWidget(
                            left: 'Number :- ',
                            right: model!.number,
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          const HeightGap(height: 30),
                          ProfileItemWidget(
                            left: 'Email :- ',
                            right: model!.email,
                          ),
                          ProfileItemWidget(
                            left: 'Name :- ',
                            right: model!.name,
                          ),
                          ProfileItemWidget(
                            left: 'Sections :- ',
                            right: sec,
                          ),
                          ProfileItemWidget(
                            left: 'Semesters :- ',
                            right: sem,
                          ),
                          ProfileItemWidget(
                            left: 'Subjects :- ',
                            right: sub,
                          ),
                        ],
                      ),
              ],
            ),
            isYou? AuthElevatedButton(
              fun: () async {
                await services.logOut(context);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LogInScreen(),
                    ),
                    (route) => false);
              },
              loading: false,
              text: 'Log Out',
            ): Container(),
          ],
        ),
      ),
    );
  }
}
