import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/plan_model.dart';
import '../providers/plan_provider.dart';

class PlanCard extends StatelessWidget {
  final PlanModel plan;
  final VoidCallback onTap;

  const PlanCard({super.key, required this.plan, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final repeatText = plan.getRepeatText(context);
    return InkWell(
      onTap: () => onTap(),
      child: Card(
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Row(
                  spacing: 4,
                  children: [
                    Text(
                      plan.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (!plan.isEnabled)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.disabled,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                  ],
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
                  Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: _buildChip(
                      plan.getRepeatStartText(context),
                      context,
                    ),
                  ),
                  if (plan.endDate.isNotEmpty)
                    Flexible(
                      flex: 1,
                      fit: FlexFit.loose,
                      child: _buildChip(
                        plan.getRepeatEndText(context),
                        context,
                      ),
                    ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${plan.quantity.displayText}${plan.quantity.unit}',
                    style: TextStyle(fontSize: 16),
                  ),
                  PopupMenuButton(
                    onSelected: (value) {
                      if (value == "start") {
                        _onStart(context, plan.id!);
                      }
                      if (value == "stop") {
                        _onStop(context, plan.id!);
                      }
                      if (value == "delete") {
                        _onDelete(context, plan.id!);
                      }
                    },
                    itemBuilder:
                        (context) => [
                          plan.isEnabled
                              ? PopupMenuItem(
                                value: "stop",
                                child: Text(
                                  AppLocalizations.of(context)!.disable,
                                ),
                              )
                              : PopupMenuItem(
                                value: "start",
                                child: Text(
                                  AppLocalizations.of(context)!.enable,
                                ),
                              ),
                          PopupMenuItem(
                            value: "delete",
                            child: Text(AppLocalizations.of(context)!.delete),
                          ),
                        ],
                  ),
                ],
              ),
            ),
            if (plan.reminderValue != null || plan.cycles.isNotEmpty) ...[
              // 提醒设置
              _buildRow(
                icon: Icons.notifications_none,
                text: plan.getReminderAllText(context),
                context: context,
              ),
              SizedBox(height: 4),
              // 停药条件
              _buildRow(
                icon: Icons.info_outline,
                text: plan.getCycleText(context),
                context: context,
              ),
              SizedBox(height: 8),
            ],
            if (plan.reminderValue == null && plan.cycles.isEmpty)
              SizedBox(height: 4),
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
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.outline),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  _onDelete(BuildContext context, int id) async {
    final result = await context.read<PlanProvider>().deletePlan(id);
    final message =
        result.isSuccess
            ? AppLocalizations.of(context)!.success_delete
            : result.error!;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  _onStop(BuildContext context, int id) async {
    await context.read<PlanProvider>().disablePlan(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.success_disable)),
    );
  }

  _onStart(BuildContext context, int id) async {
    await context.read<PlanProvider>().enablePlan(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.success_enable)),
    );
  }
}
