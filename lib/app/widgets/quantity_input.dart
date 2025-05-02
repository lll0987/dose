import 'package:flutter/material.dart';

class QuantityInput extends StatefulWidget {
  final bool enabled;
  final String labelText;
  final bool? filled;
  final Color? fillColor;
  final int initialInteger;
  final int? initialNumerator;
  final int? initialDenominator;
  final Function(QuantityResult) onChange;

  const QuantityInput({
    super.key,
    this.enabled = true,
    required this.labelText,
    this.filled,
    this.fillColor,
    required this.initialInteger,
    this.initialNumerator,
    this.initialDenominator,
    required this.onChange,
  });

  @override
  State<QuantityInput> createState() => _QuantityInputState();
}

class _QuantityInputState extends State<QuantityInput> {
  final TextEditingController _displayController = TextEditingController();
  late int _integer;
  late int? _numerator;
  late int? _denominator;

  @override
  void initState() {
    super.initState();
    _integer = widget.initialInteger;
    _numerator = widget.initialNumerator;
    _denominator = widget.initialDenominator;
    _updateDisplay();
  }

  void _updateDisplay() {
    _displayController.text = _getDisplayText();
  }

  void _showEditDialog() async {
    final result = await showDialog<QuantityResult>(
      context: context,
      builder:
          (context) => QuantityInputDialog(
            initialInteger: _integer,
            initialNumerator: _numerator,
            initialDenominator: _denominator,
          ),
    );

    if (result != null) {
      setState(() {
        _integer = result.integer;
        _numerator = result.numerator;
        _denominator = result.denominator;
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
            labelText: widget.labelText,
            filled: widget.filled,
            fillColor: widget.fillColor,
          ),
        ),
      ),
    );
  }

  String _getDisplayText() {
    if (_denominator == null || _numerator == null) {
      return '$_integer';
    }
    return '$_integer + $_numerator/$_denominator';
  }

  @override
  void dispose() {
    _displayController.dispose();
    super.dispose();
  }
}

class QuantityInputDialog extends StatefulWidget {
  final int initialInteger;
  final int? initialNumerator;
  final int? initialDenominator;

  const QuantityInputDialog({
    super.key,
    required this.initialInteger,
    required this.initialNumerator,
    required this.initialDenominator,
  });

  @override
  State<QuantityInputDialog> createState() => _QuantityInputDialogState();
}

class _QuantityInputDialogState extends State<QuantityInputDialog> {
  late int _integer;
  late int? _numerator;
  late int? _denominator;

  String _selectedFraction = 'none';
  final List<PresetOption> _presetOptions = [
    PresetOption(key: 'none', label: '不分割', fraction: null),
    PresetOption(key: 'half', label: '1/2', fraction: Fraction(1, 2)),
    PresetOption(key: 'third', label: '1/3', fraction: Fraction(1, 3)),
    PresetOption(key: 'quarter', label: '1/4', fraction: Fraction(1, 4)),
    PresetOption(key: 'twoThirds', label: '2/3', fraction: Fraction(2, 3)),
    PresetOption(key: 'threeQuarters', label: '3/4', fraction: Fraction(3, 4)),
    PresetOption(key: 'custom', label: '自定义', fraction: null),
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _integerController; // 新增控制器

  @override
  void initState() {
    super.initState();
    _integer = widget.initialInteger;
    _numerator = widget.initialNumerator;
    _denominator = widget.initialDenominator;
    _integerController = TextEditingController(
      text: _integer.toString(),
    ); // 初始化控制器

    // 初始化选中状态
    if (_denominator == 0) {
      _selectedFraction = _presetOptions.first.key;
      return;
    }
    final currentFraction =
        _numerator != null && _denominator != null
            ? Fraction(_numerator!, _denominator!)
            : null;
    final match = _presetOptions.firstWhere(
      (opt) => opt.fraction == currentFraction,
      orElse: () => _presetOptions.last,
    );
    _selectedFraction = match.key;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('修改数量'),
      content: Form(
        key: _formKey,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                            return '数量不可为空';
                          }
                          if (int.tryParse(value) == null) {
                            return '请输入整数';
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
                      _presetOptions.map((option) {
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
                                _numerator = option.key == 'custom' ? 1 : null;
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
                            labelText: '分子',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _numerator = int.tryParse(value);
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '分子不可为空';
                            }
                            if (int.tryParse(value) == null ||
                                int.parse(value) <= 0) {
                              return '请输入正整数';
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
                            labelText: '分母',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _denominator = int.tryParse(value);
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '分母不可为空';
                            }
                            if (int.tryParse(value) == null ||
                                int.parse(value) <= 0) {
                              return '请输入正整数';
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
      actions: [
        TextButton(onPressed: Navigator.of(context).pop, child: Text('取消')),
        TextButton(
          child: Text('保存'),
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              if (_selectedFraction != 'none' && _denominator! <= 0) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('分母不能为0')));
                return;
              }
              Navigator.of(context).pop(
                QuantityResult(
                  integer: _integer,
                  numerator: _selectedFraction == 'none' ? null : _numerator,
                  denominator:
                      _selectedFraction == 'none' ? null : _denominator,
                ),
              );
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

class Fraction {
  final int numerator;
  final int denominator;

  Fraction(this.numerator, this.denominator);

  @override
  bool operator ==(Object other) {
    if (other is Fraction) {
      return numerator == other.numerator && denominator == other.denominator;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(numerator, denominator);
}

class QuantityResult {
  final int integer;
  final int? numerator;
  final int? denominator;

  QuantityResult({required this.integer, this.numerator, this.denominator});
}

// 新建PresetOption类：
class PresetOption {
  final String key;
  final String label;
  final Fraction? fraction;

  PresetOption({required this.key, required this.label, this.fraction});
}
