import 'package:flutter/material.dart';

import 'daily_screen.dart';
import 'ignore_screen.dart';
import 'year_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isYear = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          IconButton(
            onPressed: () {
              setState(() {
                _isYear = !_isYear;
              });
            },
            icon: Icon(
              _isYear ? Icons.calendar_view_day : Icons.calendar_month,
            ),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _isYear ? YearScreen() : DailyScreen(),
      ),
    );
  }
}
