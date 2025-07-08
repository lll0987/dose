import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../models/pill_model.dart';
import '../models/plan_model.dart';
import '../models/quantity_model.dart';
import '../models/transaction_model.dart';
import '../providers/daily_provider.dart';
import '../providers/pill_provider.dart';
import '../providers/plan_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/transaction_provider.dart';
import '../service/loading_service.dart';
import '../widgets/pill_image.dart';

class DailyScreen extends StatefulWidget {
  const DailyScreen({super.key});

  @override
  State<DailyScreen> createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PillProvider>().loadPills();
    context.read<PlanProvider>().loadPlans();
    context.read<DailyProvider>().loadDailyTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer4<
          DailyProvider,
          PillProvider,
          PlanProvider,
          ThemeProvider
        >(
          builder: (
            context,
            dailyProvider,
            pillProvider,
            planProvider,
            themeProvider,
            child,
          ) {
            if (planProvider.allPlans.isEmpty) {
              return Center(
                child: Text(AppLocalizations.of(context)!.empty_todayPlanList),
              );
            }
            if (dailyProvider.dailyItems.isEmpty &&
                dailyProvider.missedItems.isEmpty) {
              return Center(
                child: Text(AppLocalizations.of(context)!.empty_todayPlan),
              );
            }

            final today = dailyProvider.today;
            final missday = dailyProvider.yesterday;
            final todayCount = dailyProvider.dailyItems.length;
            final missedCount = dailyProvider.missedItems.length;

            return Column(
              children: [
                // NEXT 首页增加日期等信息展示
                // Text(DateTime.now().toString().split(' ').first),
                if (missedCount > 0)
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            themeProvider.isDarkMode(context)
                                ? Theme.of(context).colorScheme.onSecondary
                                : Theme.of(context).colorScheme.secondaryFixed,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ExpansionTile(
                        shape: Border(),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.missedPlanTitle,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 0,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.error,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$missedCount',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onError,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        children: [
                          SizedBox(
                            height: min(missedCount.toDouble(), 2) * 75,
                            child: ListView.separated(
                              itemCount: missedCount,
                              itemBuilder: (content, index) {
                                final item = dailyProvider.missedItems[index];
                                final dailyPlans =
                                    dailyProvider.dailyItems
                                        .map((e) => e.plan)
                                        .toList();
                                final todayPlan = item.plan.equalsPlan(
                                  dailyPlans,
                                );
                                return _buildMissedItem(
                                  context: content,
                                  item: item,
                                  pill: pillProvider.pillMap[item.plan.pillId]!,
                                  todayPlan: todayPlan,
                                  todayDate: today,
                                  missedDate: missday,
                                );
                              },
                              separatorBuilder: (_, __) => const Divider(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: todayCount,
                    itemBuilder: (context, index) {
                      final item = dailyProvider.dailyItems[index];
                      final prev =
                          index > 0
                              ? dailyProvider.dailyItems[index - 1]
                              : null;
                      final startTime =
                          prev?.plan.startTime == item.plan.startTime
                              ? ''
                              : item.plan.startTime;
                      final missedPlans =
                          dailyProvider.missedItems.map((e) => e.plan).toList();
                      final missedPlan = item.plan.equalsPlan(missedPlans);
                      return _buildItem(
                        context: context,
                        startTime: startTime,
                        item: item,
                        pill: pillProvider.pillMap[item.plan.pillId]!,
                        missedPlan: missedPlan,
                        bottom: index == todayCount - 1 ? 16 : 0,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required String startTime,
    required PlanItem item,
    required PillModel pill,
    PlanModel? missedPlan,
    required double bottom,
  }) {
    final disabled = item.status != PlanStatus.missed;
    final isDone = item.status == PlanStatus.taken;
    final title =
        '${item.plan.quantity.displayText}${item.plan.quantity.unit}, ${pill.name}';
    final timeText = '${item.startTime} - ${item.endTime}';

    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8, bottom: bottom),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 40,
              child: Padding(
                padding: EdgeInsets.only(top: 22),
                child: Text(startTime),
              ),
            ),
            SizedBox(width: 4),
            SizedBox(
              width: 8,
              child: Column(
                spacing: 4,
                children: [
                  if (startTime.isNotEmpty)
                    Container(
                      width: 2,
                      height: 24,
                      decoration: BoxDecoration(
                        color:
                            Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                      ),
                    ),
                  if (startTime.isNotEmpty)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  Expanded(
                    child: Container(
                      width: 2,
                      height: 100,
                      decoration: BoxDecoration(
                        color:
                            Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Card(
                elevation: 0,
                margin: EdgeInsets.only(top: 16),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      if (disabled && isDone && item.plan.isExactTime)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Tooltip(
                              message: timeText,
                              child: Text(
                                timeText,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      Card(
                        elevation: 1,
                        child: ListTile(
                          title: Tooltip(
                            message: title,
                            child: Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          subtitle: Tooltip(
                            message: item.plan.name,
                            child: Text(
                              item.plan.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          leading: PillImage(pill: pill),
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed:
                                disabled
                                    ? null
                                    : () => _onSubmit(
                                      now: DateTime.now(),
                                      plan: item.plan,
                                    ),
                            child: Text(
                              isDone
                                  ? ''
                                  : disabled
                                  ? AppLocalizations.of(context)!.ignored
                                  : AppLocalizations.of(context)!.ignore,
                            ),
                          ),
                          FilledButton(
                            onPressed:
                                disabled
                                    ? null
                                    : () => _onPressed(item.plan, missedPlan),
                            child: Text(
                              isDone
                                  ? AppLocalizations.of(context)!.taken
                                  : AppLocalizations.of(context)!.take,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissedItem({
    required BuildContext context,
    required PlanItem item,
    required PillModel pill,
    PlanModel? todayPlan,
    required DateTime todayDate,
    required DateTime missedDate,
  }) {
    final title = [
      '${item.plan.quantity.displayText}${item.plan.quantity.unit}',
      pill.name,
    ].join(', ');
    final subTitle = [item.plan.startTime, item.plan.name].join(', ');

    return ListTile(
      title: Tooltip(
        message: title,
        child: Text(title, overflow: TextOverflow.ellipsis, maxLines: 1),
      ),
      subtitle: Tooltip(
        message: subTitle,
        child: Text(subTitle, overflow: TextOverflow.ellipsis, maxLines: 1),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () {
              _onSubmit(now: missedDate, plan: item.plan);
            },
            child: Text(AppLocalizations.of(context)!.ignore),
          ),
          ElevatedButton(
            onPressed: () {
              // 打开底部弹窗
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    padding: EdgeInsets.only(top: 16, bottom: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text(
                            AppLocalizations.of(context)!.takenYesterday,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            AppLocalizations.of(context)!.takenYesterdaySub,
                          ),
                          onTap: () async {
                            int? hour, minute;
                            if (item.plan.isExactTime) {
                              final result = await _showExactTimePicker();
                              if (result == null) {
                                Navigator.of(context).pop();
                                return;
                              }
                              (hour, minute) = result;
                            }
                            _onSubmit(
                              now: missedDate,
                              plan: item.plan,
                              quantities: [item.plan.quantity],
                              hour: hour,
                              minute: minute,
                            );
                            Navigator.of(context).pop();
                          },
                        ),
                        if (!item.plan.isExactTime)
                          ListTile(
                            title: Text(
                              AppLocalizations.of(context)!.takenToday,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              AppLocalizations.of(context)!.takenTodaySub,
                            ),
                            onTap: () async {
                              final quantities =
                                  todayPlan == null
                                      ? [item.plan.quantity]
                                      : [
                                        item.plan.quantity,
                                        todayPlan.quantity,
                                      ];
                              _onSubmit(
                                now: todayDate,
                                plan: item.plan,
                                quantities: quantities,
                              );
                              Navigator.of(context).pop();
                            },
                          ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Text(AppLocalizations.of(context)!.take),
          ),
        ],
      ),
    );
  }

  Future<(int, int)?> _showExactTimePicker() async {
    final now = DateTime.now();
    final newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (newTime != null) {
      return (newTime.hour, newTime.minute);
    }
    return null;
  }

  void _onPressed(PlanModel plan, PlanModel? missedPlan) async {
    int? hour, minute;
    List<QuantityModel> quantities = [plan.quantity];

    if (plan.isExactTime) {
      final result = await _showExactTimePicker();
      if (result == null) return;
      (hour, minute) = result;
    } else if (missedPlan != null) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(AppLocalizations.of(context)!.takeBothTitle),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(AppLocalizations.of(context)!.takeOnlyToday),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(AppLocalizations.of(context)!.takeBoth),
              ),
            ],
          );
        },
      );
      if (result!) {
        quantities.add(missedPlan.quantity);
      }
    }
    _onSubmit(
      now: DateTime.now(),
      plan: plan,
      quantities: quantities,
      hour: hour,
      minute: minute,
    );
  }

  void _onSubmit({
    required DateTime now,
    required PlanModel plan,
    List<QuantityModel>? quantities,
    int? hour,
    int? minute,
  }) async {
    loadingService.show();
    final time = plan.startTime.split(':');
    final startTime = DateTime(
      now.year,
      now.month,
      now.day,
      hour ?? int.parse(time[0]),
      minute ?? int.parse(time[1]),
    );
    // MEMO 药效时长不仅有小时单位时需要调整
    final endTime =
        hour == null || minute == null || plan.duration == null
            ? null
            : startTime.add(Duration(hours: plan.duration!));
    await context.read<TransactionProvider>().addTransaction(
      TransactionModel(
        planId: plan.id,
        revisionId: plan.revisionId,
        pillId: plan.pillId,
        quantities: quantities ?? [],
        startTime: startTime,
        endTime: endTime,
        isNegative: true,
      ),
    );
    loadingService.hide();
  }
}

PlanModel? getTodayPlan(List<PlanModel> todayPlans, PlanModel plan) {
  return todayPlans.firstWhereOrNull(
    (p) => p.pillId == plan.pillId && p.startTime == plan.startTime,
  );
}
