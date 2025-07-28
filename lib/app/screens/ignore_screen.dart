import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../database/repository/plan_repository.dart';
import '../models/plan_model.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';
import '../service/loading_service.dart';
import '../utils/datetime.dart';
import '../widgets/required_label.dart';

class IgnoreScreen extends StatefulWidget {
  const IgnoreScreen({super.key});

  @override
  State<StatefulWidget> createState() => _IgnoreScreenState();
}

class _IgnoreScreenState extends State<StatefulWidget> {
  final _formKey = GlobalKey<FormState>();

  int? _selectedPlan;
  final List<DateTime> _dateList = [];

  late Future<List<PlanItemModel>> _futureList;
  List<PlanItemModel> _planList = [];

  bool _isValidate = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      _futureList =
          Provider.of<PlanRepository>(context, listen: false).getPlanItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.addIgnore)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: FutureBuilder<List<PlanItemModel>>(
                  future: _futureList,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text(
                        '${AppLocalizations.of(context)!.error_hasError}: ${snapshot.error}',
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text(AppLocalizations.of(context)!.error_noData);
                    } else {
                      _planList = snapshot.data!;
                      if (_planList.isEmpty) {
                        return Center(
                          child: Text(
                            AppLocalizations.of(context)!.empty_ignorePlanList,
                          ),
                        );
                      }
                      if (_selectedPlan == null && _planList.length == 1) {
                        _selectedPlan = _planList.first.id;
                      }
                      return SizedBox(
                        width: double.infinity,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 选择一个计划
                              DropdownButtonFormField<int>(
                                value: _selectedPlan,
                                validator: (value) {
                                  if (value == null) {
                                    return AppLocalizations.of(
                                      context,
                                    )!.validToken_ignorePlan_required;
                                  }
                                  return null;
                                },
                                items:
                                    _planList
                                        .map(
                                          (item) => DropdownMenuItem(
                                            value: item.id,
                                            child: Text(item.text),
                                          ),
                                        )
                                        .toList(),
                                onChanged:
                                    (value) => setState(() {
                                      _selectedPlan = value;
                                    }),
                                decoration: InputDecoration(
                                  label: RequiredLabel(
                                    text:
                                        AppLocalizations.of(
                                          context,
                                        )!.ignoreForm_plan,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              // 添加一组日期
                              RequiredLabel(
                                text:
                                    AppLocalizations.of(
                                      context,
                                    )!.ignoreForm_dates,
                              ),
                              if (!_isValidate)
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.validToken_ignoreDates_required,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: 12,
                                  ),
                                ),
                              SizedBox(height: 4),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  ..._dateList.asMap().entries.map(((entry) {
                                    final date = entry.value;
                                    final index = entry.key;
                                    return Chip(
                                      label: Text(getFormatDate(date)),
                                      onDeleted:
                                          () => setState(() {
                                            _dateList.removeAt(index);
                                          }),
                                    );
                                  })),
                                  IconButton.filledTonal(
                                    onPressed: () async {
                                      final newDate = await showDatePicker(
                                        context: context,
                                        initialDate:
                                            _dateList.isEmpty
                                                ? DateTime.now()
                                                : _dateList.last,
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                      );
                                      if (newDate != null) {
                                        setState(() {
                                          _dateList.add(newDate);
                                        });
                                      }
                                    },
                                    icon: Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            FilledButton(
              onPressed: () => _onPressed(),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                textStyle: TextStyle(fontSize: 16),
              ),
              child: Text(AppLocalizations.of(context)!.save),
            ),
          ],
        ),
      ),
    );
  }

  void _onPressed() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isValidate = _dateList.isNotEmpty;
    });
    if (!_isValidate) return;
    loadingService.show();

    final plan = _planList.firstWhere((element) => element.id == _selectedPlan);
    final (hour, minute) = getTimeFromString(plan.startTime)!;

    await context.read<TransactionProvider>().addTransactions(
      _dateList.map((e) {
        return TransactionModel(
          pillId: plan.pillId,
          planId: plan.id,
          quantities: [],
          startTime: DateTime(e.year, e.month, e.day, hour, minute),
          endTime: null,
          isNegative: true,
          isCustom: true,
        );
      }).toList(),
    );

    loadingService.hide();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.success_save),
        duration: Duration(seconds: 1),
      ),
    );
    Navigator.of(context).pop();
  }
}
