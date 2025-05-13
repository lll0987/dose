import 'package:flutter/material.dart';

import '../models/plan_model.dart';

class ReminderScreen extends StatefulWidget {
  final PlanModel initialData;

  const ReminderScreen({super.key, required this.initialData});

  @override
  State<ReminderScreen> createState() => _ReminderSettingsState();
}

class _ReminderSettingsState extends State<ReminderScreen> {
  final _reminders = [
    {'label': '不提醒', 'value': 'none'},
    {'label': '计划时间开始时', 'value': 'start'},
    {'label': '提前5分钟', 'value': '5min'},
    {'label': '提前30分钟', 'value': '30min'},
    {'label': '提前1小时', 'value': '1hour'},
    {'label': '提前2小时', 'value': '2hour'},
    {'label': '自定义', 'value': 'custom'},
  ];
  String _selectedReminder = 'none';

  final _units = [
    {'label': '分钟', 'value': 'minute'},
    {'label': '小时', 'value': 'hour'},
  ];
  String _selectedUnit = 'minute';
  String _customValue = '';

  String _selectedMethod = 'notify';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('重复设置')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ..._reminders.map((item) {
                    return ListTile(
                      title: Text(item['label']!),
                      leading: Radio<String>(
                        value: item['value']!,
                        groupValue: _selectedReminder,
                        onChanged:
                            (v) => setState(() => _selectedReminder = v!),
                      ),
                      onTap:
                          () => setState(
                            () => _selectedReminder = item['value']!,
                          ),
                    );
                  }),
                  if (_selectedReminder == 'custom')
                    Row(
                      children: [
                        SizedBox(width: 64),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: '时长'),
                            initialValue: _customValue,
                            onChanged: (v) => setState(() => _customValue = v),
                          ),
                        ),
                        SizedBox(width: 16),
                        SizedBox(
                          width: 128,
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(labelText: '单位'),
                            items:
                                _units
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e['value']!,
                                        child: Text(e['label']!),
                                      ),
                                    )
                                    .toList(),
                            value: _selectedUnit,
                            onChanged:
                                (v) => setState(() => _selectedUnit = v!),
                          ),
                        ),
                        SizedBox(width: 8),
                      ],
                    ),
                  if (_selectedReminder != 'none')
                    Padding(
                      padding: EdgeInsets.only(left: 12, right: 12, top: 16),
                      child: Card(
                        child: ListTile(
                          title: const Text(
                            '提醒方式',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio(
                                value: 'notify',
                                groupValue: _selectedMethod,
                                onChanged: (v) {
                                  setState(() => _selectedMethod = v!);
                                },
                              ),
                              const Text('通知', style: TextStyle(fontSize: 14)),
                              const SizedBox(width: 16),
                              Radio(
                                value: 'clock',
                                groupValue: _selectedMethod,
                                onChanged: (v) {
                                  setState(() => _selectedMethod = v!);
                                },
                              ),
                              const Text('闹钟', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: FilledButton(
              onPressed: () => _onPressed(),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                textStyle: TextStyle(fontSize: 16),
              ),
              child: const Text('确认'),
            ),
          ),
        ],
      ),
    );
  }

  void _onPressed() {
    switch (_selectedReminder) {
      case 'custom':
        widget.initialData.reminderValue = int.parse(_customValue);
        widget.initialData.reminderUnit = _selectedUnit;
        widget.initialData.reminderMethod = _selectedMethod;
        break;
      case 'start':
        widget.initialData.reminderValue = 0;
        widget.initialData.reminderUnit = 'minute';
        widget.initialData.reminderMethod = _selectedMethod;
        break;
      case '5min':
        widget.initialData.reminderValue = 5;
        widget.initialData.reminderUnit = 'minute';
        widget.initialData.reminderMethod = _selectedMethod;
        break;
      case '30min':
        widget.initialData.reminderValue = 30;
        widget.initialData.reminderUnit = 'minute';
        widget.initialData.reminderMethod = _selectedMethod;
        break;
      case '1hour':
        widget.initialData.reminderValue = 1;
        widget.initialData.reminderUnit = 'hour';
        widget.initialData.reminderMethod = _selectedMethod;
        break;
      case '2hour':
        widget.initialData.reminderValue = 2;
        widget.initialData.reminderUnit = 'hour';
        widget.initialData.reminderMethod = _selectedMethod;
        break;
      case 'none':
      default:
        widget.initialData.reminderValue = null;
        widget.initialData.reminderUnit = null;
        widget.initialData.reminderMethod = null;
        break;
    }
    Navigator.of(context).pop(widget.initialData);
  }
}
