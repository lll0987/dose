import 'dart:math';

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
import '../utils/datetime.dart';
import '../widgets/pill_image.dart';

class DailyScreen extends StatefulWidget {
  const DailyScreen({super.key});

  @override
  State<DailyScreen> createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen> {
  final _minCount = 10;

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

            final todayCount = dailyProvider.dailyItems.length;
            final missedCount = dailyProvider.missedItems.length;

            final warningPillList =
                pillProvider.pillPlanCount.entries
                    .where((e) => e.value != -1 && e.value < _minCount)
                    .map((e) => e.key)
                    .toList();

            // NEXT 首页增加日期等信息展示
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  if (warningPillList.isNotEmpty || missedCount > 0)
                    SizedBox(height: 8),
                  /* 次数提醒 */
                  if (warningPillList.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.error.withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 0,
                      ),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children:
                            warningPillList.map((id) {
                              final pill = pillProvider.pillMap[id]!;
                              final message = AppLocalizations.of(
                                context,
                              )!.doses(
                                pillProvider.pillPlanCount[id]!,
                                pill.name,
                              );
                              return Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: themeProvider.getColor(
                                        pill.themeValue,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Tooltip(
                                    message: message,
                                    child: Text(
                                      message,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                      ),
                    ),
                  if (warningPillList.isNotEmpty && missedCount > 0)
                    SizedBox(height: 8),
                  /* 漏药提醒 */
                  if (missedCount > 0)
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 0,
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
                                return _buildMissedItem(
                                  context: content,
                                  item: item,
                                  pill: pillProvider.pillMap[item.plan.pillId]!,
                                );
                              },
                              separatorBuilder: (_, __) => const Divider(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (warningPillList.isNotEmpty || missedCount > 0)
                    SizedBox(height: 8),
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
                        return _buildItem(
                          context: context,
                          startTime: startTime,
                          item: item,
                          pill: pillProvider.pillMap[item.plan.pillId]!,
                          bottom: index == todayCount - 1 ? 8 : 0,
                        );
                      },
                    ),
                  ),
                ],
              ),
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
    required double bottom,
  }) {
    final disabled = item.status != PlanStatus.missed;
    final isDone = item.status == PlanStatus.taken;
    final quantity =
        item.qty == null || item.qty!.isEmpty
            ? item.plan.quantity.displayText
            : item.qty!;
    final title = '$quantity${item.plan.quantity.unit}, ${pill.name}';
    final timeText = '${item.startTime} - ${item.endTime}';

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
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
                                    : () => _onIgnore(plan: item.plan),
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
                                    : () async {
                                      if (item.plan.isExactTime ||
                                          item.missedPlan == null) {
                                        _onTake(plan: item.plan);
                                      } else {
                                        final single = await _showDailyDialog();
                                        if (single == null) return;
                                        if (single) {
                                          _onTake(plan: item.plan);
                                        } else {
                                          _onTakeBoth(
                                            item.plan,
                                            item.missedPlan!,
                                          );
                                        }
                                      }
                                    },
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
              _onIgnore(
                plan: item.plan,
                date: DateTime.now().subtract(const Duration(days: 1)),
              );
            },
            child: Text(AppLocalizations.of(context)!.ignore),
          ),
          ElevatedButton(
            onPressed: () async {
              final date = DateTime.now().subtract(const Duration(days: 1));
              if (item.plan.isExactTime) {
                _onTake(plan: item.plan, date: date);
              } else {
                final isDaily = item.dailyPlan != null;
                // 打开底部弹窗
                final single = await _showMissedBottomSheet(isDaily);
                if (single == null) return;
                if (single) {
                  _onTake(plan: item.plan, date: date);
                } else {
                  _onTakeBoth(item.dailyPlan!, item.plan);
                }
              }
            },
            child: Text(AppLocalizations.of(context)!.take),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showMissedBottomSheet(bool isDaily) async {
    final result = await showModalBottomSheet<bool>(
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
                subtitle: Text(AppLocalizations.of(context)!.takenYesterdaySub),
                onTap: () => Navigator.of(context).pop(true),
              ),
              if (isDaily)
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.takenToday,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(AppLocalizations.of(context)!.takenTodaySub),
                  onTap: () => Navigator.of(context).pop(false),
                ),
            ],
          ),
        );
      },
    );
    return result;
  }

  Future<bool?> _showDailyDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(AppLocalizations.of(context)!.takeBothTitle),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(AppLocalizations.of(context)!.takeOnlyToday),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(AppLocalizations.of(context)!.takeBoth),
            ),
          ],
        );
      },
    );
    return result;
  }

  void _onIgnore({required PlanModel plan, DateTime? date}) async {
    date ??= DateTime.now();
    loadingService.show();
    await context.read<TransactionProvider>().addTransaction(
      TransactionModel(
        planId: plan.id,
        revisionId: plan.revisionId,
        pillId: plan.pillId,
        quantities: [],
        startTime: date,
        endTime: null,
        isNegative: true,
        isCustom: false,
      ),
    );
    loadingService.hide();
  }

  void _onTake({required PlanModel plan, DateTime? date}) async {
    date ??= DateTime.now();
    loadingService.show();
    // 开始时间
    var (hour, minute) = getTimeFromString(plan.startTime)!;
    if (plan.isExactTime) {
      final newTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: hour, minute: minute),
        initialEntryMode: TimePickerEntryMode.input,
      );
      if (newTime == null) return;
      hour = newTime.hour;
      minute = newTime.minute;
    }
    // 开始/结束日期时间
    final (startTime, endTime) = plan.getTimeRange(
      date: date,
      hour: hour,
      minute: minute,
    );
    // 提交数据
    await context.read<TransactionProvider>().addTransaction(
      TransactionModel(
        planId: plan.id,
        revisionId: plan.revisionId,
        pillId: plan.pillId,
        quantities: [plan.quantity],
        startTime: startTime,
        endTime: endTime,
        isNegative: true,
        isCustom: false,
      ),
    );
    loadingService.hide();
  }

  void _onTakeBoth(PlanModel dailyPlan, PlanModel missedPlan) async {
    final date = DateTime.now();
    loadingService.show();
    final (startTime, endTime) = dailyPlan.getTimeRange(date: date);
    final quantities = [dailyPlan.quantity, missedPlan.quantity];
    final transaction = TransactionModel(
      planId: dailyPlan.id,
      revisionId: dailyPlan.revisionId,
      pillId: dailyPlan.pillId,
      quantities: quantities,
      startTime: startTime,
      endTime: endTime,
      isNegative: true,
      isCustom: false,
    );

    final yesterday = date.subtract(const Duration(days: 1));
    final (start, end) = missedPlan.getTimeRange(date: yesterday);
    final missed = TransactionModel(
      planId: missedPlan.id,
      revisionId: missedPlan.revisionId,
      pillId: missedPlan.pillId,
      quantities: [
        missedPlan.quantity.copyWith(
          qty: 0,
          fraction: FractionModel(null, null),
        ),
      ],
      startTime: start,
      endTime: end,
      isNegative: true,
      isCustom: false,
    );
    // 提交数据
    await context.read<TransactionProvider>().addTransactions([
      transaction,
      missed,
    ]);
    loadingService.hide();
  }
}
