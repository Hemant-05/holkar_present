import 'package:flutter/material.dart';

class ProfileItemWidget extends StatelessWidget {
  const ProfileItemWidget({super.key, required this.left, required this.right});
  final String left;
  final String right;

  TextStyle style([FontWeight weight = FontWeight.w600,double size = 16]){
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      child: Row(
        children: [
          Text(left,style: style(),),
          SizedBox(width: 5,),
          Text(right,style: style(),),
        ],
      ),
    );
  }
}
