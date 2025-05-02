import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/data/models/pill_model.dart';
import '../core/data/providers/pill_provider.dart';
import '../widgets/quantity_input.dart';

class PillFormScreen extends StatefulWidget {
  final PillModel? pill;

  const PillFormScreen({super.key, this.pill});

  @override
  State<PillFormScreen> createState() => _PillFormScreenState();
}

class _PillFormScreenState extends State<PillFormScreen> {
  final _formKey = GlobalKey<FormState>();

  PillModel _model = PillModel(
    name: '',
    initialQty: 0,
    initialUnit: '',
    qty: 0,
    packSpecs: [Spec(qty: 1, unit: '')],
  );

  final int _specDepth = 5;
  final double _specSpace = 24;

  List<String> _units = [];
  String? _selectedUnit;
  String? _selectedPreUnit;

  final _colorOptions = [
    {'label': '默认', 'value': Colors.lightGreen.shade500},
    {'label': '青橙', 'value': Colors.lime.shade500},
    {'label': '蓝绿', 'value': Colors.teal.shade500},
    {'label': '灰蓝', 'value': Colors.blueGrey.shade500},
    {'label': '靛蓝', 'value': Colors.indigo.shade500},
    {'label': '棕色', 'value': Colors.brown.shade500},
    {'label': '粉色', 'value': Colors.pink.shade500},
    {'label': '红色', 'value': Colors.red.shade500},
    {'label': '橙色', 'value': Colors.orange.shade500},
    {'label': '黄色', 'value': Colors.yellow.shade500},
    {'label': '绿色', 'value': Colors.green.shade500},
    {'label': '青色', 'value': Colors.cyan.shade500},
    {'label': '蓝色', 'value': Colors.blue.shade500},
    {'label': '紫色', 'value': Colors.purple.shade500},
  ];
  Color? _selectedColor;

  bool _isUpdate = false;

  void _reloadUnits() {
    _units = _model.packSpecs.map((s) => s.unit).toSet().toList();
  }

  void _addPackSpec() {
    if (_model.packSpecs.length >= _specDepth) return;
    setState(() {
      _model.packSpecs.add(Spec(qty: 1, unit: ''));
    });
  }

  void _removePackSpec(int index) {
    final spec = _model.packSpecs[index];
    setState(() {
      _model.packSpecs.removeAt(index);
      _reloadUnits();
      if (_selectedUnit == spec.unit) _selectedUnit = null;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.pill != null) {
      setState(() {
        _isUpdate = true;
        _model = widget.pill!;
        _reloadUnits();
        _selectedUnit = widget.pill!.initialUnit;
        _selectedPreUnit = widget.pill!.preferredUnit;
        if (widget.pill!.themeValue != null) {
          _selectedColor = Color(widget.pill!.themeValue!);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isUpdate ? '编辑药物' : '新增药物')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    spacing: 16,
                    children: [
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            spacing: 4,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '包装规格',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSecondaryFixed,
                                    ),
                                  ),
                                ],
                              ),
                              ..._model.packSpecs.mapIndexed((index, item) {
                                final isFirst = index == 0;
                                return Row(
                                  children: [
                                    SizedBox(
                                      width:
                                          isFirst
                                              ? 0
                                              : (index - 1) * _specSpace,
                                    ),
                                    if (!isFirst)
                                      Icon(
                                        Icons.subdirectory_arrow_right,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.surfaceDim,
                                      ),
                                    Expanded(
                                      child: TextFormField(
                                        enabled: !isFirst && !_isUpdate,
                                        decoration: InputDecoration(
                                          labelText: '数量',
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return '请输入数量';
                                          }
                                          if (int.tryParse(value) == null) {
                                            return '请输入整数';
                                          }
                                          return null;
                                        },
                                        initialValue: item.qty.toString(),
                                        onChanged:
                                            (value) => setState(() {
                                              item.qty = int.parse(value);
                                            }),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    SizedBox(
                                      width: 100,
                                      child: TextFormField(
                                        enabled: !_isUpdate,
                                        decoration: InputDecoration(
                                          labelText: '单位',
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return '请输入单位';
                                          }
                                          if (_model.packSpecs.indexWhere(
                                                (s) => s.unit == value,
                                              ) !=
                                              index) {
                                            return '单位不可重复';
                                          }
                                          return null;
                                        },
                                        initialValue: item.unit,
                                        onChanged:
                                            (value) => setState(() {
                                              item.unit = value;
                                              // _units.add(value);
                                              _reloadUnits();
                                            }),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        isFirst ? Icons.add : Icons.close,
                                      ),
                                      onPressed:
                                          _isUpdate
                                              ? null
                                              : isFirst
                                              ? () => _addPackSpec()
                                              : () => _removePackSpec(index),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: '药物名称',
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.surfaceContainerLow,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '请输入药物名称';
                          }
                          return null;
                        },
                        initialValue: _model.name,
                        onChanged:
                            (value) => setState(() {
                              _model.name = value;
                            }),
                      ),
                      // NEXT 药物图片选择保存
                      TextFormField(
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: '药物图片',
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.surfaceContainerLow,
                        ),
                        initialValue: _model.imagePath,
                        onChanged:
                            (value) => setState(() {
                              _model.imagePath = value;
                            }),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: QuantityInput(
                              enabled: !_isUpdate,
                              labelText: '当前数量',
                              filled: true,
                              fillColor:
                                  Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerLow,
                              initialInteger: _model.initialQty,
                              initialNumerator: _model.initialNum,
                              initialDenominator: _model.initialDen,
                              onChange:
                                  (v) => setState(() {
                                    _model.initialQty = v.integer;
                                    _model.initialNum = v.numerator;
                                    _model.initialDen = v.denominator;
                                  }),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: '单位',
                                filled: true,
                                fillColor:
                                    Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerLow,
                              ),
                              items:
                                  _units
                                      .map(
                                        (option) => DropdownMenuItem(
                                          value: option,
                                          child: Text(option),
                                        ),
                                      )
                                      .toList(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '请选择当前数量的单位';
                                }
                                return null;
                              },
                              value: _selectedUnit,
                              onChanged:
                                  _isUpdate
                                      ? null
                                      : (value) =>
                                          setState(() => _selectedUnit = value),
                            ),
                          ),
                        ],
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: '首选单位',
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.surfaceContainerLow,
                        ),
                        items:
                            _units
                                .map(
                                  (option) => DropdownMenuItem(
                                    value: option,
                                    child: Text(option),
                                  ),
                                )
                                .toList(),
                        value: _selectedPreUnit,
                        onChanged:
                            (value) => setState(() => _selectedPreUnit = value),
                      ),
                      DropdownButtonFormField<Color>(
                        value: _selectedColor,
                        items:
                            _colorOptions
                                .map(
                                  (item) => DropdownMenuItem(
                                    value: item['value'] as Color,
                                    child: Row(
                                      spacing: 8,
                                      children: [
                                        Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: item['value'] as Color,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        Text(item['label'] as String),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            (value) => setState(() => _selectedColor = value),
                        decoration: InputDecoration(
                          labelText: '主题色',
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.surfaceContainerLow,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => _onSubmit(),
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

  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    _model.initialUnit = _selectedUnit!;
    _model.themeValue = _selectedColor?.toARGB32();
    _model.preferredUnit = _selectedPreUnit;
    final provider = context.read<PillProvider>();
    if (_isUpdate) {
      await provider.updatePill(_model);
    } else {
      await provider.addPill(_model);
    }
    Navigator.of(context).pop();
  }
}
