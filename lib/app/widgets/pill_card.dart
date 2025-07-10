import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../models/pill_model.dart';
import '../providers/pill_provider.dart';
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
      child: Consumer<PillProvider>(
        builder: (context, provider, c) {
          final count = provider.pillPlanCount[pill.id]!;
          final body = Row(
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
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.numbers,
                          size: 10,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        SizedBox(width: 2),
                        Text(pill.getQtyText(), style: TextStyle(fontSize: 14)),
                        if (count != -1)
                          Text(' / ', style: TextStyle(fontSize: 14)),
                        if (count > 0)
                          Text(
                            AppLocalizations.of(context)!.dosesLeft(count),
                            style: TextStyle(fontSize: 14),
                          ),
                        if (count == 0)
                          Text(
                            AppLocalizations.of(context)!.notEnoughSupply,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          );

          return Card(
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
                  if (child == null) body,
                  if (child != null)
                    Card(
                      elevation: 1,
                      child: Padding(padding: EdgeInsets.all(8), child: body),
                    ),
                  if (child != null) child!,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
