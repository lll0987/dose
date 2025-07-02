import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class ColorPicker extends StatefulWidget {
  final String labelText;
  final bool? filled;
  final Color? fillColor;
  final Color? initialValue;
  final void Function(Color?) onChanged;

  const ColorPicker({
    super.key,
    required this.labelText,
    this.filled,
    this.fillColor,
    this.initialValue,
    required this.onChanged,
  });

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  Color? _selectedColor;
  final TextEditingController _displayController = TextEditingController();

  bool isInit = false;

  @override
  Widget build(BuildContext context) {
    if (widget.initialValue != null && !isInit) {
      _selectedColor = widget.initialValue;
      final options = context.read<ThemeProvider>().getColorOptions(context);
      final item = options.entries.firstWhereOrNull(
        (option) => option.value == _selectedColor,
      );
      if (item != null) {
        _displayController.text = item.key;
      }
      isInit = true;
    }

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return GestureDetector(
          onTap: _showBottomColorModal,
          child: AbsorbPointer(
            child: TextFormField(
              controller: _displayController,
              decoration: InputDecoration(
                prefix: Container(
                  width: 10,
                  height: 10,
                  margin: EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: _selectedColor,
                    shape: BoxShape.circle,
                  ),
                ),
                labelText: widget.labelText,
                filled: widget.filled,
                fillColor: widget.fillColor,
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
            ),
          ),
        );
      },
    );
  }

  _showBottomColorModal() async {
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
                      themeProvider.getColorOptions(context).entries.map((
                        item,
                      ) {
                        final value = item.value;
                        final label = item.key;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedColor = value;
                            });
                            _displayController.text = label;
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
                                    color: value,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Text(label),
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

    widget.onChanged(_selectedColor);
  }
}
