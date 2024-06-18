import 'package:flutter/cupertino.dart';

class WidthGap extends StatelessWidget {
  const WidthGap({super.key, required this.width});
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width,);
  }
}
