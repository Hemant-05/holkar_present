import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:holkar_present/utils/Coolers.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({super.key, required this.file, required this.size});
  final Uint8List? file;
  final double size;
  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size,
      width: widget.size,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: widget.file == null
          ? Icon(
              Icons.person,
              size: widget.size - 30,
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image(
                image: MemoryImage(
                  widget.file!,
                ),
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}
