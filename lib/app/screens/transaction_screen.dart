import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../core/data/models/pill_model.dart';
import '../core/data/models/transaction_model.dart';
import '../core/data/providers/transaction_provider.dart';
import '../widgets/pill_card.dart';
import '../widgets/quantity_input.dart';

class TransactionScreen extends StatefulWidget {
  final PillModel initialData;

  const TransactionScreen({super.key, required this.initialData});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late TransactionModel _model;
  late TimeOfDay _startTime;
  List<String> _units = [];
  Set<bool> _selectedSign = {false};

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startTime = TimeOfDay.fromDateTime(now);
    _model = TransactionModel(
      pillId: widget.initialData.id,
      quantities: [],
      timestamp: now,
      startTime: now,
    );
    _model.quantities.add(Quantity(qty: 1, unit: widget.initialData.getUnit()));
    _units = widget.initialData.packSpecs.map((e) => e.unit).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('调整药物数量')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    PillCard(pill: widget.initialData),
                    // 时间
                    Row(
                      spacing: 16,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final newDate = await showDatePicker(
                                context: context,
                                initialDate: _model.startTime,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (newDate == null) return;
                              setState(() {
                                _model.startTime = DateTime(
                                  newDate.year,
                                  newDate.month,
                                  newDate.day,
                                  _startTime.hour,
                                  _startTime.minute,
                                );
                              });
                            },
                            child: InputDecorator(
                              decoration: InputDecoration(labelText: '日期'),
                              child: Text(getFormatDate(_model.startTime)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final newTime = await showTimePicker(
                                context: context,
                                initialTime: _startTime,
                                initialEntryMode: TimePickerEntryMode.input,
                              );
                              if (newTime == null) return;
                              setState(() {
                                _startTime = newTime;
                                _model.startTime = DateTime(
                                  _model.startTime.year,
                                  _model.startTime.month,
                                  _model.startTime.day,
                                  newTime.hour,
                                  newTime.minute,
                                );
                              });
                            },
                            child: InputDecorator(
                              decoration: InputDecoration(labelText: '时间'),
                              child: Text(getFormatTime(_startTime)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // 备注
                    TextFormField(
                      decoration: InputDecoration(labelText: '备注'),
                      initialValue: _model.remark,
                      onChanged:
                          (value) => setState(() => _model.remark = value),
                    ),
                    // 符号
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('数量变更方式'),
                        SegmentedButton(
                          segments: [
                            ButtonSegment(label: Text('增加'), value: false),
                            ButtonSegment(label: Text('减少'), value: true),
                          ],
                          selected: _selectedSign,
                          onSelectionChanged:
                              (v) => setState(() => _selectedSign = v),
                        ),
                      ],
                    ),
                    // 数量
                    Card(
                      elevation: 1,
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          spacing: 16,
                          children: [
                            ..._model.quantities.map(
                              (item) => Row(
                                spacing: 16,
                                children: [
                                  Expanded(
                                    child: QuantityInput(
                                      labelText: '数量',
                                      initialInteger: item.qty,
                                      initialNumerator: item.numerator,
                                      initialDenominator: item.denominator,
                                      onChange: (value) {
                                        setState(() {
                                          item.qty = value.integer;
                                          item.numerator = value.numerator;
                                          item.denominator = value.denominator;
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                        labelText: '单位',
                                      ),
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
                                      value: item.unit,
                                      onChanged:
                                          (v) => setState(() => item.unit = v!),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed:
                                  () => setState(
                                    () => _model.quantities.add(
                                      Quantity(
                                        qty: 1,
                                        unit: widget.initialData.getUnit(),
                                      ),
                                    ),
                                  ),
                              label: Text('增加一行'),
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
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }

  void _onPressed() async {
    _model.isNegative = _selectedSign.first;
    await context.read<TransactionProvider>().addTransaction(_model);
    Navigator.of(context).pop(widget.initialData);
  }
}
