import 'package:flutter/material.dart';

import '../models/pill_model.dart';
import 'pill_image.dart';

class PillCard extends StatelessWidget {
  final PillModel pill;
  final Widget? trailing;
  final Widget? child;
  final VoidCallback? onTap;
  final double? imgSize;

  const PillCard({
    super.key,
    required this.pill,
    this.trailing,
    this.child,
    this.onTap,
    this.imgSize,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap == null ? () {} : () => onTap!(),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            spacing: 8,
            children: [
              Row(
                spacing: 16,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  PillImage(pill: pill, size: imgSize ?? 48),
                  Expanded(
                    child: Text(
                      pill.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (child != trailing) trailing!,
                ],
              ),
              _buildSubRow(context, pill.getQtyText()),
              // _buildSubRow(context, '10次'),
              if (child != null) child!,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubRow(BuildContext context, String text) {
    return Row(
      spacing: 2,
      children: [
        Icon(
          Icons.numbers,
          size: 14,
          color: Theme.of(context).colorScheme.outline,
        ),
        Text(text, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}
