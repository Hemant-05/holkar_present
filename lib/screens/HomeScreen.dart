import 'package:flutter/material.dart';
import 'package:holkar_present/screens/ProfileScreen.dart';
import 'package:holkar_present/utils/Constants.dart';
import 'package:holkar_present/utils/Coolers.dart';
import 'package:holkar_present/utils/Custom/AuthElevetedButton.dart';
import 'package:holkar_present/utils/Custom/AuthTextButton.dart';
import 'package:holkar_present/utils/Custom/ProfileImage.dart';
import 'package:holkar_present/utils/models/StuedntModel.dart';
import 'package:holkar_present/utils/models/TeacherModel.dart';
import 'package:holkar_present/utils/models/UserModel.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.model});

  final UserModel model;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? _selectedDay;
  var model;
  bool isStudent = true;

  TextStyle style([double size = 16]) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w600,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isStudent = widget.model.role == role[2];
    if (isStudent) {
      model = widget.model.object as Student;
    } else {
      model = widget.model.object as Teacher;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: bg,
        toolbarHeight: 100,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  widget.model.name,
                  style: style(20),
                ),
                Text(
                  model.section,
                  style: style(),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
              child: const ProfileImage(
                file: null,
                size: 100,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Calendar(),
            Container(
              child: Text('Total Presented day\'s in this month :- 15',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
            ),
            isStudent
                ? AuthElevatedButton(text: 'Check Attendance', fun: () {})
                : AuthElevatedButton(fun: () {}, text: 'Take Attendance')
          ],
        ),
      ),
    );
  }

  Widget Calendar() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(15)
      ),
      child: TableCalendar(
        rowHeight: 40,
        headerStyle: HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
            titleTextStyle: style(30)),
        daysOfWeekHeight: 40,
        daysOfWeekStyle:
            DaysOfWeekStyle(weekdayStyle: style(), weekendStyle: style()),
        firstDay: DateTime.utc(2000, 1, 1),
        lastDay: DateTime.utc(2040, 12, 31),
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
