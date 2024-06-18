import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:holkar_present/utils/Coolers.dart';
import 'package:holkar_present/utils/Custom/StudentCard.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AttendanceTakingScreen extends StatefulWidget {
  const AttendanceTakingScreen({super.key, required this.map});

  final Map<String, dynamic> map;

  @override
  State<AttendanceTakingScreen> createState() => _AttendanceTakingScreenState();
}

class _AttendanceTakingScreenState extends State<AttendanceTakingScreen> {
  final CardSwiperController controller = CardSwiperController();
  List student_list = [];
  List attendance_list = [];
  int mr = 1;
  void textFormat() async {
    DateTime now = DateTime.now();
    String datetime = DateFormat('yyyy-MM-dd').format(now);
    String fName = widget.map['title'] + ' [$datetime]';
    try{
      final v = await getExternalStorageDirectory();
      print('This is downloads directory path : $v');
      final file = File('${v!.path}/$fName.txt');
      await file.writeAsString(attendance_list.join('\n'));
      print(file.path);
    }catch(e){
      print("Some problem occured when saving text file !! $e");
    }
    Navigator.pop(context);
    Navigator.pop(context);
  }
  void pdfFormat(){}
  void excelFormat(){}
  void showDoneAttendanceDialogBox() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.done_outline_rounded,size: 40,color: Colors.green,),
        title: Text('Done...',style: TextStyle(fontWeight: FontWeight.bold),),
        content: Text('In which formate you want attendance list ?'),
        actions: [
          ElevatedButton(onPressed: pdfFormat, child: Text('PDF')),
          ElevatedButton(onPressed: excelFormat, child: Text('EXCEL')),
          ElevatedButton(onPressed: textFormat, child: Text('TEXT')),
        ],
      ),
    );
  }

  Future<void> requestStoragePermission() async{
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      print('Storage permission granted');
      showDoneAttendanceDialogBox();
    } else if (status.isDenied) {
      print('Storage permission denied');
      Navigator.pop(context);
    } else if (status.isPermanentlyDenied) {
      print('Storage permission permanently denied');
      Navigator.pop(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    student_list = widget.map['students'];
    for (int i = 0; i < student_list.length; i++) {
      var temp = student_list[i];
      int x = int.parse(temp['roll']);
      if (x > mr) {
        mr = x;
      }
    }
    attendance_list.clear();
    for (int i = 0; i <= mr; i++) {
      attendance_list.add(0);
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.map['title']),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.green, Colors.green, white],
                    ),
                  ),
                  alignment: Alignment.topCenter,
                  child: const Text('Present'),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.red, Colors.red, white],
                    ),
                  ),
                  alignment: Alignment.bottomCenter,
                  child: const Text('Absent'),
                ),
              ),
            ],
          ),
          CardSwiper(
            controller: controller,
            cardsCount: student_list.isEmpty ? 2 : student_list.length,
            allowedSwipeDirection:
                const AllowedSwipeDirection.only(up: true, down: true),
            numberOfCardsDisplayed: 2,
            isLoop: false,
            onEnd: () async {
              requestStoragePermission();
            },
            onSwipe: (previousIndex, currentIndex, direction) {
              int i = int.parse(student_list[previousIndex]['roll']);
              --i;
              if (direction == CardSwiperDirection.top) {
                attendance_list[i] = 'P';
              } else if (direction == CardSwiperDirection.bottom) {
                attendance_list[i] = 'A';
              }
              return true;
            },
            backCardOffset: const Offset(320, 0),
            scale: 0.9,
            cardBuilder: (context, index, horizontalOffsetPercentage,
                verticalOffsetPercentage) {
              Map<String, dynamic> map = student_list[index];
              return StudentCard(map: map);
            },
          ),
        ],
      ),
    );
  }
}
