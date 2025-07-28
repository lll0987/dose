import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../models/plan_model.dart';
import '../providers/theme_provider.dart';
import '../widgets/list_wheel_picker.dart';

class CycleScreen extends StatefulWidget {
  final PlanModel initialData;

  const CycleScreen({super.key, required this.initialData});

  @override
  State<CycleScreen> createState() => _CycleScreenState();
}

class _CycleScreenState extends State<CycleScreen> {
  List<WheelOption> _cycleUnits = [];

  List<CycleModel> _list = [];
  int _cycleValue = 1;
  String _cycleUnit = 'day';

  @override
  void initState() {
    super.initState();
    if (widget.initialData.cycles.isEmpty) {
      _onAdd();
    } else {
      _list = widget.initialData.cycles;
      _cycleValue = _list.first.value;
      _cycleUnit = _list.first.unit;
    }
  }

  @override
  Widget build(BuildContext context) {
    _cycleUnits = [
      WheelOption(
        value: DateUnit.day.name,
        label: DateUnit.day.displayName(context),
      ),
      WheelOption(
        value: DateUnit.week.name,
        label: DateUnit.week.displayName(context),
      ),
      WheelOption(
        value: DateUnit.month.name,
        label: DateUnit.month.displayName(context),
      ),
      WheelOption(
        value: DateUnit.year.name,
        label: DateUnit.year.displayName(context),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.cycleSetting)),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  spacing: 16,
                  children: [
                    Row(
                      spacing: 4,
                      children: [
                        Icon(
                          Icons.info_outlined,
                          size: 16,
                          color: context.read<ThemeProvider>().hintColor,
                        ),
                        Text(
                          AppLocalizations.of(context)!.dateCoefficient,
                          style: TextStyle(
                            color: context.read<ThemeProvider>().hintColor,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      spacing: 8,
                      children: [
                        ..._list.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;
                          return Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => _showCycleDialog(context, item),
                                  child: Card(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SegmentedButton(
                                            segments: [
                                              ButtonSegment(
                                                label: Text(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.medication,
                                                ),
                                                value: false,
                                              ),
                                              ButtonSegment(
                                                label: Text(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.withdrawal,
                                                ),
                                                value: true,
                                              ),
                                            ],
                                            selected: {item.isStop},
                                            onSelectionChanged:
                                                (v) => setState(
                                                  () => item.isStop = v.first,
                                                ),
                                          ),
                                          Text(
                                            item.getCycleText(context),
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton.filledTonal(
                                onPressed:
                                    index == 0
                                        ? null
                                        : () {
                                          setState(() {
                                            _list.removeAt(index);
                                          });
                                        },
                                icon: Icon(Icons.close),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: _list.length >= 5 ? null : () => _onAdd(),
                      label: Text(AppLocalizations.of(context)!.addRow),
                      icon: Icon(Icons.add),
                      style: ElevatedButton.styleFrom(
                        elevation: 2,
                        minimumSize: const Size(double.infinity, 40),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: FilledButton(
              onPressed: () => _onPressed(context),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                textStyle: TextStyle(fontSize: 16),
              ),
              child: Text(AppLocalizations.of(context)!.confirm),
            ),
          ),
        ],
      ),
    );
  }

  void _showCycleDialog(BuildContext context, CycleModel item) async {
    _cycleValue = item.value;
    _cycleUnit = item.unit;
    final title =
        item.isStop
            ? AppLocalizations.of(context)!.withdrawalPeriodTitle
            : AppLocalizations.of(context)!.medicationPeriodTitle;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => _buildCycleDialog(context, title),
    );
    if (result == null || result == false) return;
    setState(() {
      item
        ..value = _cycleValue
        ..unit = _cycleUnit;
    });
  }

  AlertDialog _buildCycleDialog(BuildContext context, String title) {
    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        height: 200,
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 200,
                child: ListWheelPicker(
                  min: 1,
                  max: 99,
                  fontSize: 24,
                  initialValue: _cycleValue,
                  onChanged: (v) => setState(() => _cycleValue = v),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 200,
                child: ListWheelPicker(
                  options: _cycleUnits,
                  fontSize: 24,
                  initialValue: _cycleUnit,
                  onChanged: (v) => setState(() => _cycleUnit = v),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          child: Text(AppLocalizations.of(context)!.confirm),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }

  void _onAdd() {
    if (_list.length >= 5) return;
    final unit = _list.isEmpty ? 'day' : _list.first.unit;
    final isStop = _list.isEmpty ? false : !_list.last.isStop;
    setState(() => _list.add(CycleModel(value: 1, unit: unit, isStop: isStop)));
  }

  void _onPressed(BuildContext context) {
    if (_list.length < 2 ||
        _list.every((e) => e.isStop) ||
        _list.every((e) => !e.isStop)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.validToken_cycleStatus),
        ),
      );
      return;
    }
    widget.initialData.cycles = _list;
    Navigator.of(context).pop(widget.initialData);
  }
}
