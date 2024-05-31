import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:holkar_present/FirebaseMeth/FirebaseFireStoreServices.dart';
import 'package:holkar_present/screens/AttendanceTakingScreen.dart';
import 'package:holkar_present/utils/Constants.dart';
import 'package:holkar_present/utils/Coolers.dart';
import 'package:holkar_present/utils/Custom/AuthTextButton.dart';

class SelectOrCreateAttendanceRoomScreen extends StatefulWidget {
  const SelectOrCreateAttendanceRoomScreen({super.key});

  @override
  State<SelectOrCreateAttendanceRoomScreen> createState() =>
      _SelectOrCreateAttendanceRoomScreenState();
}

class _SelectOrCreateAttendanceRoomScreenState
    extends State<SelectOrCreateAttendanceRoomScreen> {
  String selSemester = semester[0];
  String selSubject = subject[0];
  String selSection = section[0];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void showDialogBox() async {
    bool isLoading = false;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Creating Attendance room'),
        content: Container(
          height: 150,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [Subject(), Semester(), Section()],
          ),
        ),
        actions: [
          AuthTextButton(
              fun: () {
                Navigator.pop(context);
              },
              text: 'Cancel'),
          isLoading? const Center(child : CircularProgressIndicator(),):AuthTextButton(
              fun: () {
                setState(() {
                  isLoading = true;
                });
                FirebaseFireStoreServices(
                        firestore: FirebaseFirestore.instance,
                        auth: FirebaseAuth.instance)
                    .createAttendanceRoom(
                        '$selSubject $selSection $selSemester Sem', context);
                setState(() {
                  isLoading = false;
                });
                Navigator.pop(context);
              },
              text: 'Create'),
        ],
        alignment: Alignment.center,
        contentPadding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showDialogBox();
            },
            icon: const Icon(
              Icons.add_rounded,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _firestore.collection('attendance_room').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.active) {
            var temp = snapshot.data!.docs;
            return ListView.builder(
              itemCount: temp.length,
              itemBuilder: (context, index) {
                var item = temp[index].data();
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${item['title'].toString().split(' ')[0]}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  title: Text(
                    item['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AttendanceTakingScreen(map: item),
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
    );
  }

  Widget Semester() {
    return Column(
      children: [
        arrow(
          const Icon(
            Icons.arrow_drop_up_rounded,
          ),
          true,
        ),
        Container(
          height: 50,
          width: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: white,
          ),
          child: ListWheelScrollView(
            onSelectedItemChanged: (value) {
              setState(() {
                selSemester = semester[value];
              });
            },
            itemExtent: 50,
            diameterRatio: 3,
            physics: const FixedExtentScrollPhysics(),
            children: semester
                .map(
                  (text) => Container(
                    alignment: Alignment.center,
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        arrow(
            const Icon(
              Icons.arrow_drop_down_rounded,
            ),
            false),
      ],
    );
  }

  Widget Subject() {
    return Column(
      children: [
        arrow(
          const Icon(
            Icons.arrow_drop_up_rounded,
          ),
          true,
        ),
        Container(
          height: 50,
          width: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: white,
          ),
          child: ListWheelScrollView(
            onSelectedItemChanged: (value) {
              setState(() {
                selSubject = subject[value];
              });
            },
            itemExtent: 50,
            diameterRatio: 3,
            physics: const FixedExtentScrollPhysics(),
            children: subject
                .map(
                  (text) => Container(
                    alignment: Alignment.center,
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        arrow(
            const Icon(
              Icons.arrow_drop_down_rounded,
            ),
            false),
      ],
    );
  }

  Widget Section() {
    return Column(
      children: [
        arrow(
          const Icon(
            Icons.arrow_drop_up_rounded,
          ),
          true,
        ),
        Container(
          height: 50,
          width: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: white,
          ),
          child: ListWheelScrollView(
            onSelectedItemChanged: (value) {
              setState(() {
                selSection = section[value];
              });
            },
            itemExtent: 50,
            diameterRatio: 3,
            physics: const FixedExtentScrollPhysics(),
            children: section
                .map(
                  (text) => Container(
                    alignment: Alignment.center,
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        arrow(
            const Icon(
              Icons.arrow_drop_down_rounded,
            ),
            false),
      ],
    );
  }

  Widget arrow(Icon icon, bool up) {
    return Container(
      margin: up
          ? const EdgeInsets.only(top: 10)
          : const EdgeInsets.only(bottom: 10),
      width: 50,
      height: 20,
      child: icon,
    );
  }
}
