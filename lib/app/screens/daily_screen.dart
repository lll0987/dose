import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pill_model.dart';
import '../models/plan_model.dart';
import '../models/transaction_model.dart';
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
  int getUnitDifference(DateTime startDate, DateTime today, String unit) {
    final days = today.difference(startDate).inDays;
    if (unit == DateUnit.day.toString()) return days;
    if (unit == DateUnit.week.toString()) return days ~/ 7;
    if (unit == DateUnit.month.toString()) {
      return (today.year - startDate.year) * 12 +
          (today.month - startDate.month);
    }
    if (unit == DateUnit.year.toString()) return today.year - startDate.year;
    return 0;
  }

  bool isPlanStop(List<CycleModel> cycles) {
    if (cycles.isEmpty) return false;
    // final firstUnit = cycles[0].unit;
    // for (var cycle in cycles) {
    //   if (cycle.unit != firstUnit) {
    //     throw ArgumentError('所有周期的单位必须一致，发现不一致的单位：$firstUnit vs ${cycle.unit}');
    //   }
    // }
    // final totalUnits = getUnitDifference(startDay, today, cycles[0].unit);
    // final totalCycleLength = cycles.map((c) => c.value).reduce((a, b) => a + b);
    // if (totalCycleLength > 0) {
    //   final currentPosition = totalUnits % totalCycleLength;
    //   int cumulative = 0;
    //   for (var cycle in cycles) {
    //     if (currentPosition >= cumulative &&
    //         currentPosition < cumulative + cycle.value &&
    //         cycle.isStop) {
    //       return false;
    //     }
    //     cumulative += cycle.value;
    //   }
    // }
    return false;
  }

  bool isPlanActive(PlanModel plan, DateTime now) {
    if (plan.isEnabled == false) return false;
    if (plan.repeatValues.isEmpty) return false;
    if (plan.endDate.isNotEmpty) {
      final endDate = DateTime.parse(plan.endDate).add(Duration(days: 1));
      if (now.isAfter(endDate)) return false;
    }

    final unit = plan.repeatUnit;
    final today = DateTime(now.year, now.month, now.day);
    final startDate = plan.startDate.split('-');
    final startDay = DateTime(
      int.parse(startDate[0]),
      int.parse(startDate[1]),
      int.parse(startDate[2]),
    );

    final isStop = isPlanStop(plan.cycles);
    if (isStop) return false;

    if (unit == DateUnit.day.toString()) {
      final val = plan.repeatValues[0];
      if (val < 2) return true;
      final daysDiff = today.difference(startDay).inDays;
      return daysDiff % val == 0;
    }

    if (unit == DateUnit.week.toString()) {
      final currentWeekday = now.weekday; // Monday = 1 ... Sunday = 7
      return plan.repeatValues.contains(currentWeekday);
    }

    if (unit == DateUnit.month.toString()) {
      final currentDay = now.day;
      final values = plan.repeatValues;
      if (values[0] == -1) {
        final lastDayOfMonth = DateTime(now.year, now.month + 1, 0).day;
        return currentDay == lastDayOfMonth;
      }
      return values.contains(currentDay);
    }

    if (unit == DateUnit.year.toString()) {
      if (plan.repeatValues.length != 2) return false;
      final month = plan.repeatValues[0];
      final day = plan.repeatValues[1];
      return today.month == month && today.day == day;
    }

    return false;
  }

  @override
  void initState() {
    super.initState();
    context.read<PillProvider>().loadPills();
    context.read<PlanProvider>().loadPlans();
    context.read<TransactionProvider>().loadTransactions(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // NEXT 年视图
          IconButton(onPressed: () {}, icon: Icon(Icons.calendar_month)),
        ],
      ),
      body: Consumer3<PlanProvider, PillProvider, TransactionProvider>(
        builder: (
          context,
          planProvider,
          pillProvider,
          transactionProvider,
          child,
        ) {
          if (planProvider.allPlans.isEmpty) {
            return Center(child: Text("No plans yet."));
          }
          final today = DateTime.now();
          final plans =
              planProvider.allPlans
                  .where((plan) => isPlanActive(plan, today))
                  .sorted((a, b) {
                    // 将 HH:mm 转换为总分钟数，便于比较
                    int toMinutes(String time) {
                      final parts = time.split(':');
                      final hour = int.parse(parts[0]);
                      final minute = int.parse(parts[1]);
                      return hour * 60 + minute;
                    }

                    final aMin = toMinutes(a.startTime);
                    final bMin = toMinutes(b.startTime);
                    return aMin.compareTo(bMin); // 升序排列
                    // 若需要降序，则改为 bMin.compareTo(aMin)
                  })
                  .toList();
          final length = plans.length;
          return Column(
            children: [
              // NEXT 首页UI，增加日期等信息展示
              // Text(DateTime.now().toString().split(' ').first),
              Expanded(
                child: ListView.builder(
                  itemCount: length,
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    if (index > 0 &&
                        plans[index - 1].startTime == plan.startTime) {
                      plan.startTime = '';
                    }
                    final pill = pillProvider.pillMap[plan.pillId]!;
                    final transactions =
                        transactionProvider.todayTransactions
                            .where(
                              (transaction) => transaction.planId == plan.id,
                            )
                            .toList();
                    return _buildItem(
                      context: context,
                      plan: plan,
                      pill: pill,
                      transactions: transactions,
                      isLast: index == length - 1,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required PlanModel plan,
    required PillModel pill,
    required List<TransactionModel> transactions,
    bool isLast = false,
  }) {
    final disabled = transactions.isNotEmpty;
    final isDone = transactions.any((t) => t.quantities.isNotEmpty);
    final isChild = plan.startTime.isEmpty;
    final qty =
        plan.numerator == null || plan.denominator == null
            ? '${plan.qty}${plan.unit}'
            : '${plan.qty} + ${plan.numerator}/${plan.denominator}${plan.unit}';
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
                height: isLast ? 108 : 124,
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
                padding: const EdgeInsets.only(top: 4, bottom: 8),
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
                          TextButton(
                            onPressed:
                                disabled ? null : () => _onSubmit(plan: plan),
                            child: Text(
                              isDone
                                  ? ''
                                  : disabled
                                  ? '已忽略'
                                  : '忽略',
                            ),
                          ),
                          if (disabled && plan.isExactTime)
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
                        message: qty,
                        child: Text(
                          qty,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      leading: PillImage(imagePath: pill.imagePath),
                      trailing: FilledButton(
                        onPressed: disabled ? null : () => _onPressed(plan),
                        child: Text(isDone ? '已用药' : '用药'),
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

  void _onPressed(PlanModel plan) async {
    final quantities = [
      QuantityModel(
        qty: plan.qty,
        unit: plan.unit,
        numerator: plan.numerator,
        denominator: plan.denominator,
      ),
    ];
    int? hour, minute;
    if (plan.isExactTime) {
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
    }
    _onSubmit(plan: plan, quantities: quantities, hour: hour, minute: minute);
  }

  void _onSubmit({
    required PlanModel plan,
    List<QuantityModel>? quantities,
    int? hour,
    int? minute,
  }) async {
    final time = plan.startTime.split(':');
    final now = DateTime.now();
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
        timestamp: now,
        startTime: startTime,
        endTime: endTime,
        isNegative: true,
      ),
    );
  }
}
