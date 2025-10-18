import 'dart:io';

import 'package:flutter/material.dart';

class PhotoDetailScreen extends StatelessWidget {
  final String imagePath;
  final String tag;

  const PhotoDetailScreen({super.key, required this.imagePath, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Hero(
          tag: tag,
          child: Image.file(File(imagePath)),
        ),
      ),
    );
  }
}