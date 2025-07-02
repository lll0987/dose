import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'ignore_screen.dart';
import 'month_screen.dart';
import 'year_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Set<String> _selected = {'month'};

  bool get _isYear => _selected.first == 'year';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SegmentedButton(
          segments: [
            ButtonSegment(
              value: 'month',
              label: Text(AppLocalizations.of(context)!.month),
            ),
            ButtonSegment(
              value: 'year',
              label: Text(AppLocalizations.of(context)!.year),
            ),
          ],
          selected: _selected,
          onSelectionChanged: (v) => setState(() => _selected = v),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => IgnoreScreen()),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _isYear ? YearScreen() : MonthScreen(),
      ),
    );
  }
}
