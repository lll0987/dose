import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../core/data/models/pill_model.dart';
import '../core/data/models/plan_model.dart';
import '../core/data/providers/plan_provider.dart';
import '../core/data/services/pill_service.dart';
import '../widgets/list_wheel_picker.dart';
import '../widgets/quantity_input.dart';
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
  List<PillModel> _pills = [];
  List<String> _units = [];

  PlanModel _model = PlanModel(
    pillId: '',
    name: '',
    qty: 1,
    unit: '',
    startDate: getFormatDate(DateTime.now()),
    endDate: '',
    startTime: '',
    repeatValues: [1],
    repeatUnit: 'day',
    cycles: [],
  );

  TimeOfDay _startTime = TimeOfDay(hour: 0, minute: 0);

  final List<WheelOption> _cycleUnits = [
    WheelOption(value: DateUnit.day.value, label: DateUnit.day.displayName),
    WheelOption(value: DateUnit.week.value, label: DateUnit.week.displayName),
    WheelOption(value: DateUnit.month.value, label: DateUnit.month.displayName),
    WheelOption(value: DateUnit.year.value, label: DateUnit.year.displayName),
  ];
  bool _isCycle = false;
  int _cycleValue = 1;
  String _cycleUnit = 'day';

  int _durationValue = 1;
  String _durationUnit = 'hour';

  bool _isUpdate = false;

  @override
  void initState() {
    super.initState();
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
        if (_isCycle) {
          _cycleValue = _model.cycles.first.value;
          _cycleUnit = _model.cycles.first.unit;
        }
        if (_model.duration != null) _durationValue = _model.duration!;
        if (_model.durationUnit != null) _durationUnit = _model.durationUnit!;
      });
    }
    _getPills();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isUpdate ? '编辑计划' : '新建计划')),
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
                        decoration: InputDecoration(labelText: '计划标题'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '请输入计划标题';
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
                              labelText: '计划用药数量',
                              initialInteger: _model.qty,
                              initialNumerator: _model.numerator,
                              initialDenominator: _model.denominator,
                              onChange:
                                  (v) => setState(() {
                                    _model.qty = v.integer;
                                    _model.numerator = v.numerator;
                                    _model.denominator = v.denominator;
                                  }),
                            ),
                          ),
                          Expanded(
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(labelText: '药物单位'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '请选择药物单位';
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
                              value: _model.unit,
                              onChanged:
                                  (v) => setState(() => _model.unit = v!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTimeSection(),
                      const SizedBox(height: 8),
                      _buildRepeatSection(),
                      const SizedBox(height: 8),
                      _buildReminderSection(),
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
                    child: const Text('保存'),
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
                            _reloadPill(tab.id);
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
                                color: tab.getThemeColor(),
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
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
      ],
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
          _buildListTile('计划用药时间', _model.startTime, () async {
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
          }),
          ListTile(
            title: Text('实际用药时间'),
            trailing: Switch(
              value: _model.isExactTime,
              onChanged: (v) => setState(() => _model.isExactTime = v),
            ),
          ),
          if (_model.isExactTime)
            _buildListTile('药效时长', _model.getDurationText(), () async {
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
            }),
        ],
      ),
    );
  }

  AlertDialog _buildDurationDialog() {
    return AlertDialog(
      title: Text('设置药效时长'),
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
                    WheelOption(label: '小时', value: 'hour'),
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
          child: const Text('取消'),
        ),
        TextButton(
          child: const Text('确定'),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }

  void toRepeatScreen() async {
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
          _buildListTile('重复', _model.getRepeatText(), toRepeatScreen),
          _buildListTile('结束重复', _model.getRepeatEndText(), toRepeatScreen),
        ],
      ),
    );
  }

  void toReminderScreen() async {
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
          _buildListTile('提醒', _model.getReminderText(), toReminderScreen),
          if (_model.reminderValue != null)
            ListTile(
              title: const Text('提醒方式'),
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
                  const Text('通知', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 16),
                  Radio(
                    value: 'clock',
                    groupValue: _model.reminderMethod,
                    onChanged: (v) {
                      setState(() => _model.reminderMethod = v!);
                    },
                  ),
                  const Text('闹钟', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCycleSection() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('停药周期'),
            trailing: Switch(
              value: _isCycle,
              onChanged: (v) => setState(() => _isCycle = v),
            ),
          ),
          // NEXT 重构周期代码，支持完全自定义
          if (_isCycle)
            Column(
              children:
                  _model.cycles.isEmpty
                      ? [
                        _buildListTile('用药', '', () => _showCycleDialog(false)),
                        _buildListTile('停药', '', () => _showCycleDialog(true)),
                      ]
                      : _model.cycles
                          .map(
                            (cycle) => _buildListTile(
                              cycle.getNameText(),
                              cycle.getCycleText(),
                              () => _showCycleDialog(cycle.isStop),
                            ),
                          )
                          .toList(),
            ),
        ],
      ),
    );
  }

  void _showCycleDialog(bool isStop) async {
    final cycle = _model.cycles.firstWhere(
      (c) => c.isStop == isStop,
      orElse: () => Cycle(value: 1, unit: 'day', isStop: isStop),
    );
    _cycleValue = cycle.value;
    _cycleUnit = cycle.unit;
    final title = isStop ? '设置停药周期' : '设置用药周期';
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => _buildCycleDialog(title),
    );
    if (result == null || result == false) return;
    // 使用 indexWhere 查找符合条件的索引
    final index = _model.cycles.indexWhere((c) => c.isStop == isStop);
    setState(() {
      if (index == -1) {
        // 未找到时添加新元素
        _model.cycles.add(
          Cycle(
            value: isStop ? 1 : _cycleValue,
            unit: _cycleUnit,
            isStop: false,
          ),
        );
        _model.cycles.add(
          Cycle(
            value: isStop ? _cycleValue : 1,
            unit: _cycleUnit,
            isStop: true,
          ),
        );
      } else {
        // 找到时更新现有元素
        _model.cycles[index]
          ..value = _cycleValue
          ..unit = _cycleUnit;
      }
    });
  }

  AlertDialog _buildCycleDialog(String title) {
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
          child: const Text('取消'),
        ),
        TextButton(
          child: const Text('确定'),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }

  void _reloadPill(String pillId) {
    _model.pillId = pillId;
    _units =
        _pillList
            .firstWhere((p) => p.id == pillId)
            .packSpecs
            .map((e) => e.unit)
            .toList();
    _model.unit = _units.last;
  }

  Future<void> _getPills() async {
    final list = await context.read<PillService>().getAllPills();
    setState(() {
      _pillList = list;
      _pills = list.length > 3 ? list.sublist(0, 3) : list;
      if (_model.pillId.isEmpty) {
        _reloadPill(list.first.id);
      }
    });
  }

  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_model.startTime.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请设置计划用药时间'),
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
