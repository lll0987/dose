import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../models/pill_model.dart';
import '../models/plan_model.dart';
import '../models/quantity_model.dart';
import '../models/transaction_model.dart';
import '../providers/datetime_provider.dart';
import '../providers/pill_provider.dart';
import '../providers/plan_provider.dart';
import '../providers/transaction_provider.dart';
import '../utils/datetime.dart';
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
    context.read<TransactionProvider>().loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<
      DatetimeProvider,
      PlanProvider,
      PillProvider,
      TransactionProvider
    >(
      builder: (
        context,
        datetimeProvider,
        planProvider,
        pillProvider,
        transactionProvider,
        child,
      ) {
        if (planProvider.allPlans.isEmpty) {
          return Center(
            child: Text(AppLocalizations.of(context)!.empty_todayPlanList),
          );
        }

        final todayPlans = planProvider.getDailyPlans(datetimeProvider.today);

        final allMissedPlans = planProvider.getDailyPlans(
          datetimeProvider.yesterday,
        );
        final missedTransactions = transactionProvider.missedTransactions;
        final missedPlans =
            allMissedPlans.where((e) {
              final todayPlan = getTodayPlan(todayPlans, e);
              if (todayPlan != null) {
                final todayTransaction = transactionProvider.todayTransactions
                    .firstWhereOrNull((t) => t.planId == todayPlan.id);
                if (todayTransaction != null &&
                    todayTransaction.quantities.length > 1) {
                  return false;
                }
              }
              if (missedTransactions.isEmpty) return true;
              if (missedTransactions.any((t) => t.planId == e.id)) return false;
              return true;
            }).toList();

        if (todayPlans.isEmpty && missedPlans.isEmpty) {
          return Center(
            child: Text(AppLocalizations.of(context)!.empty_todayPlan),
          );
        }

        final todayCount = todayPlans.length;
        final missedCount = missedPlans.length;

        return Column(
          children: [
            // NEXT 首页增加日期等信息展示
            // Text(DateTime.now().toString().split(' ').first),
            if (missedPlans.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryFixed,
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
                        Text(AppLocalizations.of(context)!.missedPlanTitle),
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
                              fontWeight: FontWeight.w600,
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
                            final plan = missedPlans[index];
                            final pill = pillProvider.pillMap[plan.pillId]!;
                            final todayPlan = getTodayPlan(todayPlans, plan);
                            return _buildMissedItem(
                              context: content,
                              plan: plan,
                              pill: pill,
                              todayPlan: todayPlan,
                              todayDate: datetimeProvider.today,
                              missedDate: datetimeProvider.yesterday,
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
                  final plan = todayPlans[index];
                  // 忽略重复的开始时间
                  if (index > 0 &&
                      todayPlans[index - 1].startTime == plan.startTime) {
                    plan.startTime = '';
                  }
                  final pill = pillProvider.pillMap[plan.pillId]!;
                  final transactions =
                      transactionProvider.todayTransactions
                          .where((transaction) => transaction.planId == plan.id)
                          .toList();
                  final missedPlan = missedPlans.firstWhereOrNull(
                    (e) =>
                        e.pillId == plan.pillId &&
                        e.startTime == plan.startTime,
                  );
                  return _buildItem(
                    context: context,
                    plan: plan,
                    pill: pill,
                    transactions: transactions,
                    isLast: index == todayCount - 1,
                    missedPlan: missedPlan,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required PlanModel plan,
    required PillModel pill,
    required List<TransactionModel> transactions,
    PlanModel? missedPlan,
    bool isLast = false,
  }) {
    final disabled = transactions.isNotEmpty;
    final isDone = transactions.any((t) => t.quantities.isNotEmpty);
    final isChild = plan.startTime.isEmpty;
    final qtyText = '${plan.quantity.displayText}${plan.quantity.unit}';
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            child: Text(
              plan.startTime,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondaryFixed,
              ),
            ),
          ),
          SizedBox(width: 6),
          Stack(
            alignment: Alignment.topCenter,
            // fit: StackFit.expand,
            children: [
              Container(
                width: 2,
                height: isLast ? 104 : 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryFixed,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 6),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color:
                        isChild
                            ? Colors.transparent
                            : Theme.of(context).colorScheme.secondaryFixed,
                    border: Border.all(
                      color:
                          isChild
                              ? Colors.transparent
                              : Theme.of(context).colorScheme.onSecondaryFixed,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 12),
          Expanded(
            child: Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Text(
                            plan.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (disabled && isDone && plan.isExactTime)
                            Expanded(
                              child: Text(
                                '${getFormatTime(TimeOfDay.fromDateTime(transactions.first.startTime))} - ${getFormatTime(TimeOfDay.fromDateTime(transactions.first.endTime!))}',
                                textAlign: TextAlign.end,
                              ),
                            ),
                        ],
                      ),
                    ),
                    ListTile(
                      title: Tooltip(
                        message: pill.name,
                        child: Text(
                          pill.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      subtitle: Tooltip(
                        message: qtyText,
                        child: Text(
                          qtyText,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      leading: PillImage(pill: pill),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed:
                                disabled
                                    ? null
                                    : () => _onSubmit(
                                      now: DateTime.now(),
                                      plan: plan,
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
                                    : () => _onPressed(plan, missedPlan),
                            child: Text(
                              isDone
                                  ? AppLocalizations.of(context)!.taken
                                  : AppLocalizations.of(context)!.take,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissedItem({
    required BuildContext context,
    required PlanModel plan,
    required PillModel pill,
    PlanModel? todayPlan,
    required DateTime todayDate,
    required DateTime missedDate,
  }) {
    final title = [
      plan.startTime,
      '${plan.quantity.displayText}${plan.quantity.unit}',
      pill.name,
    ].join(', ');

    return ListTile(
      title: Tooltip(message: title, child: Text(title)),
      subtitle: Text(plan.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () {
              _onSubmit(now: missedDate, plan: plan);
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
                            if (plan.isExactTime) {
                              (hour, minute) = await _showExactTimePicker();
                            }
                            _onSubmit(
                              now: missedDate,
                              plan: plan,
                              quantities: [plan.quantity],
                              hour: hour,
                              minute: minute,
                            );
                            Navigator.of(context).pop();
                          },
                        ),
                        if (!plan.isExactTime)
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
                                      ? [plan.quantity]
                                      : [plan.quantity, todayPlan.quantity];
                              _onSubmit(
                                now: todayDate,
                                plan: plan,
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

  Future<(int?, int?)> _showExactTimePicker() async {
    int? hour, minute;
    final now = DateTime.now();
    final newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (newTime != null) {
      hour = newTime.hour;
      minute = newTime.minute;
    }
    return (hour, minute);
  }

  void _onPressed(PlanModel plan, PlanModel? missedPlan) async {
    int? hour, minute;
    List<QuantityModel> quantities = [plan.quantity];

    if (plan.isExactTime) {
      (hour, minute) = await _showExactTimePicker();
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
        pillId: plan.pillId,
        planId: plan.id,
        quantities: quantities ?? [],
        startTime: startTime,
        endTime: endTime,
        isNegative: true,
      ),
    );
  }
}

PlanModel? getTodayPlan(List<PlanModel> todayPlans, PlanModel plan) {
  return todayPlans.firstWhereOrNull(
    (p) => p.pillId == plan.pillId && p.startTime == plan.startTime,
  );
}
