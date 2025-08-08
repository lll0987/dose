import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../models/pill_model.dart';
import '../models/quantity_model.dart';
import '../providers/pill_provider.dart';
import '../providers/plan_provider.dart';
import '../providers/theme_provider.dart';
import '../service/loading_service.dart';
import '../widgets/color_picker.dart';
import '../widgets/pill_image.dart';
import '../widgets/quantity_input.dart';
import '../widgets/required_label.dart';

class PillFormScreen extends StatefulWidget {
  final PillModel? pill;
  final bool hasTransaction;

  const PillFormScreen({super.key, this.pill, required this.hasTransaction});

  @override
  State<PillFormScreen> createState() => _PillFormScreenState();
}

class _PillFormScreenState extends State<PillFormScreen> {
  final _formKey = GlobalKey<FormState>();

  PillModel _model = PillModel(
    name: '',
    initialQuantity: QuantityModel(
      qty: 0,
      unit: '',
      fraction: FractionModel(null, null),
    ),
    quantity: QuantityModel(qty: 0, fraction: FractionModel(null, null)),
    packSpecs: [SpecModel(qty: 1, unit: '')],
  );

  // 包装规格5层
  final int _specDepth = 5;
  // 包装规格缩进宽度24
  final double _specSpace = 24;

  List<String> _units = [];
  String? _selectedUnit;
  bool _unitDisabled = false;
  String? _unitHintText;
  String? _selectedPreUnit;

  Color? _selectedColor;

  bool _isUpdate = false;

  void _reloadUnits() {
    _units = _model.packSpecs.map((s) => s.unit).toSet().toList();
  }

  void _addPackSpec(BuildContext context) {
    if (_model.packSpecs.length >= _specDepth) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.specDepthMax(_specDepth)),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }
    setState(() {
      _model.packSpecs.add(SpecModel(qty: 1, unit: ''));
    });
  }

  void _removePackSpec(BuildContext context, int index) {
    final spec = _model.packSpecs[index];
    setState(() {
      _model.packSpecs.removeAt(index);
      _reloadUnits();
      _setUnit(context);
      if (_selectedUnit == spec.unit) _selectedUnit = null;
    });
  }

  void _setUnit(BuildContext context) {
    if (!_unitDisabled) {
      _unitHintText = null;
      return;
    }
    _selectedUnit = _units.isEmpty ? null : _units.last;
    _unitHintText = AppLocalizations.of(context)!.quantityUnitWarning;
  }

  @override
  void initState() {
    super.initState();
    if (widget.pill != null) {
      _isUpdate = true;
      _model = widget.pill!.copyWith();
      _reloadUnits();
      _selectedUnit = widget.pill!.initialQuantity.unit;
      _selectedPreUnit = widget.pill!.preferredUnit;
      if (widget.pill!.themeValue != null) {
        _selectedColor = Color(widget.pill!.themeValue!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isUpdate
              ? AppLocalizations.of(context)!.updatePill
              : AppLocalizations.of(context)!.addPill,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Consumer<PlanProvider>(
                  builder: (context, provider, child) {
                    final plans =
                        _model.id == null
                            ? null
                            : provider.groupedPlans[_model.id];
                    final hasPlan = plans != null && plans.isNotEmpty;
                    final isUse = !hasPlan && !widget.hasTransaction;
                    return Form(
                      key: _formKey,
                      child: Column(
                        spacing: 16,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              label: RequiredLabel(
                                text:
                                    AppLocalizations.of(context)!.pillForm_name,
                              ),
                              filled: true,
                              fillColor:
                                  Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerLow,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(
                                  context,
                                )!.validToken_pillName_required;
                              }
                              return null;
                            },
                            initialValue: _model.name,
                            onChanged:
                                (value) => setState(() {
                                  _model.name = value;
                                }),
                          ),
                          Card(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                spacing: 4,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.pillForm_packSpecs,
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.labelLarge,
                                      ),
                                    ],
                                  ),
                                  if (_model.packSpecs.length > 1)
                                    _buildPackSpecsResult(context),
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
                                            enabled:
                                                !isFirst &&
                                                (!_isUpdate || isUse),
                                            decoration: InputDecoration(
                                              label: RequiredLabel(
                                                text:
                                                    AppLocalizations.of(
                                                      context,
                                                    )!.pillForm_qty,
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
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
                                            initialValue: item.qty.toString(),
                                            onChanged: (value) {
                                              if (value.isEmpty) return;
                                              setState(() {
                                                item.qty = int.parse(value);
                                              });
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        SizedBox(
                                          width: 100,
                                          child: TextFormField(
                                            enabled: !_isUpdate || isUse,
                                            decoration: InputDecoration(
                                              label: RequiredLabel(
                                                text:
                                                    AppLocalizations.of(
                                                      context,
                                                    )!.pillForm_unit,
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return AppLocalizations.of(
                                                  context,
                                                )!.validToken_pillUnit_required;
                                              }
                                              if (_model.packSpecs.indexWhere(
                                                    (s) => s.unit == value,
                                                  ) !=
                                                  index) {
                                                return AppLocalizations.of(
                                                  context,
                                                )!.validToken_pillUnit_noRepeat;
                                              }
                                              return null;
                                            },
                                            initialValue: item.unit,
                                            onChanged:
                                                (value) => setState(() {
                                                  item.unit = value;
                                                  // _units.add(value);
                                                  _reloadUnits();
                                                  _setUnit(context);
                                                }),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            isFirst ? Icons.add : Icons.close,
                                          ),
                                          onPressed:
                                              (_isUpdate && !isUse)
                                                  ? null
                                                  : isFirst
                                                  ? () => _addPackSpec(context)
                                                  : () => _removePackSpec(
                                                    context,
                                                    index,
                                                  ),
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_unitHintText != null)
                                Text(
                                  _unitHintText!,
                                  style: TextStyle(
                                    color:
                                        context.read<ThemeProvider>().hintColor,
                                  ),
                                ),
                              Row(
                                children: [
                                  Expanded(
                                    child: QuantityInput(
                                      enabled: !_isUpdate || isUse,
                                      labelText:
                                          AppLocalizations.of(
                                            context,
                                          )!.pillForm_initQty,
                                      filled: true,
                                      fillColor:
                                          Theme.of(
                                            context,
                                          ).colorScheme.surfaceContainerLow,
                                      initialValue: _model.initialQuantity,
                                      onChange:
                                          (v) => setState(() {
                                            _model.initialQuantity = v;
                                            _unitDisabled =
                                                v.fraction.numerator != null;
                                            _setUnit(context);
                                          }),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        label: RequiredLabel(
                                          text:
                                              AppLocalizations.of(
                                                context,
                                              )!.pillForm_initUnit,
                                        ),
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
                                          return AppLocalizations.of(
                                            context,
                                          )!.validToken_pillInitUnit_required;
                                        }
                                        return null;
                                      },
                                      value: _selectedUnit,
                                      onChanged:
                                          (_isUpdate && !isUse) || _unitDisabled
                                              ? null
                                              : (value) => setState(
                                                () => _selectedUnit = value,
                                              ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText:
                                  AppLocalizations.of(
                                    context,
                                  )!.pillForm_preUnit,
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
                            value: _selectedPreUnit,
                            onChanged:
                                (value) =>
                                    setState(() => _selectedPreUnit = value),
                          ),
                          Card(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: ListTile(
                                title: Text(
                                  AppLocalizations.of(context)!.pillForm_image,
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (_model.imagePath == null ||
                                        _model.imagePath!.isEmpty)
                                      IconButton(
                                        onPressed:
                                            () => _showBottomModal(context),
                                        icon: Icon(Icons.add_a_photo_outlined),
                                      ),
                                    if (_model.imagePath != null &&
                                        _model.imagePath!.isNotEmpty) ...[
                                      InkWell(
                                        child: PillImage(
                                          pill: _model,
                                          size: 64,
                                        ),
                                        onTap: () => _showBottomModal(context),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          await File(
                                            _model.imagePath!,
                                          ).delete();
                                          setState(() {
                                            _model.imagePath = '';
                                          });
                                        },
                                        icon: Icon(Icons.cancel_outlined),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                          ColorPicker(
                            filled: true,
                            fillColor:
                                Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerLow,
                            labelText:
                                AppLocalizations.of(context)!.pillForm_color,
                            initialValue: _selectedColor,
                            onChanged:
                                (v) => setState(() {
                                  _selectedColor = v;
                                }),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => _onSubmit(context),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                textStyle: TextStyle(fontSize: 16),
              ),
              child: Text(AppLocalizations.of(context)!.pillForm_submit),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackSpecsResult(BuildContext context) {
    if (_model.packSpecs.length < 2) return SizedBox.shrink();
    String text = '';
    for (var i = 0; i < _model.packSpecs.length; i++) {
      final spec = _model.packSpecs[i];
      if (i == 0) {
        text = '${spec.qty}${spec.unit} = ';
      } else if (i == 1) {
        text += '${spec.qty}${spec.unit}';
      } else {
        text += ' × ${spec.qty}${spec.unit}';
      }
    }
    if (_model.packSpecs.length > 2) {
      text +=
          ' = ${_model.getTotalQtyMultiple(-1)}${_model.packSpecs.last.unit}';
    }

    final color = Theme.of(context).colorScheme.primary;
    return Row(
      spacing: 2,
      children: [
        // Icon(Icons.info_outlined, size: 14, color: color),
        Text(text, style: TextStyle(color: color)),
      ],
    );
  }

  _showBottomModal(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(top: 16, bottom: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text(AppLocalizations.of(context)!.pillForm_camera),
                onTap: () {
                  Navigator.of(context).pop(true);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text(
                  AppLocalizations.of(context)!.pillForm_photoLibrary,
                ),
                onTap: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          ),
        );
      },
    );
    if (result == null) return;
    final XFile? pickedFile = await _pickImage(result);
    if (pickedFile == null) return;

    final File originalFile = File(pickedFile.path);
    // final File? croppedFile = await _cropImage(
    //   originalFile,
    // );
    // if (croppedFile == null) return;

    final String savedPath = await _saveImageToAppDocDir(originalFile);

    setState(() {
      _model.imagePath = savedPath;
    });
  }

  Future<XFile?> _pickImage(bool isCamera) async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
    );
  }

  Future<String> _saveImageToAppDocDir(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = "image_${DateTime.now().millisecondsSinceEpoch}.jpg";
    final newPath = join(directory.path, name);
    final newImage = await imageFile.copy(newPath);
    return newImage.path;
  }

  void _onSubmit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    loadingService.show();
    _model.initialQuantity.unit = _selectedUnit!;
    _model.themeValue = _selectedColor?.toARGB32();
    _model.preferredUnit = _selectedPreUnit;
    final provider = context.read<PillProvider>();
    if (_isUpdate) {
      await provider.updatePill(_model);
      loadingService.hide();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.success_update),
          duration: Duration(seconds: 1),
        ),
      );
      Navigator.of(context).pop();
    } else {
      final result = await provider.addPill(_model);
      loadingService.hide();
      if (result.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.success_add),
            duration: Duration(seconds: 1),
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result.error!)));
      }
    }
  }
}
