import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/data/providers/pill_provider.dart';
import '../widgets/pill_card.dart';
import 'pill_form_screen.dart';
import 'transaction_screen.dart';

class PillScreen extends StatefulWidget {
  const PillScreen({super.key});

  @override
  State<PillScreen> createState() => _PillScreenState();
}

class _PillScreenState extends State<PillScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('药物')),
      body: Consumer<PillProvider>(
        builder: (context, pillProvider, child) {
          if (pillProvider.allPills.isEmpty) {
            return Center(child: Text("No pills yet."));
          }
          return ListView.separated(
            itemCount: pillProvider.allPills.length,
            padding: EdgeInsets.all(12),
            separatorBuilder: (_, __) => SizedBox(height: 12), // 设置间距
            itemBuilder: (context, index) {
              final pill = pillProvider.allPills[index];
              return PillCard(
                pill: pill,
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PillFormScreen(pill: pill),
                      ),
                    ),
                trailing: TextButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TransactionScreen(initialData: pill),
                      ),
                    );
                  },
                  child: Text('调整数量'),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PillFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
