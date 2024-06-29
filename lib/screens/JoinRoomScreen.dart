import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:holkar_present/FirebaseMeth/FirebaseFireStoreServices.dart';
import 'package:holkar_present/screens/ProfileScreen.dart';
import 'package:holkar_present/utils/Coolers.dart';
import 'package:holkar_present/utils/Custom/AuthElevetedButton.dart';
import 'package:holkar_present/utils/Custom/ProfileImage.dart';
import 'package:holkar_present/utils/Custom/ShowSnackBar.dart';
import 'package:holkar_present/utils/models/StuedntModel.dart';
import 'package:holkar_present/utils/models/UserModel.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key, required this.map});

  final Map<String, dynamic> map;

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = true;
  bool isAlreadyJoined = false;
  List list = [];
  bool student_list_loading = true;
  UserModel? teacher;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    teacher =
        await FirebaseFireStoreServices(firestore: _firestore, auth: _auth)
            .getUserData(widget.map['teacher_uid']);
    setState(() {
      loading = false;
    });
    var temp = widget.map['students_uid'];
    for (int i = 0; i < temp.length; i++) {
      UserModel? model =
          await FirebaseFireStoreServices(firestore: _firestore, auth: _auth)
              .getUserData(temp[i]);
      Map<String, dynamic> map = model!.toMap();
      list.add(map);
      if (map.containsValue(_auth.currentUser!.uid)) {
        isAlreadyJoined = true;
      }
    }
    setState(() {
      student_list_loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.map['title']),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      height: 100,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                      ),
                      child: Row(
                        children: [
                          ProfileImage(
                            file: null,
                            size: 100,
                            fileUrl: teacher!.profile ?? '',
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                teacher!.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text('Total Student : ${list.length}'),
                            ],
                          )
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  student_list_loading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              var item = list[index];
                              return ListTile(
                                leading: ProfileImage(
                                    file: null,
                                    size: 50,
                                    fileUrl: item['profile']),
                                title: Text(
                                  item['name'],
                                ),
                                trailing: Text(item['object'].roll),
                                onTap: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                          model:
                                              UserModel.fromMap(list[index])),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                  AuthElevatedButton(
                      fun: () async {
                        try {
                          setState(() {
                            loading = true;
                          });
                          if (!isAlreadyJoined) {
                            UserModel? model = await FirebaseFireStoreServices(
                                    firestore: _firestore, auth: _auth)
                                .getUserData(_auth.currentUser!.uid);
                            Student student = model!.object as Student;
                            String std_class =
                                '${student.subject} ${student.section} ${student.semester} Sem';
                            if (widget.map['title'] == std_class) {
                              list.add(_auth.currentUser!.uid);
                              FirebaseFireStoreServices(
                                      firestore: _firestore, auth: _auth)
                                  .joinRoom(widget.map['uid'],
                                      _auth.currentUser!.uid);
                            } else {
                              ShowSnackBar(context,
                                  'You can\'t join this room ! \n because are not in this standard !');
                            }
                          } else {
                            ShowSnackBar(context, 'You are Already joined ...');
                          }
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                        setState(() {
                          loading = false;
                        });
                      },
                      loading: loading,
                      text: isAlreadyJoined ? 'Joined' : 'Join Room')
                ],
              ),
            ),
    );
  }
}
