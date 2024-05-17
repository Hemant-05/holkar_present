import 'package:flutter/cupertino.dart';

class HeightGap extends StatelessWidget {
  const HeightGap({super.key, required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height,);
  }
}
