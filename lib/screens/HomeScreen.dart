import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:holkar_present/FirebaseMeth/FirebaseFireStoreServices.dart';
import 'package:holkar_present/screens/AttendanceShowingScreen.dart';
import 'package:holkar_present/screens/JoinRoomScreen.dart';
import 'package:holkar_present/screens/ProfileScreen.dart';
import 'package:holkar_present/screens/SelectOrCreateAttendanceRoomScreen.dart';
import 'package:holkar_present/utils/Constants.dart';
import 'package:holkar_present/utils/Coolers.dart';
import 'package:holkar_present/utils/Custom/AuthElevetedButton.dart';
import 'package:holkar_present/utils/Custom/ProfileImage.dart';
import 'package:holkar_present/utils/models/StuedntModel.dart';
import 'package:holkar_present/utils/models/TeacherModel.dart';
import 'package:holkar_present/utils/models/UserModel.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DateTime? _selectedDay;
  UserModel? model;
  Teacher? teacher;
  Student? student;
  bool isStudent = true;
  bool loading = false;
  int count = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextStyle style([double size = 16]) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w600,
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    user();
  }

  void user() async {
    model = await FirebaseFireStoreServices(
            auth: _auth, firestore: _firestore)
        .getUserData(_auth.currentUser!.uid);
    isStudent = model!.role == role[2];
    if (isStudent) {
      student = model!.object as Student;
      List list = student!.attendance;
      for (int i = 0; i < list.length; i++) {
        if (list[i] == 'P') {
          count++;
        }
      }
    } else {
      teacher = model!.object as Teacher;
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String sections = '';
    if (!isStudent) {
      sections = getValue(teacher!.sections);
    }
    return loading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: bg,
              toolbarHeight: 120,
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          model!.name,
                          style: style(20),
                        ),
                        Text(
                          isStudent ? student!.section : sections,
                          style: style(),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              model: model!,
                            ),
                          ),
                        );
                      },
                      child: Hero(
                        tag: 'profile',
                        child: ProfileImage(
                          file: null,
                          fileUrl: model!.profile,
                          size: 100,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Calendar(),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: isStudent
                        ? Text(
                            'Total Present :- $count',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,),
                          )
                        : const Text(
                            'No new Update !',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,),
                          ),
                  ),
                  isStudent?
                  Expanded(
                    child: StreamBuilder(
                      stream: _firestore
                          .collection('attendance_room')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          var temp = snapshot.data!.docs;
                          return ListView.builder(
                            itemCount: temp.length,
                            itemBuilder: (context, index) {
                              var item = temp[index].data();
                              return ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: Text(
                                    '${item['title'].toString().split(' ')[0]}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                                title: Text(
                                  item['title'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          JoinRoomScreen(
                                        map: item,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        }
                        return const Center(
                          child: Icon(Icons.error_outline_rounded),
                        );
                      },
                    ),
                  ) : Container(),
                  isStudent
                      ? AuthElevatedButton(
                          text: 'Check Attendance',
                          loading: false,
                          fun: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AttendanceShowingScreen( ///////////////////////////////////////////////
                                  attendance: student!.attendance,
                                ),
                              ),
                            );
                          },
                        )
                      : AuthElevatedButton(
                          fun: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SelectOrCreateAttendanceRoomScreen(),
                              ),
                            );
                          },
                          loading: false,
                          text: 'Take Attendance')
                ],
              ),
            ),
          );
  }

  Widget Calendar() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration:
          BoxDecoration(color: white, borderRadius: BorderRadius.circular(15)),
      child: TableCalendar(
        rowHeight: 40,
        headerStyle: HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
            titleTextStyle: style(25)),
        daysOfWeekHeight: 40,
        daysOfWeekStyle:
            DaysOfWeekStyle(weekdayStyle: style(), weekendStyle: style()),
        firstDay: DateTime.utc(2000, 1, 1),
        lastDay: DateTime.utc(2026, 12, 31),
        focusedDay: DateTime.now(),
        calendarStyle: CalendarStyle(
          defaultTextStyle: style(20),
          weekendTextStyle: style(20),
        ),
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
          });
        },
      ),
    );
  }
}
