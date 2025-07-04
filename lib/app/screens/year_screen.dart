import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/daily_provider.dart';
import '../providers/theme_provider.dart';
import '../service/loading_service.dart';
import '../utils/datetime.dart';

class YearScreen extends StatefulWidget {
  const YearScreen({super.key});

  @override
  State<YearScreen> createState() => _YearScreenState();
}

class _YearScreenState extends State<YearScreen> {
  double _pointSize = 16;
  final double _pointSpacing = 4;

  late int _currentYear; // 当前年份

  void _loadData() async {
    loadingService.show();
    await context.read<DailyProvider>().loadHistoryData(year: _currentYear);
    loadingService.hide();
  }

  @override
  void initState() {
    super.initState();
    _currentYear = context.read<DailyProvider>().year;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final size = (screenWidth - 16 * 4 - 8 * 6 - _pointSpacing * 2) ~/ 21;
    _pointSize = min(size.toDouble(), 16);

    final locale = Localizations.localeOf(context).toString();
    final dateFormat = DateFormat.MMMM(locale);

    return Consumer<DailyProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton.outlined(
                    onPressed: () {
                      setState(() {
                        _currentYear--;
                        _loadData();
                      });
                    },
                    icon: Icon(Icons.chevron_left),
                  ),
                  Text(
                    '$_currentYear',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  IconButton.outlined(
                    onPressed: () {
                      setState(() {
                        _currentYear++;
                        _loadData();
                      });
                    },
                    icon: Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 12,
                itemBuilder: (context, index) {
                  final month = index + 1;
                  final data = provider.yearTransactions[month];
                  final DateTime firstDayOfMonth = DateTime(
                    _currentYear,
                    month,
                    1,
                  );
                  final DateTime lastDayOfMonth = DateTime(
                    _currentYear,
                    month + 1,
                    0,
                  );

                  return _buildMonthCard(
                    dateFormat,
                    firstDayOfMonth,
                    lastDayOfMonth,
                    data,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMonthCard(
    DateFormat dateFormat,
    DateTime firstDayOfMonth,
    DateTime lastDayOfMonth,
    Map<int, List<int>>? data,
  ) {
    final int firstDayOfWeek = firstDayOfMonth.weekday;
    // 根据本月执行次数最大值计算高度
    final maxThemeValuesLength = data?.values
        .map((list) => list.length)
        .reduce(max);
    final rowCount =
        maxThemeValuesLength == null ? 0 : (maxThemeValuesLength ~/ 3) + 1;
    final height = rowCount * (_pointSize + _pointSpacing) + 34;

    return Card(
      margin: EdgeInsets.only(bottom: 16, left: 16, right: 16),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateFormat.format(firstDayOfMonth),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16.0),
            Row(
              children: List.generate(
                7,
                (index) => Expanded(
                  child: Center(
                    child: Text(
                      getWeekdayMinDisplayName(context, index + 1),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                mainAxisExtent: height,
              ),
              itemCount: firstDayOfWeek + lastDayOfMonth.day - 1,
              itemBuilder: (context, index) {
                if (index < firstDayOfWeek - 1) {
                  return SizedBox.shrink(); // 空占位
                }
                final day = index - firstDayOfWeek + 2;
                return _buildDayTile(
                  rowCount,
                  day,
                  data == null || data[day] == null ? [] : data[day]!,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayTile(int rowCount, int day, List<int> data) {
    if (day < 1) return SizedBox.shrink(); // 空占位
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 32,
                child: Center(
                  child: Text('$day', style: TextStyle(fontSize: 16)),
                ),
              ),
              ...List.generate(rowCount, (rowIndex) {
                final colCount =
                    data.length > (rowIndex + 1) * 3 ? 3 : data.length % 3;
                return SizedBox(
                  height: _pointSize + _pointSpacing,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(colCount, (colIndex) {
                      final index = rowIndex * 3 + colIndex;
                      if (index >= data.length) return SizedBox.shrink();
                      final themeValue = data[index];
                      return Container(
                        // width: _pointSize,
                        // height: _pointSize,
                        constraints: BoxConstraints(
                          maxWidth: _pointSize,
                          maxHeight: _pointSize,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              themeValue == -1
                                  ? themeProvider.themeColor
                                  : Color(themeValue),
                        ),
                      );
                    }),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
