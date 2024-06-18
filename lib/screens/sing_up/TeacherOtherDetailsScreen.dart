import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:holkar_present/FirebaseMeth/FirebaseAuthServices.dart';
import 'package:holkar_present/screens/HomeScreen.dart';
import 'package:holkar_present/utils/Constants.dart';
import 'package:holkar_present/utils/Custom/AuthElevetedButton.dart';
import 'package:holkar_present/utils/Custom/AuthTextField.dart';
import 'package:holkar_present/utils/Custom/HeightGap.dart';
import 'package:holkar_present/utils/Custom/ProfileImage.dart';
import 'package:holkar_present/utils/Custom/ShowSnackBar.dart';
import 'package:holkar_present/utils/models/TeacherModel.dart';
import 'package:holkar_present/utils/models/UserModel.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class TeacherOtherDetailsScreen extends StatefulWidget {
  const TeacherOtherDetailsScreen({super.key, required this.details});

  final Map<String, dynamic> details;

  @override
  State<TeacherOtherDetailsScreen> createState() =>
      _TeacherOtherDetailsScreenState();
}

class _TeacherOtherDetailsScreenState extends State<TeacherOtherDetailsScreen> {
  TextEditingController passController = TextEditingController();
  TextEditingController conPassController = TextEditingController();
  List selectedSemester = [];
  List selectedSubject = [];
  List selectedSection = [];
  bool loading = false;

  @override
  void dispose() {
    super.dispose();
    passController.dispose();
    conPassController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(),
            body: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            'Welcome \n${widget.details['name'].split(' ').first} Sir',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      ProfileImage(
                        file: widget.details['file'],
                        size: 120,
                        fileUrl: '',
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const HeightGap(height: 20),
                          Text(
                            '${widget.details['name'].split(' ').first} sir please set profile password',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const HeightGap(height: 20),
                          MultiSelect(
                              'Select semesters ', semester, selectedSemester),
                          const HeightGap(height: 10),
                          MultiSelect(
                              'Select sections ', section, selectedSection),
                          const HeightGap(height: 10),
                          MultiSelect(
                              'Select subjects ', subject, selectedSubject),
                          const HeightGap(height: 10),
                          AuthTextField(
                            controller: passController,
                            hintText: 'password',
                            isObscure: true,
                            inputType: TextInputType.visiblePassword,
                          ),
                          const HeightGap(height: 10),
                          AuthTextField(
                            controller: conPassController,
                            hintText: 'confirm password',
                            isObscure: true,
                            inputType: TextInputType.visiblePassword,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const HeightGap(height: 10),
                  AuthElevatedButton(
                      text: 'Create an Account',
                      loading: loading,
                      fun: () async {
                        var map = widget.details;
                        Teacher teacher = Teacher(
                          sections: selectedSection,
                          semesters: selectedSemester,
                          subjects: selectedSubject,
                        );
                        UserModel model = UserModel(
                          object: teacher,
                          name: map['name'],
                          email: map['email'],
                          number: map['number'],
                          profile: map['profile'],
                          role: role[1],
                          uid: '',
                        );
                        String pass = passController.text.trim();
                        String conPass = conPassController.text.trim();
                        User? user;
                        if (pass == conPass) {
                          setState(() {
                            loading = true;
                          });
                          user = await FirebaseAuthServices(
                                  auth: FirebaseAuth.instance)
                              .signUp(
                            email: model.email,
                            pass: pass,
                            name: model.name,
                            model: model,
                            context: context,
                          );
                        } else {
                          ShowSnackBar(context, 'Password did\'nt Match !');
                        }
                        if (user != null) {
                          setState(() {
                            loading = false;
                          });
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                            (route) => false,
                          );
                        } else {
                          ShowSnackBar(context, 'Some Problem is occured !');
                        }
                      }),
                  const HeightGap(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
  }

  Widget MultiSelect(String hint, var list, List selectedItem) {
    return MultiSelectDropDown(
      clearIcon: const Icon(
        Icons.cancel_outlined,
        color: Colors.deepPurple,
      ),
      onOptionSelected: (options) {
        selectedItem.clear();
        for (int i = 0; i < options.length; i++) {
          selectedItem.add(options[i].label);
        }
      },
      hint: hint,
      onOptionRemoved: (index, option) {
        selectedItem.remove(option);
      },
      options:
          list.map<ValueItem>((e) => ValueItem(label: e, value: e)).toList(),
      selectionType: SelectionType.multi,
      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
      optionTextStyle:
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      selectedOptionIcon: const Icon(Icons.check_circle),
    );
  }
}
