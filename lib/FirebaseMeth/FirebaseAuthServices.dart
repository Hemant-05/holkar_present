import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:holkar_present/FirebaseMeth/FirebaseFireStoreServices.dart';
import 'package:holkar_present/utils/Constants.dart';
import 'package:holkar_present/utils/Custom/ShowSnackBar.dart';
import 'package:holkar_present/utils/models/StuedntModel.dart';
import 'package:holkar_present/utils/models/TeacherModel.dart';
import 'package:holkar_present/utils/models/UserModel.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth;

  FirebaseAuthServices({required FirebaseAuth auth}) : _auth = auth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Login function
  Future<User?> logIn({
    required String email,
    required String pass,
    required BuildContext context,
  }) async {
    UserModel? model;
    User? user;
    try {
      user =
          (await _auth.signInWithEmailAndPassword(email: email, password: pass))
              .user;
      // model = await FirebaseFireStoreServices(firestore: _firestore, auth: _auth).getdata();
      // await setBoolValue(model!.role == role[2]? true : false );
    } on FirebaseAuthException catch (e) {
      ShowSnackBar(context, e.toString());
    }
    return user;
  }

  // Sign up function
  Future<User?> signUp({
    required String email,
    required String pass,
    required String name,
    required UserModel model,
    required BuildContext context,
  }) async {
    User? user;
    try {
      user = (await _auth.createUserWithEmailAndPassword(
              email: email, password: pass))
          .user;
      if (user != null) {
        user.updateDisplayName(name);
        if (model.role == role[1]) {
          // Teacher model
          var temp = model.object as Teacher;
          await _firestore
              .collection('user')
              .doc(userDocId)
              .collection(role[1])
              .doc(user.uid)
              .set({
            'uid': user.uid,
            'name': model.name,
            'email': model.email,
            'number': model.number,
            'profile': model.profile,
            'role': model.role,
            'sections': temp.sections,
            'subjects': temp.subjects,
            'semesters': temp.semesters,
          });
          await setBoolValue(false);
        } else {
          // Student model
          var temp = model.object as Student;
          await _firestore
              .collection('user')
              .doc(userDocId)
              .collection(role[2])
              .doc(user.uid)
              .set({
            'uid': user.uid,
            'name': model.name,
            'email': model.email,
            'number': model.number,
            'profile': model.profile,
            'role': model.role,
            'roll': temp.roll,
            'section': temp.section,
            'subject': temp.subject,
            'semester': temp.semester,
            'attendance': temp.attendance,
          });
          await setBoolValue(true);
        }
      }
    } on FirebaseAuthException catch (e) {
      ShowSnackBar(context, e.toString());
    }
    return user;
  }

  // log out fun
  Future<void> logOut(BuildContext context) async {
    try {
      await _auth.signOut();
      ShowSnackBar(context, 'Logged out Successfully....');
    } on FirebaseAuthException catch (e) {
      ShowSnackBar(context, e.toString());
    }
  }
}
