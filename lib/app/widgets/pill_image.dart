import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pill_model.dart';
import '../providers/theme_provider.dart';

class PillImage extends StatelessWidget {
  final PillModel pill;
  final double? size;

  const PillImage({super.key, required this.pill, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final theme = ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: themeProvider.getColor(pill.themeValue),
          ),
        );

        final icon = Center(
          child: Text(
            pill.name.isEmpty ? 'P' : pill.name[0],
            style: TextStyle(
              color: theme.colorScheme.onSecondaryFixed,
              fontSize: size! * 0.375,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryFixed,
            borderRadius: BorderRadius.circular(8),
          ),
          child:
              pill.imagePath == null || pill.imagePath!.isEmpty
                  ? icon
                  : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(pill.imagePath!),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return icon;
                      },
                    ),
                  ),
        );
      },
    );
  }
}
