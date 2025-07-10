import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/pill_model.dart';
import '../models/plan_model.dart';
import '../models/transaction_model.dart';
import '../providers/daily_provider.dart';
import '../providers/pill_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/transaction_provider.dart';
import '../service/loading_service.dart';
import '../utils/datetime.dart';

class MonthScreen extends StatefulWidget {
  const MonthScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MonthScreenState();
}

class _MonthScreenState extends State<StatefulWidget> {
  late int _currentYear;
  late int _currentMonth;

  late Map<PlanStatus, StatusColor> _statusOptions;

  Future<void> _loadHistoryData() async {
    await context.read<DailyProvider>().loadHistoryData(
      year: _currentYear,
      month: _currentMonth,
    );
  }

  void _loadData() async {
    loadingService.show();
    await _loadHistoryData();
    loadingService.hide();
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentYear = now.year;
    _currentMonth = now.month;
    _loadHistoryData();
  }

  @override
  Widget build(BuildContext context) {
    _statusOptions = {
      PlanStatus.ignored: StatusColor(
        bgColor: Theme.of(context).colorScheme.surfaceContainer,
        borderColor: Theme.of(context).colorScheme.outline,
        text: AppLocalizations.of(context)!.statusOption_ignored,
      ),
      PlanStatus.missed: StatusColor(
        bgColor: Theme.of(context).colorScheme.errorContainer,
        borderColor: Theme.of(context).colorScheme.onErrorContainer,
        text: AppLocalizations.of(context)!.statusOption_missed,
      ),
      PlanStatus.scheduled: StatusColor(
        bgColor: Colors.white70,
        borderColor: Theme.of(context).colorScheme.onSecondaryContainer,
        text: AppLocalizations.of(context)!.statusOption_scheduled,
      ),
      PlanStatus.supplemented: StatusColor(
        bgColor: Theme.of(context).colorScheme.tertiaryContainer,
        borderColor: Theme.of(context).colorScheme.onTertiaryContainer,
        text: AppLocalizations.of(context)!.statusOption_supplemented,
      ),
      PlanStatus.taken: StatusColor(
        bgColor: Theme.of(context).colorScheme.primaryContainer,
        borderColor: Theme.of(context).colorScheme.onPrimaryContainer,
        text: AppLocalizations.of(context)!.statusOption_taken,
      ),
    };

    final firstDayOfMonth = DateTime(_currentYear, _currentMonth, 1);
    final lastDayOfMonth = DateTime(_currentYear, _currentMonth + 1, 0);
    final firstDayOfWeek = firstDayOfMonth.weekday;

    final locale = Localizations.localeOf(context).toString();
    final monthText = DateFormat.MMMM(locale).format(firstDayOfMonth);

    return Consumer2<DailyProvider, PillProvider>(
      builder: (context, provider, pillProvider, child) {
        final data = provider.monthItems;
        final maxCount =
            data.isNotEmpty
                ? data.entries.map((entry) => entry.value.length).reduce(max)
                : 0;
        final double height = maxCount * 22 + 34;

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton.outlined(
                    onPressed: () {
                      setState(() {
                        if (_currentMonth == 1) {
                          _currentMonth = 12;
                          _currentYear--;
                        } else {
                          _currentMonth--;
                        }
                        _loadData();
                      });
                    },
                    icon: Icon(Icons.chevron_left),
                  ),
                  Text(
                    '$monthText, $_currentYear',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  IconButton.outlined(
                    onPressed: () {
                      setState(() {
                        if (_currentMonth == 12) {
                          _currentMonth = 1;
                          _currentYear++;
                        } else {
                          _currentMonth++;
                        }
                        _loadData();
                      });
                    },
                    icon: Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: List.generate(
                  7,
                  (index) => Expanded(
                    child: Center(
                      child: Text(
                        getWeekdayMinDisplayName(context, index + 1),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    mainAxisExtent: height,
                  ),
                  itemCount: firstDayOfWeek + lastDayOfMonth.day - 1,
                  itemBuilder: (context, index) {
                    if (index < firstDayOfWeek - 1) {
                      return SizedBox.shrink(); // 空占位
                    }
                    final day = index - firstDayOfWeek + 2;
                    return _buildDayTile(
                      day,
                      data[day] ?? [],
                      pillProvider.pillMap,
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  _buildStatusLegend(PlanStatus.taken),
                  _buildStatusLegend(PlanStatus.missed),
                  _buildStatusLegend(PlanStatus.supplemented),
                  _buildStatusLegend(PlanStatus.ignored),
                  _buildStatusLegend(PlanStatus.scheduled),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusLegend(PlanStatus status) {
    final option = _statusOptions[status]!;
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: option.bgColor,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 2),
        Text(option.text, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildDayTile(
    int day,
    List<PlanItem> data,
    Map<int, PillModel> pillMap,
  ) {
    if (day < 1) return SizedBox.shrink(); // 空占位
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return InkWell(
          onTap: () => _showPlansDialog(day),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 32,
                  child: Center(
                    child: Row(children: [SizedBox(width: 4), Text('$day')]),
                  ),
                ),
                ...List.generate(data.length, (index) {
                  final item = data[index];
                  final pill = pillMap[item.plan.pillId]!;
                  final text = '${item.plan.name}, ${pill.name}';

                  final bgColor = _statusOptions[item.status]!.bgColor;
                  final borderColor = _statusOptions[item.status]!.borderColor;

                  return Container(
                    decoration: BoxDecoration(
                      // border: Border.all(color: borderColor),
                      borderRadius: BorderRadius.circular(4),
                      color: bgColor,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    margin: EdgeInsets.only(left: 4, right: 4, bottom: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: themeProvider.getColor(pill.themeValue),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 2),
                        Expanded(
                          child: Tooltip(
                            message: text,
                            child: Text(
                              text,
                              style: TextStyle(
                                fontSize: 12,
                                color: borderColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPlansDialog(int day) async {
    final date = DateTime(_currentYear, _currentMonth, day);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Consumer3<DailyProvider, ThemeProvider, PillProvider>(
            builder: (context, provider, themeProvider, pillProvider, child) {
              final data = provider.monthItems[day] ?? [];
              return SingleChildScrollView(
                child: Column(
                  spacing: 8,
                  children:
                      List.generate(data.length, (index) {
                        final item = data[index];
                        final pill = pillProvider.pillMap[item.plan.pillId]!;
                        final quantity =
                            item.transaction?.calcQty ??
                            item.plan.quantity.displayText;
                        final unit = item.plan.quantity.unit;
                        final text = '${pill.name}, $quantity$unit';
                        final subText =
                            '${item.plan.name}, ${item.plan.startTime}';

                        final bgColor = _statusOptions[item.status]!.bgColor;
                        final borderColor =
                            _statusOptions[item.status]!.borderColor;

                        final enabled =
                            item.status == PlanStatus.ignored ||
                            item.status == PlanStatus.missed;

                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: bgColor,
                          ),
                          child: ExpansionTile(
                            shape: Border(),
                            collapsedShape: Border(),
                            showTrailingIcon: enabled,
                            enabled: enabled,
                            title: Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: themeProvider.getColor(
                                      pill.themeValue,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 2),
                                Expanded(
                                  child: Tooltip(
                                    message: text,
                                    child: Text(
                                      text,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: borderColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                Expanded(
                                  child: Tooltip(
                                    message: text,
                                    child: Text(
                                      subText,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: borderColor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 8, right: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (item.status == PlanStatus.ignored)
                                      ElevatedButton(
                                        onPressed:
                                            () => _onDelete(date, item.plan),
                                        child: Text(
                                          AppLocalizations.of(context)!.cancel,
                                        ),
                                      ),
                                    if (item.status == PlanStatus.missed)
                                      ElevatedButton(
                                        onPressed:
                                            () => _onAdd(date, item.plan),
                                        child: Text(
                                          AppLocalizations.of(context)!.take,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.close),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onDelete(DateTime date, PlanModel plan) async {
    loadingService.show();
    await context.read<TransactionProvider>().deleteTransactionFromPlan(
      plan.id!,
      date,
    );
    loadingService.hide();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.success)),
    );
  }

  Future<void> _onAdd(DateTime date, PlanModel plan) async {
    final [h, m] = plan.startTime.split(':');
    int hour = int.parse(h);
    int minute = int.parse(m);
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
    loadingService.show();
    final startTime = DateTime(date.year, date.month, date.day, hour, minute);
    // MEMO 药效时长不仅有小时单位时需要调整
    final endTime =
        plan.isExactTime
            ? startTime.add(Duration(hours: plan.duration!))
            : null;
    await context.read<TransactionProvider>().addTransaction(
      TransactionModel(
        planId: plan.id,
        revisionId: plan.revisionId,
        pillId: plan.pillId,
        quantities: [plan.quantity],
        startTime: startTime,
        endTime: endTime,
        isNegative: true,
      ),
    );
    loadingService.hide();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.success_save)),
    );
  }
}

class StatusColor {
  Color borderColor;
  Color bgColor;
  String text;

  StatusColor({
    required this.borderColor,
    required this.bgColor,
    this.text = '',
  });
}
