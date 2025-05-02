import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: '今日'),
        NavigationDestination(icon: Icon(Icons.event_note), label: '计划'),
        NavigationDestination(icon: Icon(Icons.medication), label: '药物'),
      ],
    );
  }
}
