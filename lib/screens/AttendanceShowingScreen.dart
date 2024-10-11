import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceShowingScreen extends StatefulWidget {
  const AttendanceShowingScreen({super.key, required this.attendance});

  final List attendance;

  @override
  State<AttendanceShowingScreen> createState() => _AttendanceState();
}

class _AttendanceState extends State<AttendanceShowingScreen> {
  List list = [];
  int ld = 30;
  int d = 0;
  double appBarHeight = 60;

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
        actions: [
          IconButton(onPressed: (){
            if(appBarHeight == 250){
              appBarHeight = 60;
            }else{
              appBarHeight = 250;
            }
          }, icon: Icon(Icons.arrow_drop_down_rounded)),
        ],
        toolbarHeight: appBarHeight,
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: SingleChildScrollView(
          child: Column(
            children: [
              /*AnimatedContainer(duration: Duration(seconds: 1)
              ,height: appBarHeight,color: Colors.grey,),*/
             /* GridView.builder(
                itemCount: ld,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5),
                itemBuilder: (context, index) {
                  d++;
                  Color color;
                  var date = 0;
                    try{
                       date = int.parse(DateFormat('d').format(list[index]['date'].toDate()));
                       print("Both date are d : $d || $date");
                       if(date == d){
                         color = list[index]['attendance'] == 'P'? Colors.green : Colors.red;
                       }else{
                         color = Colors.grey;
                       }
                    }catch(e){
                      print("This is an error $e");
                      color  = Colors.grey;
                    }
                  return DateContainer(color, '${1}');
                },
              ),*/
            ],
          ),
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
        d.toString(),
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
