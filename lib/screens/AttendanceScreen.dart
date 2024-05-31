import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key, required this.attendance});

  final List attendance;

  @override
  State<AttendanceScreen> createState() => _AttendanceState();
}

class _AttendanceState extends State<AttendanceScreen> {
  List list = [];
  int ld = 30;

  @override
  void initState() {
    super.initState();
    list = widget.attendance;
    lastDate();
  }

  void lastDate() {
    ld = int.parse(DateFormat('dd').format(
      DateTime(
        DateTime
            .now()
            .year,
        DateTime
            .now()
            .month + 1,
        0,
      ),
    ),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          DateFormat('MMMM yyyy').format(DateTime.now()),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: GridView.builder(
          itemCount: ld,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5),
          itemBuilder: (context, index) {
            Color color;
            if (index < list.length) {
              color = list[index] == 'P'
                  ? Colors.green
                  : list[index] == 'A'
                  ? Colors.red
                  : Colors.grey;
            } else {
              color = Colors.grey;
            }
            return DateContainer(color, '${index + 1}');
          },
        ),
      ),
    );
  }

  Widget DateContainer(Color color, String date) {
    return Container(
      height: 50,
      width: 50,
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.center,
      child: Text(
        date,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
