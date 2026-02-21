import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../shared/widgets/admin_scaffold.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../shared/widgets/stat_card.dart';
import '../../../shared/widgets/workflow_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Super Admin Dashboard',
      body: ListView(
        cacheExtent: 1000,
        children: [
          _Entrance(
            delayMs: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0B6B46),
                    Color(0xFF1A8D5A),
                    Color(0xFF2EA36D)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x2B0B6B46),
                    blurRadius: 24,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Central Command Center',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Professional overview of users, scholars, charity, learning, and AI governance in one place.',
                    style: TextStyle(
                        color: Color(0xF2FFFFFF), fontSize: 15, height: 1.45),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 850;
              final width = isNarrow
                  ? constraints.maxWidth
                  : (constraints.maxWidth - 24) / 3;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (var i = 0; i < _kpis.length; i++)
                    SizedBox(
                      width: width,
                      child: _Entrance(
                        delayMs: 60 + (i * 45),
                        child: StatCard(
                          label: _kpis[i].label,
                          numericValue: _kpis[i].value,
                          numberPrefix: _kpis[i].prefix,
                          numberSuffix: _kpis[i].suffix,
                          icon: _kpis[i].icon,
                          trendLabel: _kpis[i].trend,
                          accentColor: _kpis[i].color,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          _Entrance(
            delayMs: 320,
            child: SectionCard(
              title: 'User Growth',
              action: Text('Last 6 months',
                  style: Theme.of(context).textTheme.bodySmall),
              child: SizedBox(
                height: 230,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 50,
                      getDrawingHorizontalLine: (_) => const FlLine(
                        color: Color(0x160B6B46),
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: const FlTitlesData(
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(1, 100),
                          FlSpot(2, 140),
                          FlSpot(3, 230),
                          FlSpot(4, 300),
                          FlSpot(5, 360),
                          FlSpot(6, 430),
                        ],
                        color: const Color(0xFF0B6B46),
                        barWidth: 4,
                        isCurved: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF0B6B46).withAlpha(70),
                              const Color(0xFF0B6B46).withAlpha(0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _Entrance(
            delayMs: 420,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final vertical = constraints.maxWidth < 980;
                final itemWidth = vertical
                    ? constraints.maxWidth
                    : (constraints.maxWidth - 12) / 2;
                final cards = [
                  SizedBox(
                    width: itemWidth,
                    child: SectionCard(
                      title: 'Donations Overview',
                      child: SizedBox(
                        height: 220,
                        child: BarChart(
                          BarChartData(
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              horizontalInterval: 20,
                              getDrawingHorizontalLine: (_) => const FlLine(
                                color: Color(0x160B6B46),
                                strokeWidth: 1,
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            titlesData: const FlTitlesData(
                              rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                            ),
                            barGroups: [
                              for (var i = 0; i < 6; i++)
                                BarChartGroupData(
                                  x: i,
                                  barRods: [
                                    BarChartRodData(
                                      toY: 20 + (i * 10),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF0B6B46),
                                          Color(0xFF2EA36D)
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                      width: 16,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: SectionCard(
                      title: 'Charity Distribution',
                      child: SizedBox(
                        height: 220,
                        child: PieChart(
                          PieChartData(
                            centerSpaceRadius: 40,
                            sectionsSpace: 3,
                            sections: [
                              PieChartSectionData(
                                value: 45,
                                title: 'Water',
                                color: const Color(0xFF1D8A5D),
                                titleStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              PieChartSectionData(
                                value: 30,
                                title: 'Food',
                                color: const Color(0xFF00A889),
                                titleStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              PieChartSectionData(
                                value: 25,
                                title: 'Medical',
                                color: const Color(0xFF38B4A2),
                                titleStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ];
                if (vertical) {
                  return Column(
                    children: [
                      cards[0],
                      const SizedBox(height: 12),
                      cards[1],
                    ],
                  );
                }
                return Row(
                  children: [
                    cards[0],
                    const SizedBox(width: 12),
                    cards[1],
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          _Entrance(
            delayMs: 560,
            child: SectionCard(
              title: 'Quick Actions',
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: const [
                  _QuickActionTile(
                    title: 'Approve Scholars',
                    subtitle: 'Open scholar verification queue',
                    icon: Icons.workspace_premium_outlined,
                    route: AppRoutes.scholars,
                  ),
                  _QuickActionTile(
                    title: 'Charity Requests',
                    subtitle: 'Review pending charity approvals',
                    icon: Icons.volunteer_activism_outlined,
                    route: AppRoutes.charity,
                  ),
                  _QuickActionTile(
                    title: 'Safety Reports',
                    subtitle: 'Investigate and resolve escalations',
                    icon: Icons.report_problem_outlined,
                    route: AppRoutes.reports,
                  ),
                  _QuickActionTile(
                    title: 'Audit Logs',
                    subtitle: 'Trace critical admin activity',
                    icon: Icons.fact_check_outlined,
                    route: AppRoutes.logs,
                  ),
                  _QuickActionTile(
                    title: 'Content Control',
                    subtitle: 'Publish and manage core content',
                    icon: Icons.menu_book_outlined,
                    route: AppRoutes.cms,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const _Entrance(
            delayMs: 700,
            child: WorkflowCard(
              title: 'Super Admin Priority Workflow',
              steps: [
                'Review pending scholar and charity approvals',
                'Resolve abuse reports and safety escalations',
                'Audit AI responses and update disclaimers',
                'Publish verified Quran/Hadith/Tafseer updates',
                'Review audit logs and critical settings changes',
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricData {
  const _MetricData(
    this.label,
    this.value,
    this.icon,
    this.color, {
    this.prefix = '',
    this.suffix = '',
    this.trend,
  });

  final String label;
  final double value;
  final IconData icon;
  final Color color;
  final String prefix;
  final String suffix;
  final String? trend;
}

const _kpis = <_MetricData>[
  _MetricData(
    'Total Users',
    12450,
    Icons.people_alt_outlined,
    Color(0xFF0B6B46),
    trend: '+8.4%',
  ),
  _MetricData(
    'Active Users (7d)',
    5204,
    Icons.bolt_outlined,
    Color(0xFF00897B),
    trend: '+2.1%',
  ),
  _MetricData(
    'Verified Scholars',
    236,
    Icons.school_outlined,
    Color(0xFF2E7D32),
    trend: '+12',
  ),
  _MetricData(
    'Pending Scholars',
    18,
    Icons.pending_actions_outlined,
    Color(0xFFF9A825),
    trend: 'Needs review',
  ),
  _MetricData(
    'Pending Charity',
    11,
    Icons.volunteer_activism_outlined,
    Color(0xFFFF7043),
    trend: 'Urgent',
  ),
  _MetricData(
    'Total Donations',
    402,
    Icons.savings_outlined,
    Color(0xFF00838F),
    suffix: 'k',
    prefix: '\$',
  ),
  _MetricData(
    'Active Classes',
    87,
    Icons.cast_for_education_outlined,
    Color(0xFF6A1B9A),
    trend: '+6',
  ),
  _MetricData(
    'Open Reports',
    29,
    Icons.report_problem_outlined,
    Color(0xFFD84315),
    trend: '-3',
  ),
  _MetricData(
    'Q&A Questions',
    120,
    Icons.question_answer_outlined,
    Color(0xFF1565C0),
    suffix: 'k',
    trend: '+18%',
  ),
];

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String route;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => context.go(route),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Theme.of(context).colorScheme.primary.withAlpha(16),
            border:
                Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withAlpha(24),
                child: Icon(icon, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text(subtitle,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Entrance extends StatefulWidget {
  const _Entrance({
    required this.child,
    this.delayMs = 0,
  });

  final Widget child;
  final int delayMs;

  @override
  State<_Entrance> createState() => _EntranceState();
}

class _EntranceState extends State<_Entrance> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(Duration(milliseconds: widget.delayMs), () {
      if (mounted) {
        setState(() => _visible = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      offset: _visible ? Offset.zero : const Offset(0, 0.04),
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
