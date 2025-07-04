import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../models/pill_model.dart';
import '../models/quantity_model.dart';
import '../models/transaction_model.dart';
import '../providers/theme_provider.dart';
import '../providers/transaction_provider.dart';
import '../service/loading_service.dart';
import '../utils/datetime.dart';
import '../widgets/pill_card.dart';
import '../widgets/quantity_input.dart';
import '../widgets/required_label.dart';

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

  final List<bool> _unitDisabled = [];

  void _addQuantity() {
    _model.quantities.add(
      QuantityModel(
        qty: 1,
        unit: widget.initialData.getUnit(),
        fraction: FractionModel(null, null),
      ),
    );
    _unitDisabled.add(false);
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startTime = TimeOfDay.fromDateTime(now);
    _model = TransactionModel(
      pillId: widget.initialData.id!,
      quantities: [],
      startTime: now,
    );
    _addQuantity();
    _units = widget.initialData.packSpecs.map((e) => e.unit).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.updateQuantity)),
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
                              decoration: InputDecoration(
                                label: RequiredLabel(
                                  text:
                                      AppLocalizations.of(
                                        context,
                                      )!.transactionForm_date,
                                ),
                              ),
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
                              decoration: InputDecoration(
                                label: RequiredLabel(
                                  text:
                                      AppLocalizations.of(
                                        context,
                                      )!.transactionForm_time,
                                ),
                              ),
                              child: Text(getFormatTime(_startTime)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // 备注
                    TextFormField(
                      decoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(
                              context,
                            )!.transactionForm_remark,
                      ),
                      initialValue: _model.remark,
                      onChanged:
                          (value) => setState(() => _model.remark = value),
                    ),
                    // 符号
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.transactionForm_symbol,
                        ),
                        SegmentedButton(
                          segments: [
                            ButtonSegment(
                              label: Text(
                                AppLocalizations.of(context)!.symbol_add,
                              ),
                              value: false,
                            ),
                            ButtonSegment(
                              label: Text(
                                AppLocalizations.of(context)!.symbol_substract,
                              ),
                              value: true,
                            ),
                          ],
                          selected: _selectedSign,
                          onSelectionChanged:
                              (v) => setState(() => _selectedSign = v),
                        ),
                      ],
                    ),
                    // 数量
                    Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_unitDisabled.any((e) => e))
                          Text(
                            AppLocalizations.of(context)!.quantityUnitWarning,
                            style: TextStyle(
                              color: context.read<ThemeProvider>().hintColor,
                            ),
                          ),
                        ..._model.quantities.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;
                          return Row(
                            children: [
                              Expanded(
                                child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 16,
                                    ),
                                    child: Row(
                                      spacing: 16,
                                      children: [
                                        Expanded(
                                          child: QuantityInput(
                                            labelText:
                                                AppLocalizations.of(
                                                  context,
                                                )!.transactionForm_qty,
                                            initialValue: item,
                                            onChange: (value) {
                                              setState(() {
                                                item.qty = value.qty;
                                                item.fraction = value.fraction;
                                                _unitDisabled[index] =
                                                    value.fraction.isNotEmpty;
                                                if (_unitDisabled[index]) {
                                                  item.unit = _units.last;
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: DropdownButtonFormField<
                                            String
                                          >(
                                            decoration: InputDecoration(
                                              label: RequiredLabel(
                                                text:
                                                    AppLocalizations.of(
                                                      context,
                                                    )!.transactionForm_unit,
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return AppLocalizations.of(
                                                  context,
                                                )!.validToken_transactionUnit_required;
                                              }
                                              return null;
                                            },
                                            items:
                                                _units
                                                    .map(
                                                      (option) =>
                                                          DropdownMenuItem(
                                                            value: option,
                                                            child: Text(option),
                                                          ),
                                                    )
                                                    .toList(),
                                            value: item.unit,
                                            onChanged:
                                                _unitDisabled[index]
                                                    ? null
                                                    : (v) => setState(
                                                      () => item.unit = v!,
                                                    ),
                                          ),
                                        ),
                                      ],
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
                                            _model.quantities.removeAt(index);
                                            _unitDisabled.removeAt(index);
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
                      onPressed: () => setState(() => _addQuantity()),
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
            const SizedBox(height: 16), // 添加底部间距
            FilledButton(
              onPressed: () => _onPressed(),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                textStyle: TextStyle(fontSize: 16),
              ),
              child: Text(AppLocalizations.of(context)!.save),
            ),
          ],
        ),
      ),
    );
  }

  void _onPressed() async {
    loadingService.show();
    _model.isCustom = true;
    _model.isNegative = _selectedSign.first;
    await context.read<TransactionProvider>().addTransaction(_model);
    loadingService.hide();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.success_save),
        duration: Duration(seconds: 1),
      ),
    );
    Navigator.of(context).pop(widget.initialData);
  }
}
