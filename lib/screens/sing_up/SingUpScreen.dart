import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:holkar_present/FirebaseMeth/FirebaseStorageServices.dart';
import 'package:holkar_present/screens/LogInScreen.dart';
import 'package:holkar_present/screens/sing_up/StudentOtherDetailsScreen.dart';
import 'package:holkar_present/screens/sing_up/TeacherOtherDetailsScreen.dart';
import 'package:holkar_present/utils/Constants.dart';
import 'package:holkar_present/utils/Coolers.dart';
import 'package:holkar_present/utils/Custom/AuthElevetedButton.dart';
import 'package:holkar_present/utils/Custom/AuthTextButton.dart';
import 'package:holkar_present/utils/Custom/AuthTextField.dart';
import 'package:holkar_present/utils/Custom/HolkarLogoNameWidget.dart';
import 'package:holkar_present/utils/Custom/ProfileImage.dart';
import 'package:holkar_present/utils/Custom/ShowSnackBar.dart';
import 'package:image_picker/image_picker.dart';

class SingUpScreen extends StatefulWidget {
  const SingUpScreen({super.key});

  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  Uint8List? file;
  var _selectedRole = 'Select';
  bool loading = false;

  void onSelectImage() async {
    ImagePicker picker = ImagePicker();
    XFile? x = await picker.pickImage(source: ImageSource.gallery);
    if (x != null) {
      file = await x.readAsBytes();
      setState(() {});
    } else {
      ShowSnackBar(context, "No Image will selected !");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
            body: Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const HolkarLogoName(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          InkWell(
                            onTap: onSelectImage,
                            child: ProfileImage(
                              file: file,
                              size: 150,
                              fileUrl: '',
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          AuthTextField(
                            controller: emailController,
                            hintText: 'Email',
                            isObscure: false,
                            inputType: TextInputType.multiline,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AuthTextField(
                            controller: nameController,
                            hintText: 'Name',
                            isObscure: false,
                            inputType: TextInputType.multiline,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AuthTextField(
                            controller: contactController,
                            hintText: 'Contact',
                            isObscure: false,
                            inputType: TextInputType.multiline,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Chooser(context, getValue),
                          const SizedBox(
                            height: 10,
                          ),
                          AuthTextButton(
                            text: 'Already have an account?',
                            fun: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LogInScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AuthElevatedButton(
                    text: 'Next',
                    loading: loading,
                    fun: () async {
                      setState(() {
                        loading = true;
                      });
                      final fileUrl = await FirebaseStorageServices(
                              auth: FirebaseAuth.instance,
                              storage: FirebaseStorage.instance)
                          .uploadImage(file!);
                      Map<String, dynamic> userDetails = {
                        'name': nameController.text.trim(),
                        'email': emailController.text.trim(),
                        'number': contactController.text.trim(),
                        'profile': fileUrl,
                        'file' : file,
                      };
                      if (_selectedRole == 'Teacher') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeacherOtherDetailsScreen(
                              details: userDetails,
                            ),
                          ),
                        );
                      } else if (_selectedRole == 'Student') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentOtherDetailsScreen(
                              details: userDetails,
                            ),
                          ),
                        );
                      } else {
                        ShowSnackBar(
                            context, 'Please Select Role, than continue !');
                      }
                      setState(() {
                        loading = false;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
  }

  void getValue(String text) {
    _selectedRole = text;
  }

  Widget Chooser(BuildContext context, temp(String text)) {
    return Container(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Role',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: white,
            ),
            child: DropdownButton<String>(
              value: _selectedRole,
              onChanged: (value) {
                setState(() {
                  temp(value!);
                });
              },
              borderRadius: BorderRadius.circular(15),
              dropdownColor: white,
              underline: const SizedBox(),
              items: role.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              icon: const Icon(Icons.arrow_drop_down),
            ),
          ),
        ],
      ),
    );
  }
}
