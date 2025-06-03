import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../models/plan_model.dart';
import '../utils/datetime.dart';
import '../widgets/list_wheel_picker.dart';

class RepeatScreen extends StatefulWidget {
  final PlanModel initialData;

  const RepeatScreen({super.key, required this.initialData});

  @override
  State<RepeatScreen> createState() => _RepeatSettingsState();
}

class _RepeatSettingsState extends State<RepeatScreen> {
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;

  DateUnit? _repeatUnit;

  int _dayValue = 1;
  final int _minValue = 1;
  final int _maxValue = 999;

  List<int> _weekValues = [];

  List<int> _monthValues = [];
  bool _isLastDayOfMonth = false;

  @override
  void initState() {
    super.initState();
    _startDate =
        widget.initialData.startDate.isNotEmpty
            ? DateTime.parse(widget.initialData.startDate)
            : DateTime.now();
    _endDate =
        widget.initialData.endDate.isNotEmpty
            ? DateTime.parse(widget.initialData.endDate)
            : null;
    _repeatUnit =
        widget.initialData.repeatUnit.isEmpty
            ? DateUnit.day
            : DateUnit.fromString(widget.initialData.repeatUnit);
    switch (_repeatUnit) {
      case DateUnit.day:
        _repeatUnit = DateUnit.day;
        _dayValue =
            widget.initialData.repeatValues.isEmpty
                ? 1
                : widget.initialData.repeatValues.first;
        break;
      case DateUnit.week:
        _repeatUnit = DateUnit.week;
        _weekValues = widget.initialData.repeatValues;
      case DateUnit.month:
        _repeatUnit = DateUnit.month;
        _monthValues = widget.initialData.repeatValues;
        if (widget.initialData.repeatValues.isNotEmpty &&
            widget.initialData.repeatValues.first == lastDayOfMonth) {
          _isLastDayOfMonth = true;
        }
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.repeatSetting)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDateField(
                      AppLocalizations.of(context)!.planForm_startDate,
                      _startDate,
                      (d) => setState(() => _startDate = d),
                      null,
                    ),
                    const SizedBox(height: 16),
                    _buildDateField(
                      AppLocalizations.of(context)!.planForm_endDate,
                      _endDate,
                      (d) => setState(() => _endDate = d),
                      _startDate,
                    ),
                    const SizedBox(height: 16),
                    _buildUnitOptions(),
                    const SizedBox(height: 36),
                    if (_repeatUnit == DateUnit.day) _buildDayValuePicker(),
                    if (_repeatUnit == DateUnit.week) _buildWeekValuePicker(),
                    if (_repeatUnit == DateUnit.month) _buildMonthValuePicker(),
                    if (_repeatUnit == DateUnit.year) _buildYearValuePicker(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16), // 添加底部间距
            FilledButton(
              onPressed: () => _onPressed(),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                textStyle: TextStyle(fontSize: 16),
              ),
              child: Text(AppLocalizations.of(context)!.confirm),
            ),
          ],
        ),
      ),
    );
  }

  void _onPressed() {
    widget.initialData.startDate = getFormatDate(_startDate);
    widget.initialData.endDate =
        _endDate == null ? '' : getFormatDate(_endDate!);
    widget.initialData.repeatUnit = _repeatUnit!.toString();
    switch (_repeatUnit) {
      case DateUnit.day:
        widget.initialData.repeatValues = [_dayValue];
        break;
      case DateUnit.week:
        widget.initialData.repeatValues = _weekValues;
        break;
      case DateUnit.month:
        widget.initialData.repeatValues =
            _isLastDayOfMonth ? [lastDayOfMonth] : _monthValues;
        break;
      case DateUnit.year:
        widget.initialData.repeatValues = [_startDate.month, _startDate.day];
        break;
      default:
    }
    Navigator.of(context).pop(widget.initialData);
  }

  Widget _buildDateField(
    String label,
    DateTime? date,
    Function(DateTime) onDateChanged,
    DateTime? firstDate,
  ) {
    String dateText = date == null ? '' : getFormatDate(date);
    return InkWell(
      onTap: () async {
        final newDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: firstDate ?? DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (newDate != null) onDateChanged(newDate);
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: dateText.isEmpty ? null : Text(dateText),
      ),
    );
  }

  Widget _buildUnitOptions() {
    final options = <DateUnit, String>{};
    for (final value in DateUnit.values) {
      options[value] = value.displayName(context);
    }
    return Row(
      children:
          options.entries.map((option) {
            final value = option.key;
            final label = option.value;
            return Expanded(
              child: Row(
                spacing: 4,
                children: [
                  Radio<DateUnit>(
                    value: value,
                    groupValue: _repeatUnit,
                    onChanged: (v) => setState(() => _repeatUnit = v),
                  ),
                  Text(label),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildDayValuePicker() {
    // NEXT 支持其它语言，不使用固定的三段式结构
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.every,
          style: TextStyle(fontSize: 18),
        ),
        // 数字滚轮选择器
        SizedBox(
          width: 120,
          height: 200,
          child: ListWheelPicker(
            min: _minValue,
            max: _maxValue,
            initialValue: _dayValue,
            onChanged: (v) => setState(() => _dayValue = v),
          ),
        ),
        Text(DateUnit.day.displayName(context), style: TextStyle(fontSize: 18)),
      ],
    );
  }

  Widget _buildWeekValuePicker() {
    // NEXT 动态计算一行显示数量，优化极端小屏的体验
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 4,
      children: List.generate(7, (index) {
        final value = index + 1;
        final label = getWeekdayDisplayName(context, value);
        final isSelected = _weekValues.contains(value);
        return Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: InkWell(
              onTap:
                  () => setState(() {
                    if (isSelected) {
                      _weekValues.remove(value);
                    } else {
                      _weekValues.add(value);
                    }
                  }),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      color:
                          isSelected
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildMonthValuePicker() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.monthlyLastDay,
              style: TextStyle(fontSize: 16),
            ),
            Switch(
              value: _isLastDayOfMonth,
              onChanged: (v) => setState(() => _isLastDayOfMonth = v),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (!_isLastDayOfMonth)
          GridView.count(
            crossAxisCount: 7, // 每行7天
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 1, // 保持正方形
            children: List.generate(31, (index) {
              final day = index + 1;
              final isSelected = _monthValues.contains(day);
              return InkWell(
                onTap:
                    () => setState(() {
                      if (isSelected) {
                        _monthValues.remove(day);
                      } else {
                        _monthValues.add(day);
                      }
                    }),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      '$day',
                      style: TextStyle(
                        color:
                            isSelected
                                ? Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer
                                : Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
      ],
    );
  }

  Widget _buildYearValuePicker() {
    final locale = Localizations.localeOf(context).toString();
    final pattern = AppLocalizations.of(context)!.repeatYearPattern;
    final text = DateFormat(pattern, locale).format(_startDate);
    return Text(
      text,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
