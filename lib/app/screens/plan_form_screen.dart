import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../database/repository/pill_repository.dart';
import '../models/pill_model.dart';
import '../models/plan_model.dart';
import '../models/quantity_model.dart';
import '../providers/plan_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/datetime.dart';
import '../widgets/list_wheel_picker.dart';
import '../widgets/quantity_input.dart';
import '../widgets/required_label.dart';
import 'cycle_screen.dart';
import 'reminder_screen.dart';
import 'repeat_screen.dart';

class PlanFormScreen extends StatefulWidget {
  final PlanModel? plan;

  const PlanFormScreen({super.key, this.plan});

  @override
  State<PlanFormScreen> createState() => _PlanFormState();
}

class _PlanFormState extends State<PlanFormScreen> {
  final _formKey = GlobalKey<FormState>();

  List<PillModel> _pillList = [];
  // List<PillModel> _pills = [];
  List<String> _units = [];

  List<PillModel> get _pills =>
      _pillList.length > 3 ? _pillList.sublist(0, 3) : _pillList;

  PlanModel _model = PlanModel(
    pillId: 0,
    name: '',
    quantity: QuantityModel(
      qty: 1,
      unit: '',
      fraction: FractionModel(null, null),
    ),
    startDate: getFormatDate(DateTime.now()),
    endDate: '',
    startTime: '',
    repeatValues: [1],
    repeatUnit: 'day',
    cycles: [],
  );

  // FIX 不知道怎么建出了没有开始时间的计划
  TimeOfDay _startTime = TimeOfDay(hour: 8, minute: 0);

  bool _isCycle = false;

  int _durationValue = 1;
  String _durationUnit = 'hour';

  bool _isUpdate = false;

  bool _unitDisabled = false;
  String? _unitHintText;

  @override
  void initState() {
    super.initState();
    _model.startTime = getFormatTime(_startTime);
    if (widget.plan != null) {
      final times = widget.plan!.startTime.split(':');
      setState(() {
        _isUpdate = true;
        _model = widget.plan!;
        _startTime = TimeOfDay(
          hour: int.parse(times[0]),
          minute: int.parse(times[1]),
        );
        _isCycle = _model.cycles.isNotEmpty;
        if (_model.duration != null) _durationValue = _model.duration!;
        if (_model.durationUnit != null) _durationUnit = _model.durationUnit!;
      });
    }
    _getPills();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isUpdate
              ? AppLocalizations.of(context)!.updatePlan
              : AppLocalizations.of(context)!.addPlan,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPills(),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          label: RequiredLabel(
                            text: AppLocalizations.of(context)!.planForm_name,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(
                              context,
                            )!.validToken_planName_required;
                          }
                          return null;
                        },
                        initialValue: _model.name,
                        onChanged: (v) => setState(() => _model.name = v),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        spacing: 16,
                        children: [
                          Expanded(
                            child: QuantityInput(
                              labelText:
                                  AppLocalizations.of(
                                    context,
                                  )!.planForm_quantity,
                              initialValue: _model.quantity,
                              onChange:
                                  (v) => setState(() {
                                    _model.quantity.qty = v.qty;
                                    _model.quantity.fraction = v.fraction;
                                    _unitDisabled = v.fraction.isNotEmpty;
                                    if (_unitDisabled) {
                                      _unitHintText =
                                          AppLocalizations.of(
                                            context,
                                          )!.quantityUnitWarning;
                                      _model.quantity.unit = _units.last;
                                    } else {
                                      _unitHintText = null;
                                    }
                                  }),
                            ),
                          ),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                label: RequiredLabel(
                                  text:
                                      AppLocalizations.of(
                                        context,
                                      )!.planForm_unit,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(
                                    context,
                                  )!.validToken_planUnit_required;
                                }
                                return null;
                              },
                              items:
                                  _units
                                      .map(
                                        (option) => DropdownMenuItem(
                                          value: option,
                                          child: Text(option),
                                        ),
                                      )
                                      .toList(),
                              value: _model.quantity.unit,
                              onChanged:
                                  _unitDisabled
                                      ? null
                                      : (v) => setState(
                                        () => _model.quantity.unit = v!,
                                      ),
                            ),
                          ),
                        ],
                      ),
                      if (_unitHintText != null)
                        Text(
                          _unitHintText!,
                          style: TextStyle(
                            color: context.read<ThemeProvider>().hintColor,
                          ),
                        ),
                      const SizedBox(height: 16),
                      _buildRepeatSection(),
                      const SizedBox(height: 8),
                      _buildTimeSection(),
                      // const SizedBox(height: 8),
                      // _buildReminderSection(),
                      const SizedBox(height: 8),
                      _buildCycleSection(),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16), // 添加底部间距
            Row(
              children: [
                // Expanded(
                //   child: OutlinedButton(
                //     style: FilledButton.styleFrom(
                //       minimumSize: const Size.fromHeight(48),
                //       textStyle: TextStyle(fontSize: 16),
                //     ),
                //     onPressed: () {},
                //     child: const Text('取消'),
                //   ),
                // ),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                    onPressed: () => _onSubmit(),
                    child: Text(AppLocalizations.of(context)!.save),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPills() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    ..._pills.map((tab) {
                      final isSelected = tab.id == _model.pillId;
                      return Expanded(
                        child: GestureDetector(
                          onTap:
                              () => setState(() {
                                _reloadPill(tab.id!);
                              }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutQuint,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? Theme.of(
                                        context,
                                      ).colorScheme.secondaryContainer
                                      : Theme.of(
                                        context,
                                      ).colorScheme.surfaceContainer,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: themeProvider.getColor(
                                      tab.themeValue,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOutQuint,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                    color:
                                        isSelected
                                            ? Theme.of(
                                              context,
                                            ).colorScheme.onSurface
                                            : Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
                                  ),
                                  child: Text(tab.name),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            if (_pillList.length > 3)
              IconButton(
                onPressed: () {
                  _showPillBottomModal();
                },
                icon: Icon(Icons.more_vert),
              ),
          ],
        );
      },
    );
  }

  void _showPillBottomModal() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return Container(
              padding: EdgeInsets.only(top: 16, bottom: 8),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children:
                      _pillList.map((item) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _reloadPill(item.id!);
                              _reloadPillList(_pillList);
                            });
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              spacing: 8,
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: themeProvider.getColor(
                                      item.themeValue,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Text(item.name),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildListTile(String title, String trailing, void Function()? onTap) {
    return ListTile(
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(trailing, style: TextStyle(fontSize: 16)),
          const SizedBox(width: 4),
          Icon(Icons.arrow_forward_ios, size: 14),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildTimeSection() {
    return Card(
      child: Column(
        children: [
          _buildListTile(
            AppLocalizations.of(context)!.planForm_startTime,
            _model.startTime,
            () async {
              final newTime = await showTimePicker(
                context: context,
                initialTime: _startTime,
                initialEntryMode: TimePickerEntryMode.input,
              );
              if (newTime != null) {
                setState(() {
                  _startTime = newTime;
                  _model.startTime = getFormatTime(newTime);
                });
              }
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.planForm_isExactTime),
            trailing: Switch(
              value: _model.isExactTime,
              onChanged: (v) => setState(() => _model.isExactTime = v),
            ),
          ),
          if (_model.isExactTime)
            _buildListTile(
              AppLocalizations.of(context)!.planForm_duration,
              _model.getDurationText(context),
              () async {
                _durationValue = _model.duration ?? 1;
                _durationUnit = _model.durationUnit ?? 'hour';
                final result = await showDialog<bool>(
                  context: context,
                  builder: (context) => _buildDurationDialog(),
                );
                if (result == null || result == false) return;
                setState(() {
                  _model.duration = _durationValue;
                  _model.durationUnit = _durationUnit;
                });
              },
            ),
        ],
      ),
    );
  }

  AlertDialog _buildDurationDialog() {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.planForm_durationTitle),
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
                  initialValue: _durationValue,
                  onChanged: (v) => setState(() => _durationValue = v),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 200,
                child: ListWheelPicker(
                  // MEMO 药效时长暂时仅支持小时单位
                  options: [
                    // WheelOption(label: '分钟', value: 'minute'),
                    WheelOption(
                      label: AppLocalizations.of(context)!.hour,
                      value: 'hour',
                    ),
                  ],
                  fontSize: 24,
                  initialValue: _durationUnit,
                  onChanged: (v) => setState(() => _durationUnit = v),
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

  void _toRepeatScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RepeatScreen(initialData: _model)),
    );
    if (result is PlanModel) {
      setState(() {
        _model.startDate = result.startDate;
        _model.endDate = result.endDate;
        _model.repeatValues = result.repeatValues;
        _model.repeatUnit = result.repeatUnit;
      });
    }
  }

  Widget _buildRepeatSection() {
    return Card(
      child: Column(
        children: [
          _buildListTile(
            AppLocalizations.of(context)!.repeatSetting,
            _model.getRepeatText(context),
            _toRepeatScreen,
          ),
          _buildListTile(
            AppLocalizations.of(context)!.planForm_startDate,
            _model.startDate,
            () async {
              final newDate = await showDatePicker(
                context: context,
                initialDate: DateTime.parse(_model.startDate),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (newDate != null) {
                setState(() {
                  _model.startDate = getFormatDate(newDate);
                });
              }
            },
          ),
          _buildListTile(
            AppLocalizations.of(context)!.planForm_endDate,
            _model.endDate,
            () async {
              final newDate = await showDatePicker(
                context: context,
                initialDate:
                    _model.endDate.isEmpty
                        ? DateTime.now()
                        : DateTime.parse(_model.endDate),
                firstDate: DateTime.parse(_model.startDate),
                lastDate: DateTime(2100),
              );
              if (newDate != null) {
                setState(() {
                  _model.endDate = getFormatDate(newDate);
                });
              }
            },
          ),
        ],
      ),
    );
  }

  void _toReminderScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ReminderScreen(initialData: _model)),
    );
    if (result is PlanModel) {
      setState(() {
        _model.reminderValue = result.reminderValue;
        _model.reminderUnit = result.reminderUnit;
        _model.reminderMethod = result.reminderMethod;
      });
    }
  }

  Widget _buildReminderSection() {
    return Card(
      child: Column(
        children: [
          _buildListTile(
            AppLocalizations.of(context)!.reminderSetting,
            _model.getReminderText(context),
            _toReminderScreen,
          ),
          if (_model.reminderValue != null)
            ListTile(
              title: Text(
                AppLocalizations.of(context)!.planForm_reminderMethod,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(
                    value: 'notify',
                    groupValue: _model.reminderMethod,
                    onChanged: (v) {
                      setState(() => _model.reminderMethod = v!);
                    },
                  ),
                  Text(
                    AppLocalizations.of(context)!.reminderMethod_notify,
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 16),
                  Radio(
                    value: 'clock',
                    groupValue: _model.reminderMethod,
                    onChanged: (v) {
                      setState(() => _model.reminderMethod = v!);
                    },
                  ),
                  Text(
                    AppLocalizations.of(context)!.reminderMethod_clock,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _toCycleScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CycleScreen(initialData: _model)),
    );
    if (result is PlanModel) {
      setState(() {
        _model.reminderValue = result.reminderValue;
        _model.reminderUnit = result.reminderUnit;
        _model.reminderMethod = result.reminderMethod;
      });
    }
  }

  Widget _buildCycleSection() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(AppLocalizations.of(context)!.isPlanCycle),
            trailing: Switch(
              value: _isCycle,
              onChanged:
                  (v) => setState(() {
                    _isCycle = v;
                    if (!v) _model.cycles = [];
                  }),
            ),
          ),
          if (_isCycle)
            Column(
              children:
                  _model.cycles.isEmpty
                      ? [
                        _buildListTile(
                          AppLocalizations.of(context)!.noInterruptionNeeded,
                          '',
                          () => _toCycleScreen(),
                        ),
                      ]
                      : _model.cycles
                          .map(
                            (cycle) => _buildListTile(
                              cycle.getNameText(context),
                              cycle.getCycleText(context),
                              () => _toCycleScreen(),
                            ),
                          )
                          .toList(),
            ),
        ],
      ),
    );
  }

  void _reloadPill(int pillId) {
    _model.pillId = pillId;
    _units =
        _pillList
            .firstWhere((p) => p.id == pillId)
            .packSpecs
            .map((e) => e.unit)
            .toList();
    _model.quantity.unit = _units.last;
  }

  void _reloadPillList(List<PillModel> list) {
    if (_model.pillId == 0) return;
    final index = list.indexWhere((p) => p.id == _model.pillId);
    if (index == -1) return;
    final item = list.removeAt(index);
    list.insert(0, item);
  }

  Future<void> _getPills() async {
    final list = await context.read<PillRepository>().getAllPills();
    _reloadPillList(list);
    setState(() {
      _pillList = list;
      // _pills = list.length > 3 ? list.sublist(0, 3) : list;
      int pillId = _model.pillId;
      if (_model.pillId == 0) pillId = list.first.id!;
      _reloadPill(pillId);
    });
  }

  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_model.startTime.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.validToken_planStartTime_required,
          ),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }
    if (!_isCycle) _model.cycles = [];
    final provider = context.read<PlanProvider>();
    if (_isUpdate) {
      await provider.updatePlan(_model);
    } else {
      await provider.addPlan(_model);
    }
    Navigator.of(context).pop();
  }
}
