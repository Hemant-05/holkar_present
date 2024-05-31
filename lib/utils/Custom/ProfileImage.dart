import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:holkar_present/utils/Coolers.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({
    super.key,
    required this.file,
    required this.size,
    required this.fileUrl,
  });

  final Uint8List? file;
  final String? fileUrl;
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
      child: widget.file == null && widget.fileUrl!.isEmpty
          ? Icon(
              Icons.person,
              size: widget.size - 30,
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: widget.fileUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: widget.fileUrl!,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.error_outline_rounded),
                      ),
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Image(
                      image: MemoryImage(widget.file!),
                    ),
            ),
    );
  }
}
