import 'package:flutter/material.dart';
import 'package:holkar_present/screens/HomeScreen.dart';
import 'package:holkar_present/utils/Constants.dart';
import 'package:holkar_present/utils/Coolers.dart';
import 'package:holkar_present/utils/Custom/AuthElevetedButton.dart';
import 'package:holkar_present/utils/Custom/AuthTextField.dart';
import 'package:holkar_present/utils/Custom/HeightGap.dart';
import 'package:holkar_present/utils/Custom/ProfileImage.dart';

class StudentOtherDetailsScreen extends StatefulWidget {
  const StudentOtherDetailsScreen({super.key, required this.details});

  final Map<String, dynamic> details;

  @override
  State<StudentOtherDetailsScreen> createState() =>
      _StudentOtherDetailsScreenState();
}

class _StudentOtherDetailsScreenState extends State<StudentOtherDetailsScreen> {
  TextEditingController passController = TextEditingController();
  TextEditingController conPassController = TextEditingController();
  TextEditingController rollNumController = TextEditingController();
  String selSemester = '';
  String selSubject = '';
  String selSection = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(16),
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
                      'Welcome \n${widget.details['name']}',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                ProfileImage(
                  file: widget.details['profile'],
                  size: 120,
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const HeightGap(height: 20),
                    Text(
                      '${widget.details['name'].split(' ').first} please enter the details',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const HeightGap(height: 20),
                    SizedBox(
                      height: 120,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              upArrow(const Icon(Icons.arrow_drop_up_rounded,),),
                              Container(
                                height: 50,
                                width: 50,
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
                              downArrow(const Icon(Icons.arrow_drop_down_rounded,),),
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                              upArrow(const Icon(Icons.arrow_drop_up_rounded,),),
                              Container(
                                height: 50,
                                width: 100,
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
                              downArrow(const Icon(Icons.arrow_drop_down_rounded,),),
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                              upArrow(const Icon(Icons.arrow_drop_up_rounded,),),
                              Container(
                                height: 50,
                                width: 80,
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
                              downArrow(const Icon(Icons.arrow_drop_down_rounded,),),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const HeightGap(height: 20),
                    AuthTextField(
                      controller: rollNumController,
                      hintText: 'Roll number',
                      isObscure: false,
                      inputType: const TextInputType.numberWithOptions(),
                    ),
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
                fun: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                }),
            const HeightGap(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget upArrow(Icon icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: 50,
      height: 20,
      child: icon,
    );
  }
  Widget downArrow(Icon icon) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: 50,
      height: 20,
      child: icon,
    );
  }
}
