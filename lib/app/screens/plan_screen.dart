import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../database/repository/pill_repository.dart';
import '../models/pill_model.dart';
import '../models/plan_model.dart';
import '../providers/pill_provider.dart';
import '../providers/plan_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/plan_card.dart';
import 'plan_form_screen.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PlanProvider>().loadPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('计划'),
        actions: [
          IconButton(
            onPressed: () async {
              final flag = await context.read<PillRepository>().isEmpty();
              if (flag) {
                // 提醒用户添加药品
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.validToken_pill_required,
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }
              // 打开添加计划页面
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PlanFormScreen()),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Consumer2<PlanProvider, PillProvider>(
        builder: (context, planProvider, pillProvider, child) {
          if (planProvider.allPlans.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.empty_planList),
            );
          }
          return ListView.builder(
            itemCount: planProvider.groupedPlans.length,
            itemBuilder: (context, index) {
              final pill =
                  pillProvider.pillMap[planProvider.groupedPlans.keys.elementAt(
                    index,
                  )]!;
              final plans = planProvider.groupedPlans.values.elementAt(index);
              return PlanGroupItem(pill: pill, plans: plans);
            },
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     final flag = await context.read<PillRepository>().isEmpty();
      //     if (flag) {
      //       // 提醒用户添加药品
      //       ScaffoldMessenger.of(context).showSnackBar(
      //         SnackBar(
      //           content: Text('请先添加药物信息'),
      //           duration: Duration(seconds: 2),
      //         ),
      //       );
      //       return;
      //     }
      //     // 打开添加计划页面
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (_) => const PlanFormScreen()),
      //     );
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}

class PlanGroupItem extends StatelessWidget {
  final PillModel pill;
  final List<PlanModel> plans;

  const PlanGroupItem({super.key, required this.pill, required this.plans});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return ExpansionTile(
          title: Row(
            children: [
              // 圆点（使用Container实现）
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: themeProvider.getColor(pill.themeValue), // 圆点颜色（可自定义）
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8), // 图标和文字间距
              // 原始标题文本
              Text(pill.name),
            ],
          ),
          shape: Border(),
          collapsedShape: Border(),
          initiallyExpanded: true,
          children: [
            ListView.separated(
              shrinkWrap: true, // 关键：让 ListView 适应父容器高度
              physics: NeverScrollableScrollPhysics(), // 禁用内部滚动
              itemCount: plans.length,
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
              separatorBuilder: (_, __) => SizedBox(height: 8), // 设置间距
              itemBuilder:
                  (_, index) => PlanCard(
                    plan: plans[index],
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlanFormScreen(plan: plans[index]),
                          ),
                        ),
                  ),
            ),
          ],
          // plans.map((plan) => PlanCard(plan: plan, onTap: () {})).toList(),
        );
      },
    );
  }
}
