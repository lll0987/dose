import 'package:flutter/material.dart';

import '../core/data/models/pill_model.dart';
import 'pill_image.dart';

class PillCard extends StatelessWidget {
  final PillModel pill;
  final Widget? trailing;
  final Function? onTap;

  const PillCard({super.key, required this.pill, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          onTap: () => onTap?.call(),
          title: Row(
            spacing: 6,
            children: [
              Container(
                width: 4,
                height: 12,
                decoration: BoxDecoration(
                  color: pill.getThemeColor(),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(pill.name, style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          subtitle: Text(pill.getQtyText()),
          leading: PillImage(imagePath: pill.imagePath),
          trailing: trailing,
        ),
      ),
    );
  }
}
