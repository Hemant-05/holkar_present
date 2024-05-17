import 'package:flutter/material.dart';
import 'package:holkar_present/utils/Constants.dart';

class HolkarLogoName extends StatelessWidget {
  const HolkarLogoName({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: Row(
        children: [
          Image.asset(
            holkar_logo,
            height: 100,
            width: 100,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              height: 100,
              margin: const EdgeInsets.only(left: 20),
              alignment: Alignment.centerRight,
              child: const Text(
                'Govt. Holkar science college indore',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
                softWrap: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
