import 'dart:io';

import 'package:flutter/material.dart';

class PillImage extends StatelessWidget {
  final String? imagePath;
  final double? width;

  const PillImage({super.key, this.imagePath, this.width = 48});

  @override
  Widget build(BuildContext context) {
    final icon = Center(
      child: Icon(
        Icons.medication_outlined,
        color: Theme.of(context).disabledColor,
        size: 24,
      ),
    );

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).hoverColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child:
          imagePath == null || imagePath!.isEmpty
              ? icon
              : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(imagePath!),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return icon;
                  },
                ),
              ),
    );
  }
}
