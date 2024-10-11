import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:holkar_present/utils/Constants.dart';
import 'package:holkar_present/utils/Custom/ShowSnackBar.dart';
import 'package:holkar_present/utils/models/StuedntModel.dart';
import 'package:holkar_present/utils/models/TeacherModel.dart';
import 'package:holkar_present/utils/models/UserModel.dart';
import 'package:uuid/uuid.dart';

class FirebaseFireStoreServices {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirebaseFireStoreServices({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  Future<void> joinRoom(String roomId,String uid) async{
    try{
        _firestore.collection('attendance_room').doc(roomId).update({
          'students_uid': FieldValue.arrayUnion([uid])
        });
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> updateProfile()async{}

  Future<void> syncAttendance(List list,String roomId,String time) async {
    Map map = {
      'time' : time,
      'attendance' : list
    };
    _firestore.collection('attendance_room').doc(roomId).update({
      'attendance' : FieldValue.arrayUnion([map])
    });
  }

  Future<void> createAttendanceRoom(String title,BuildContext context) async{
    try{
      String uid = Uuid().v1();
      _firestore.collection('attendance_room').doc(uid).set({
        'attendance' : [],
        'uid' : uid,
        'title' : title,
        'students_uid' : [],
        'teacher_uid' : _auth.currentUser!.uid,
      });
      ShowSnackBar(context, '$title Attendance room created successfully......');
    }on FirebaseException catch(e){
      ShowSnackBar(context, e.toString());
    }
  }
  Future<UserModel?> getUserData(String uid) async {
    UserModel? model;
    try {
      var doc = await _firestore
          .collection('user')
          .doc(userDocId)
          .collection(role[2])
          .doc(uid)
          .get();
      if(doc.data() == null) {
        doc = await _firestore
            .collection('user')
            .doc(userDocId)
            .collection(role[1])
            .doc(uid)
            .get();
      }
      Map<String, dynamic>? data = doc.data();
      Teacher teacher;
      Student student;
      if (data != null) {
        bool isStudent = data['role'] == role[2]? true : false;
        if (!isStudent) {
          // Teacher

          teacher = Teacher(
            sections: data['sections']??[],
            semesters: data['semesters']??[],
            subjects: data['subjects']??[],
          );
          model = UserModel(
            object: teacher,
            name: data['name'],
            email: data['email'],
            number: data['number'],
            profile: data['profile'],
            role: data['role'],
            uid: data['uid'],
          );
        } else {
          student = Student(
            roll: data['roll'],
            subject: data['subject'],
            semester: data['semester'],
            section: data['section'],
            attendance: data['attendance'],
          );
          model = UserModel(
            object: student,
            name: data['name'],
            email: data['email'],
            number: data['number'],
            profile: data['profile'],
            role: data['role'],
            uid: data['uid'],
          );
        }
      }
    }on FirebaseAuthException catch(e){
      print('================= user not exists ======================');
      debugPrint(e.toString());
    }
    return model;
  }
}
