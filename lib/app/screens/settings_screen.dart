import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/themes/theme_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Blue Theme'),
            onTap: () => themeService.updateTheme(Colors.blue),
          ),
          ListTile(
            title: const Text('Green Theme'),
            onTap: () => themeService.updateTheme(Colors.green),
          ),
        ],
      ),
    );
  }
}
