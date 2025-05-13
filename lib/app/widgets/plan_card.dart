import 'package:flutter/material.dart';

import '../models/plan_model.dart';

class PlanCard extends StatelessWidget {
  final PlanModel plan;
  final VoidCallback onTap;

  const PlanCard({super.key, required this.plan, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final repeatText = plan.getRepeatText();
    return InkWell(
      onTap: () => onTap(),
      child: Card(
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Padding(
                padding: EdgeInsets.only(bottom: 2),
                child: Text(
                  plan.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              subtitle: Row(
                spacing: 8,
                children: [
                  Flexible(
                    flex: repeatText.length > 5 ? 2 : 1,
                    fit: FlexFit.loose,
                    child: _buildChip(repeatText, context),
                  ),
                  if (plan.startTime.isNotEmpty)
                    _buildChip(plan.startTime, context),
                  if (plan.endDate.isNotEmpty)
                    Flexible(
                      flex: 1,
                      fit: FlexFit.loose,
                      child: _buildChip(plan.getRepeatEndText(), context),
                    ),
                ],
              ),
              trailing: Text(
                '${plan.qty}${plan.unit}',
                style: TextStyle(fontSize: 16),
              ),
            ),
            if (plan.reminderValue != null || plan.cycles.isNotEmpty) ...[
              // 提醒设置
              _buildRow(
                icon: Icons.notifications_none,
                text: plan.getReminderAllText(),
                context: context,
              ),
              // 停药条件
              _buildRow(
                icon: Icons.info_outline,
                text: plan.getCycleText(),
                context: context,
              ),
              SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, BuildContext context) {
    return Tooltip(
      message: label,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 1),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(label, overflow: TextOverflow.ellipsis, maxLines: 1),
      ),
    );
  }

  // 辅助方法：生成带图标的行
  Widget _buildRow({
    required IconData icon,
    required String text,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.outline),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
