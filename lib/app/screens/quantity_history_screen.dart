import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../database/repository/transaction_repository.dart';
import '../models/pill_model.dart';
import '../utils/datetime.dart';
import '../widgets/pill_card.dart';

class QuantityHistoryScreen extends StatefulWidget {
  final PillModel initialData;

  const QuantityHistoryScreen({super.key, required this.initialData});

  @override
  State<QuantityHistoryScreen> createState() => _QuantityHistoryScreenState();
}

class _QuantityHistoryScreenState extends State<QuantityHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.quantityHistory),
      ),
      body: FutureBuilder(
        future: context
            .read<TransactionRepository>()
            .getTransactionHistoryByPill(widget.initialData.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                '${AppLocalizations.of(context)!.error_hasError}: ${snapshot.error}',
              ),
            );
          } else {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(AppLocalizations.of(context)!.error_noData),
              );
            }
            final transactions = snapshot.data!;
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: PillCard(pill: widget.initialData),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      final symbol = transaction.isNegative ? '-' : '+';
                      final total = transaction.calcQty;
                      final unit = widget.initialData.packSpecs.last.unit;
                      return ExpansionTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(getFormatDateTime(transaction.startTime)),
                            Text(
                              '$symbol$total$unit',
                              style: TextStyle(
                                color:
                                    transaction.isNegative
                                        ? Theme.of(context).colorScheme.error
                                        : Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        // NEXT 调整列表样式
                        children: [
                          if (transaction.remark != null &&
                              transaction.remark!.isNotEmpty) ...[
                            _buildItem(
                              context,
                              AppLocalizations.of(
                                context,
                              )!.quantityHistory_remark,
                              Text(transaction.remark!),
                            ),
                            SizedBox(height: 8),
                          ],
                          _buildItem(
                            context,
                            AppLocalizations.of(
                              context,
                            )!.quantityHistory_timestamp,
                            Text(getFormatDateTime(transaction.timestamp!)),
                          ),
                          SizedBox(height: 8),
                          _buildItem(
                            context,
                            AppLocalizations.of(
                              context,
                            )!.quantityHistory_quantities,
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children:
                                  transaction.quantities
                                      .map(
                                        (item) => Chip(
                                          label: Text(
                                            '${item.displayText}${item.unit!}',
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),
                          SizedBox(height: 8),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, String title, Widget child) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.labelSmall),
            child,
          ],
        ),
      ),
    );
  }
}
