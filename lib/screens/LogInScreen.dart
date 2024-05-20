import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:holkar_present/screens/HomeScreen.dart';
import 'package:holkar_present/screens/sing_up/SingUpScreen.dart';
import 'package:holkar_present/utils/Custom/AuthElevetedButton.dart';
import 'package:holkar_present/utils/Custom/AuthTextButton.dart';
import 'package:holkar_present/utils/Custom/AuthTextField.dart';
import 'package:holkar_present/utils/Custom/HolkarLogoNameWidget.dart';
import 'package:holkar_present/utils/Custom/ShowSnackBar.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const HolkarLogoName(),
            const Text(
              'Log In',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              child: Column(
                children: [
                  AuthTextField(
                    controller: emailController,
                    hintText: 'Email',
                    inputType: TextInputType.emailAddress,
                    isObscure: false,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AuthTextField(
                    controller: passController,
                    hintText: 'Password',
                    inputType: TextInputType.multiline,
                    isObscure: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AuthTextButton(
                    text: 'Don\'t have an account?',
                    fun: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SingUpScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            AuthElevatedButton(
              text: 'Log In',
              fun: () {
                ShowSnackBar(context, "continue to logging in");
                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen(),),);
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
}
