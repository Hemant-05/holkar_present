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
  bool loading = false;
  bool isAlreadyJoined = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List list = widget.map['students'];
    for (int i = 0; i < list.length; i++) {
      var temp = list[i] as Map;
      if (temp.containsValue(_auth.currentUser!.uid)) {
        setState(() {
          isAlreadyJoined = true;
        });
        break;
      }
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.map['title']),
      ),
      body: Padding(
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
                      fileUrl: widget.map['teacher_profile'] ?? '',
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.map['teacher_name'],
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
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  var item = list[index];
                  return ListTile(
                    leading: ProfileImage(
                        file: null, size: 50, fileUrl: item['profile']),
                    title: Text(
                      item['name'],
                    ),
                    trailing: Text(item['roll']),
                    onTap: () async {
                      UserModel? model = await FirebaseFireStoreServices(firestore: _firestore, auth: _auth).getUserData(item['uid']);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            model: model!
                          ),
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
                      Map<String, dynamic> map = {
                        'name': model.name,
                        'profile': model.profile,
                        'uid': _auth.currentUser!.uid,
                        'roll': student.roll,
                        'email' : model.email,
                        'number' : model.number,
                      };
                      setState(() {
                        list.add(map);
                      });
                      FirebaseFireStoreServices(
                              firestore: _firestore, auth: _auth)
                          .joinRoom(widget.map['uid'], map);
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
