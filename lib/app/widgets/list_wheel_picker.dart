import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class WheelOption {
  dynamic value;
  String label;

  WheelOption({required this.value, required this.label});
}

class ListWheelPicker extends StatefulWidget {
  final List<WheelOption>? options;
  final int? min;
  final int? max;
  final dynamic initialValue;
  final Function(dynamic) onChanged;
  final double fontSize;
  final FixedExtentScrollController? controller;

  const ListWheelPicker({
    super.key,
    this.options,
    this.min,
    this.max,
    required this.initialValue,
    required this.onChanged,
    this.fontSize = 36,
    this.controller,
  }) : assert(
         (options != null) ^ (min != null && max != null),
         "必须提供options或min/max组合",
       );

  @override
  State<ListWheelPicker> createState() => _ListWheelPickerState();
}

class _ListWheelPickerState extends State<ListWheelPicker> {
  late FixedExtentScrollController _internalController;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    if (widget.options != null) {
      _selectedIndex = widget.options!.indexWhere(
        (opt) => opt.value == widget.initialValue,
      );
    } else {
      _selectedIndex = widget.initialValue - widget.min!;
    }

    _internalController =
        widget.controller ??
        FixedExtentScrollController(initialItem: _selectedIndex);
  }

  @override
  void didUpdateWidget(covariant ListWheelPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _internalController = widget.controller ?? _internalController;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        final options =
            provider.isDarkMode(context)
                ? {
                  0: Colors.white,
                  1: Colors.white38,
                  2: Colors.white24,
                  3: Colors.white10,
                }
                : {
                  0: Colors.black87,
                  1: Colors.black38,
                  2: Colors.black26,
                  3: Colors.black12,
                };
        return ListWheelScrollView.useDelegate(
          controller: _internalController,
          itemExtent: 40,
          diameterRatio: 1.5,
          physics: const FixedExtentScrollPhysics(),
          onSelectedItemChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
            if (widget.options != null) {
              widget.onChanged(widget.options![index].value);
            } else {
              widget.onChanged(widget.min! + index);
            }
          },
          childDelegate: ListWheelChildBuilderDelegate(
            childCount:
                widget.options?.length ?? (widget.max! - widget.min! + 1),
            builder: (context, index) {
              final value = widget.options?[index].value ?? widget.min! + index;
              final label = widget.options?[index].label ?? value.toString();

              // 计算透明度
              int distance = (_selectedIndex - index).abs();
              if (distance > 3) distance = 3;

              return Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    fontWeight: FontWeight.bold,
                    color: options[distance],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
