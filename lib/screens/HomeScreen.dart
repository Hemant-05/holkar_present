import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:holkar_present/screens/ProfileScreen.dart';
import 'package:holkar_present/utils/Coolers.dart';
import 'package:holkar_present/utils/Custom/ProfileImage.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? _selectedDay;
  TextStyle style([double size = 16]) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w600,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bg,
        toolbarHeight: 100,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  'Hemant sahu',
                  style: style(),
                ),
                Text(
                  'BCA(M-13)',
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
          children: [
            Calendar(),
          ],
        ),
      ),
    );
  }
  Widget Calendar()
  {
    return Container(
      child: TableCalendar(
        headerStyle: HeaderStyle(
           titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: style(30)
        ),
        daysOfWeekHeight: 40,
        daysOfWeekStyle: DaysOfWeekStyle(weekdayStyle: style(),weekendStyle: style()),
        firstDay: DateTime.utc(2000,1,1),
        lastDay: DateTime.utc(2040,12,31),
        focusedDay: DateTime.now(),

        calendarBuilders: CalendarBuilders(selectedBuilder: (context, day, focusedDay) {
          return Container(
            height: 45,
            width: 45,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
            child: Text('${day.day}',style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          );
        },),
        calendarStyle: CalendarStyle(
          defaultTextStyle: style(20),
          weekendTextStyle: style(20),
        ),
        selectedDayPredicate: (day){
          return isSameDay(_selectedDay,day);
        },
        onDaySelected: (selectedDay,focusedDay){
          setState(() {
            _selectedDay = selectedDay;
          });
        },
      ),
    );
  }
}
