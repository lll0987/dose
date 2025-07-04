import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../providers/pill_provider.dart';
import '../service/loading_service.dart';
import '../widgets/pill_card.dart';
import 'pill_form_screen.dart';
import 'quantity_history_screen.dart';
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
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PillFormScreen()),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Consumer<PillProvider>(
        builder: (context, pillProvider, child) {
          if (pillProvider.allPills.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.empty_pillList),
            );
          }
          return ListView.separated(
            itemCount: pillProvider.allPills.length,
            padding: EdgeInsets.all(12),
            separatorBuilder: (_, __) => SizedBox(height: 12), // 设置间距
            itemBuilder: (context, index) {
              final pill = pillProvider.allPills[index];
              return PillCard(
                // imgSize: 64,
                pill: pill,
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PillFormScreen(pill: pill),
                      ),
                    ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => QuantityHistoryScreen(initialData: pill),
                          ),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.pill_history),
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => TransactionScreen(initialData: pill),
                          ),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.pill_transaction,
                      ),
                    ),
                    PopupMenuButton(
                      onSelected: (value) {
                        if (value == "delete") {
                          _onDelete(context, pill.id!);
                        }
                      },
                      itemBuilder:
                          (context) => [
                            PopupMenuItem(
                              value: "delete",
                              child: Text(
                                AppLocalizations.of(context)!.pill_delete,
                              ),
                            ),
                          ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (_) => const PillFormScreen()),
      //     );
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  _onDelete(BuildContext context, int id) async {
    loadingService.show();
    final result = await context.read<PillProvider>().deletePill(id);
    final message =
        result.isSuccess
            ? AppLocalizations.of(context)!.success_delete
            : result.error!;
    loadingService.hide();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
