import 'package:shared_preferences/shared_preferences.dart';

const holkar_logo = 'assets/images/holkar_logo.png';
const edit_icon = 'assets/images/edit_icon.png';
const back_icon = 'assets/images/back.png';

const role = <String>['Select','Teacher', 'Student'];
const subject = <String>['BCA', 'BSC','MSC','MCA'];
const semester = <String>['1nd', '2nd','3rd','4th','5th','6th'];
const section = <String>['M-10','M-11','M-12','M-13', 'M-14','M-15'];

const String userDocId = 'BTw80dbqb2pf093sdfgs3UG';

const String attendanceDocId = "db32ac40-b11b-1ff2-95d3-a309b7108386";

Future<void> setBoolValue(bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('isStudent',value);
}

Future<bool> getBoolValue() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isStudent')?? true;
}

String getValue(List temp)
{
  String str = '';
  for (int i = 0; i < temp.length; i++) {
    var element = temp[i];
    String coma = (temp.length - 1 == i)? '' : ', ';
    str = str + element + coma;
  }
  return str;
}