import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:holkar_present/FirebaseMeth/FirebaseFireStoreServices.dart';
import 'package:holkar_present/utils/Constants.dart';
import 'package:holkar_present/utils/Coolers.dart';
import 'package:holkar_present/utils/Custom/ShowSnackBar.dart';
import 'package:holkar_present/utils/Custom/StudentCard.dart';
import 'package:holkar_present/utils/models/StuedntModel.dart';
import 'package:holkar_present/utils/models/UserModel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;

class AttendanceTakingScreen extends StatefulWidget {
  const AttendanceTakingScreen({super.key, required this.map});

  final Map<String, dynamic> map;

  @override
  State<AttendanceTakingScreen> createState() => _AttendanceTakingScreenState();
}

class _AttendanceTakingScreenState extends State<AttendanceTakingScreen> {
  final CardSwiperController controller = CardSwiperController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List student_list = [];
  List attendance_list = [];
  bool loading = true;
  int mr = 1;

  void textFormat() async {
    try {
      final v = await getExternalStorageDirectory();
      final file = File('${v!.path}/${getFileName()}.txt');
      for (int i = 0; i < attendance_list.length; i++) {
        await file.writeAsString(
            '${attendance_list[i]['Roll']}' +
                " : " +
                '${attendance_list[i]['Attendance']}\n',
            mode: FileMode.append);
      }
      print(file.path);
    } catch (e) {
      print("Some problem occured when saving text file !! $e");
    }
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void pdfFormat() async {
    final pdf = pw.Document();

    int page = (attendance_list.length / 45).toInt() + 1;
    print("total no of pages is : $page");
    for (int i = 0; i < page; i++) {
      addPageToPdf(pdf, (i * 45));
    }

    try {
      final directory = await getExternalStorageDirectory();
      final file = File('${directory!.path}/${getFileName()}.pdf');
      await file.writeAsBytes(await pdf.save());
      print(
          'This is directory path ----------------- \n ${directory.path + "    ${getFileName()}"}');
    } catch (e) {
      print('this is error ------------------- \n $e');
    }
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void addPageToPdf(var pdf, int index) {
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              (index < 1)
                  ? pw.Text(getFileName(),
                      style: pw.TextStyle(
                          fontSize: 20, fontWeight: pw.FontWeight.bold))
                  : pw.SizedBox(height: 2),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Center(
                        child: pw.Text('R. No.',
                            style: pw.TextStyle(
                                fontSize: 20, fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Center(
                        child: pw.Text('Attendance',
                            style: pw.TextStyle(
                                fontSize: 20, fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  for (int i = index;
                      i < (index + 45) && i < (attendance_list.length);
                      i++)
                    pw.TableRow(children: [
                      pw.Center(
                        child: pw.Text(attendance_list[i]['Roll'].toString()),
                      ),
                      pw.Center(
                        child: pw.Text(
                            attendance_list[i]['Attendance'].toString()),
                      )
                    ]),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void excelFormat() {
    ShowSnackBar(
        context, 'This is format is currently not supported by the app !!');
  }

  void uploadAttendance() {
    String time = DateFormat('yyyy-MMM-dd HH:mm').format(DateTime.now());
    FirebaseFireStoreServices(auth: _auth, firestore: _firestore)
        .syncAttendance(attendance_list, widget.map['uid'], time);
  }

  String getFileName() {
    DateTime now = DateTime.now();
    String datetime = DateFormat('yyyy-MMM-dd HH:mm').format(now);
    return widget.map['title'] + ' [$datetime]';
  }

  void showDoneAttendanceDialogBox() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.done_outline_rounded,
          size: 40,
          color: Colors.green,
        ),
        title: Text(
          'Done...',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('In which formate you want attendance list ?'),
        actions: [
          ElevatedButton(onPressed: pdfFormat, child: Text('PDF')),
          ElevatedButton(onPressed: excelFormat, child: Text('EXCEL')),
          ElevatedButton(onPressed: textFormat, child: Text('TEXT')),
        ],
      ),
    );
  }

  Future<void> requestStoragePermission() async {
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
  void initState() {
    super.initState();
    loadStudentList();
  }

  void loadStudentList() async {
    var temp = widget.map['students_uid'];
    for (int i = 0; i < temp.length; i++) {
      UserModel? model =
          await FirebaseFireStoreServices(firestore: _firestore, auth: _auth)
              .getUserData(temp[i]);
      Map<String, dynamic> map = model!.toMap();
      student_list.add(map);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < student_list.length; i++) {
      Student student = student_list[i]['object'] as Student;
      int x = int.parse(student.roll);
      if (x > mr) {
        mr = x;
      }
    }
    attendance_list.clear();
    for (int i = 0; i < mr; i++) {
      attendance_list.add({
        'Roll': i + 1,
        'Attendance': 'A',
      });
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.map['title']),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
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
                student_list.length == 0
                    ? AlertDialog(
                        title: Text(
                          "Error !!",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        content: Text('No Student available in this room'),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Ok')),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'))
                        ],
                      )
                    : CardSwiper(
                        controller: controller,
                        cardsCount:
                            student_list.isEmpty ? 2 : student_list.length,
                        allowedSwipeDirection: const AllowedSwipeDirection.only(
                            up: true, down: true),
                        numberOfCardsDisplayed: 2,
                        isLoop: false,
                        onEnd: () async {
                          uploadAttendance();
                          requestStoragePermission();
                        },
                        onSwipe: (previousIndex, currentIndex, direction) {
                          int i = int.parse(
                              student_list[previousIndex]['object'].roll);
                          --i;
                          if (direction == CardSwiperDirection.top) {
                            attendance_list[i]['Attendance'] =
                                '${student_list[previousIndex]['name']}' +
                                    ' : P';
                            _firestore
                                .collection('user')
                                .doc(userDocId)
                                .collection('Student')
                                .doc(student_list[previousIndex]['uid'])
                                .update({
                              'attendance' : FieldValue.arrayUnion([{
                                'date' : DateTime.now(),
                                'attendance' : 'P' ,
                              }]),
                            });
                          } else {
                            _firestore
                                .collection('user')
                                .doc(userDocId)
                                .collection('Student')
                                .doc(student_list[previousIndex]['uid'])
                                .update({
                              'attendance' : FieldValue.arrayUnion([{
                                'date' : DateTime.now(),
                                'attendance' : 'A' ,
                              }]),
                            });
                          }
                          return true;
                        },
                        backCardOffset: const Offset(320, 0),
                        scale: 0.9,
                        cardBuilder: (context,
                            index,
                            horizontalOffsetPercentage,
                            verticalOffsetPercentage) {
                          Map<String, dynamic> map = {
                            'roll': student_list[index]['object'].roll,
                            'name': student_list[index]['name'],
                            'email': student_list[index]['email'],
                            'number': student_list[index]['number'],
                            'profile': student_list[index]['profile'],
                          };
                          return StudentCard(map: map);
                        },
                      ),
              ],
            ),
    );
  }
}
