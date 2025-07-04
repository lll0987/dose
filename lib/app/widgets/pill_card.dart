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
      onTap: onTap == null ? null : () => onTap!(),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        child: Padding(
          padding:
              child == null
                  ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                  : const EdgeInsets.all(8),
          child: Column(
            spacing: 4,
            children: [
              _buildCardChild(
                Row(
                  spacing: 16,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    PillImage(pill: pill, size: imgSize ?? 48),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                pill.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          _buildSubRow(context, pill.getQtyText()),
                          // _buildSubRow(context, '10次'),
                        ],
                      ),
                    ),
                    if (trailing != null) trailing!,
                  ],
                ),
              ),
              if (child != null) child!,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardChild(Widget body) {
    if (child == null) return body;
    return Card(
      elevation: 1,
      child: Padding(padding: EdgeInsets.all(8), child: body),
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
