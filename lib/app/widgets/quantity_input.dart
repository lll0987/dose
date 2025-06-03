import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/quantity_model.dart';
import 'required_label.dart';

class QuantityInput extends StatefulWidget {
  final bool enabled;
  final String labelText;
  final bool? filled;
  final Color? fillColor;
  final QuantityModel? initialValue;
  final Function(QuantityModel) onChange;

  const QuantityInput({
    super.key,
    this.enabled = true,
    required this.labelText,
    this.filled,
    this.fillColor,
    this.initialValue,
    required this.onChange,
  });

  @override
  State<QuantityInput> createState() => _QuantityInputState();
}

class _QuantityInputState extends State<QuantityInput> {
  final TextEditingController _displayController = TextEditingController();
  QuantityModel _value = QuantityModel(
    qty: 0,
    fraction: FractionModel(null, null),
  );

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _value = widget.initialValue!;
    }
    _updateDisplay();
  }

  void _updateDisplay() {
    _displayController.text = _value.displayText;
  }

  void _showEditDialog() async {
    final result = await showDialog<QuantityModel>(
      context: context,
      builder: (context) => QuantityInputDialog(initialValue: _value),
    );

    if (result != null) {
      setState(() {
        _value = result;
        _updateDisplay();
        widget.onChange(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showEditDialog,
      child: AbsorbPointer(
        child: TextFormField(
          enabled: widget.enabled,
          controller: _displayController,
          decoration: InputDecoration(
            label: RequiredLabel(text: widget.labelText),
            filled: widget.filled,
            fillColor: widget.fillColor,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _displayController.dispose();
    super.dispose();
  }
}

class QuantityInputDialog extends StatefulWidget {
  final QuantityModel initialValue;

  const QuantityInputDialog({super.key, required this.initialValue});

  @override
  State<QuantityInputDialog> createState() => _QuantityInputDialogState();
}

class _QuantityInputDialogState extends State<QuantityInputDialog> {
  late int _integer;
  late int? _numerator;
  late int? _denominator;

  String _selectedFraction = 'none';

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _integerController; // 新增控制器

  QuantityModel get _quantity => QuantityModel(
    qty: _integer,
    fraction: FractionModel(
      _selectedFraction == 'none' ? null : _numerator,
      _selectedFraction == 'none' ? null : _denominator,
    ),
  );

  @override
  void initState() {
    super.initState();
    _integer = widget.initialValue.qty;
    _numerator = widget.initialValue.fraction.numerator;
    _denominator = widget.initialValue.fraction.denominator;
    _integerController = TextEditingController(
      text: _integer.toString(),
    ); // 初始化控制器
  }

  @override
  Widget build(BuildContext context) {
    final presetOptions = getOptions(context);
    // 初始化选中状态
    if (_denominator == 0) {
      _selectedFraction = presetOptions.first.key;
    } else {
      final currentFraction =
          _numerator != null && _denominator != null
              ? FractionModel(_numerator!, _denominator!)
              : null;
      final match = presetOptions.firstWhere(
        (opt) => opt.fraction == currentFraction,
        orElse: () => presetOptions.last,
      );
      _selectedFraction = match.key;
    }

    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.quantityAlertTitle),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${AppLocalizations.of(context)!.quantity}: ${_quantity.displayText}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // 整数输入行
                  Row(
                    spacing: 8,
                    children: [
                      IconButton.filled(
                        style: FilledButton.styleFrom(
                          minimumSize: Size(36, 36),
                          iconSize: 24,
                        ),
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (_integer > 0) _integer--;
                            _integerController.text =
                                _integer.toString(); // 同步控制器
                          });
                        },
                      ),
                      Expanded(
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: _integerController, // 使用控制器
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _integer = int.tryParse(value) ?? 0;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(
                                context,
                              )!.validToken_qty_required;
                            }
                            if (int.tryParse(value) == null) {
                              return AppLocalizations.of(
                                context,
                              )!.validToken_qty_integer;
                            }
                            return null;
                          },
                        ),
                      ),
                      IconButton.filled(
                        style: FilledButton.styleFrom(
                          minimumSize: Size(36, 36),
                          iconSize: 24,
                        ),
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _integer++;
                            _integerController.text =
                                _integer.toString(); // 同步控制器
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // 分数选项行
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8,
                    children:
                        presetOptions.map((option) {
                          return ChoiceChip(
                            label: Text(option.label),
                            selected: _selectedFraction == option.key,
                            onSelected: (selected) {
                              setState(() {
                                _selectedFraction = option.key;
                                if (option.fraction != null) {
                                  _numerator = option.fraction!.numerator;
                                  _denominator = option.fraction!.denominator;
                                } else {
                                  _numerator =
                                      option.key == 'custom' ? 1 : null;
                                  _denominator = null;
                                }
                              });
                            },
                          );
                        }).toList(),
                  ),
                  if (_selectedFraction == 'custom') ...[
                    SizedBox(height: 16),
                    Row(
                      spacing: 8.0,
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: _numerator?.toString(),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              label: RequiredLabel(
                                text:
                                    AppLocalizations.of(
                                      context,
                                    )!.numeratorLabel,
                              ),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _numerator = int.tryParse(value);
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(
                                  context,
                                )!.validToken_numerator_required;
                              }
                              if (int.tryParse(value) == null ||
                                  int.parse(value) <= 0) {
                                return AppLocalizations.of(
                                  context,
                                )!.validToken_qty_integer;
                              }
                              return null;
                            },
                          ),
                        ),
                        Text('/', style: TextStyle(fontSize: 24)),
                        Expanded(
                          child: TextFormField(
                            initialValue: _denominator?.toString(),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              label: RequiredLabel(
                                text:
                                    AppLocalizations.of(
                                      context,
                                    )!.denominatorLabel,
                              ),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _denominator = int.tryParse(value);
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(
                                  context,
                                )!.validToken_denominator_required;
                              }
                              if (int.tryParse(value) == null ||
                                  int.parse(value) <= 0) {
                                return AppLocalizations.of(
                                  context,
                                )!.validToken_qty_integer;
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          child: Text(AppLocalizations.of(context)!.submit),
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              if (_selectedFraction != 'none' && _denominator! <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(
                        context,
                      )!.validToken_denominator_notZero,
                    ),
                  ),
                );
                return;
              }
              Navigator.of(context).pop(_quantity);
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _integerController.dispose(); // 释放控制器
    super.dispose();
  }
}

// 新建PresetOption类：
class PresetOption {
  final String key;
  final String label;
  final FractionModel? fraction;

  PresetOption({required this.key, required this.label, this.fraction});
}

List<PresetOption> getOptions(BuildContext context) {
  return [
    PresetOption(
      key: 'none',
      label: AppLocalizations.of(context)!.splitNone,
      fraction: null,
    ),
    PresetOption(key: 'half', label: '1/2', fraction: FractionModel(1, 2)),
    PresetOption(key: 'third', label: '1/3', fraction: FractionModel(1, 3)),
    PresetOption(key: 'quarter', label: '1/4', fraction: FractionModel(1, 4)),
    PresetOption(key: 'twoThirds', label: '2/3', fraction: FractionModel(2, 3)),
    PresetOption(
      key: 'threeQuarters',
      label: '3/4',
      fraction: FractionModel(3, 4),
    ),
    PresetOption(
      key: 'custom',
      label: AppLocalizations.of(context)!.custom,
      fraction: null,
    ),
  ];
}
