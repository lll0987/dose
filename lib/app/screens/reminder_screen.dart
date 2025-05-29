import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/plan_model.dart';

class ReminderScreen extends StatefulWidget {
  final PlanModel initialData;

  const ReminderScreen({super.key, required this.initialData});

  @override
  State<ReminderScreen> createState() => _ReminderSettingsState();
}

class _ReminderSettingsState extends State<ReminderScreen> {
  String _selectedReminder = 'none';

  String _selectedUnit = 'minute';
  String _customValue = '';

  String _selectedMethod = 'notify';

  @override
  Widget build(BuildContext context) {
    final reminderOptions = {
      'none': AppLocalizations.of(context)!.reminderOption_none,
      'start': AppLocalizations.of(context)!.reminderOption_start,
      '5min': AppLocalizations.of(context)!.reminderOption_5min,
      '30min': AppLocalizations.of(context)!.reminderOption_30min,
      '1hour': AppLocalizations.of(context)!.reminderOption_1hour,
      '2hour': AppLocalizations.of(context)!.reminderOption_2hour,
      'custom': AppLocalizations.of(context)!.reminderOption_custom,
    };

    final unitOptions = {
      'minute': AppLocalizations.of(context)!.minute,
      'hour': AppLocalizations.of(context)!.hour,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.reminderSetting),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...reminderOptions.entries.map((item) {
                    final label = item.value;
                    final value = item.key;
                    return ListTile(
                      title: Text(label),
                      leading: Radio<String>(
                        value: value,
                        groupValue: _selectedReminder,
                        onChanged:
                            (v) => setState(() => _selectedReminder = v!),
                      ),
                      onTap: () => setState(() => _selectedReminder = value),
                    );
                  }),
                  if (_selectedReminder == 'custom')
                    Row(
                      children: [
                        SizedBox(width: 64),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText:
                                  AppLocalizations.of(
                                    context,
                                  )!.reminderForm_duration,
                            ),
                            initialValue: _customValue,
                            onChanged: (v) => setState(() => _customValue = v),
                          ),
                        ),
                        SizedBox(width: 16),
                        SizedBox(
                          width: 128,
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText:
                                  AppLocalizations.of(
                                    context,
                                  )!.reminderForm_unit,
                            ),
                            items:
                                unitOptions.entries
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e.key,
                                        child: Text(e.value),
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
                          title: Text(
                            AppLocalizations.of(
                              context,
                            )!.planForm_reminderMethod,
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
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.reminderMethod_notify,
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(width: 16),
                              Radio(
                                value: 'clock',
                                groupValue: _selectedMethod,
                                onChanged: (v) {
                                  setState(() => _selectedMethod = v!);
                                },
                              ),
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.reminderMethod_clock,
                                style: TextStyle(fontSize: 14),
                              ),
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
              child: Text(AppLocalizations.of(context)!.confirm),
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
