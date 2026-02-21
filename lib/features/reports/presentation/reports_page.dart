import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/admin_scaffold.dart';
import '../../../shared/widgets/app_data_table.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../shared/widgets/stat_card.dart';
import '../../../shared/widgets/workflow_card.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _reporterController = TextEditingController();
  final TextEditingController _dateRangeController = TextEditingController();

  late List<_ReportItem> _reports;
  final Set<_ReportStatus> _statusFilters = <_ReportStatus>{};

  @override
  void initState() {
    super.initState();
    _reports = List<_ReportItem>.of(_seedReports);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _categoryController.dispose();
    _reporterController.dispose();
    _dateRangeController.dispose();
    super.dispose();
  }

  List<_ReportItem> get _filteredReports =>
      _reports.where(_matchesFilters).toList();

  bool _matchesFilters(_ReportItem item) {
    final query = _searchController.text.trim().toLowerCase();
    final category = _categoryController.text.trim().toLowerCase();
    final reporter = _reporterController.text.trim().toLowerCase();
    final date = _dateRangeController.text.trim().toLowerCase();

    final matchesQuery = query.isEmpty ||
        item.target.toLowerCase().contains(query) ||
        item.category.toLowerCase().contains(query);
    final matchesCategory =
        category.isEmpty || item.category.toLowerCase().contains(category);
    final matchesReporter =
        reporter.isEmpty || item.source.toLowerCase().contains(reporter);
    final matchesDate =
        date.isEmpty || item.submitted.toLowerCase().contains(date);
    final matchesStatus =
        _statusFilters.isEmpty || _statusFilters.contains(item.status);

    return matchesQuery &&
        matchesCategory &&
        matchesReporter &&
        matchesDate &&
        matchesStatus;
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _categoryController.clear();
      _reporterController.clear();
      _dateRangeController.clear();
      _statusFilters.clear();
    });
  }

  void _bulkTakeAction() {
    final indexes = <int>[];
    for (var i = 0; i < _reports.length; i++) {
      if (_matchesFilters(_reports[i])) {
        indexes.add(i);
      }
    }

    if (indexes.isEmpty) {
      _showSnack('No matching reports for action.');
      return;
    }

    setState(() {
      for (final i in indexes) {
        final item = _reports[i];
        final nextStatus =
            item.risk >= 80 ? _ReportStatus.escalated : _ReportStatus.inReview;
        _reports[i] = item.copyWith(status: nextStatus);
      }
    });

    _showSnack('Moderation action applied to ${indexes.length} reports.');
  }

  void _exportCases() {
    _showSnack('Case export prepared for ${_filteredReports.length} records.');
  }

  void _investigate(int index) {
    final item = _reports[index];
    if (item.status == _ReportStatus.resolved) {
      _showSnack('Case already resolved.');
      return;
    }

    setState(() {
      _reports[index] = item.copyWith(
        status: _ReportStatus.inReview,
        risk: math.max(0, item.risk - 8).toInt(),
      );
    });
    _showSnack('Investigation started for selected report.');
  }

  void _warn(int index) {
    final item = _reports[index];
    if (item.status == _ReportStatus.resolved) {
      _showSnack('Case already closed.');
      return;
    }

    setState(() {
      _reports[index] = item.copyWith(
        status: _ReportStatus.inReview,
        risk: math.max(0, item.risk - 16).toInt(),
      );
    });
    _showSnack('Warning issued and case risk updated.');
  }

  void _suspend(int index) {
    final item = _reports[index];
    setState(() {
      _reports[index] = item.copyWith(
        status: _ReportStatus.escalated,
        risk: math.min(100, item.risk + 6).toInt(),
      );
    });
    _showSnack('Suspension action recorded and escalated.');
  }

  @override
  Widget build(BuildContext context) {
    final filteredReports = _filteredReports;
    final openReports =
        _reports.where((r) => r.status == _ReportStatus.open).length;
    final escalatedCases =
        _reports.where((r) => r.status == _ReportStatus.escalated).length;
    final resolvedToday =
        _reports.where((r) => r.status == _ReportStatus.resolved).length;
    final avgResolutionHours = _reports.isEmpty
        ? 0.0
        : ((_reports.length - openReports) / _reports.length) * 5.0;

    final statusCounts = <_ReportStatus, int>{
      for (final status in _ReportStatus.values)
        status: _reports.where((r) => r.status == status).length,
    };

    return AdminScaffold(
      title: 'Reports & Safety',
      body: ListView(
        children: [
          const _Entrance(delayMs: 20, child: _SafetyHero()),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final narrow = constraints.maxWidth < 850;
              final width = narrow
                  ? constraints.maxWidth
                  : (constraints.maxWidth - 36) / 4;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: width,
                    child: _Entrance(
                      delayMs: 80,
                      child: StatCard(
                        label: 'Open Reports',
                        numericValue: openReports.toDouble(),
                        icon: Icons.report_problem_outlined,
                        trendLabel: '-3',
                        accentColor: const Color(0xFFD84315),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _Entrance(
                      delayMs: 120,
                      child: StatCard(
                        label: 'Escalated Cases',
                        numericValue: escalatedCases.toDouble(),
                        icon: Icons.priority_high_outlined,
                        trendLabel: '+1',
                        accentColor: const Color(0xFFB71C1C),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _Entrance(
                      delayMs: 160,
                      child: StatCard(
                        label: 'Resolved Today',
                        numericValue: resolvedToday.toDouble(),
                        icon: Icons.task_alt_outlined,
                        trendLabel: '+5',
                        accentColor: const Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _Entrance(
                      delayMs: 200,
                      child: StatCard(
                        label: 'Avg Resolution Time',
                        numericValue: avgResolutionHours,
                        numberSuffix: 'h',
                        icon: Icons.schedule_outlined,
                        trendLabel: '-0.7h',
                        accentColor: const Color(0xFF1565C0),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          _Entrance(
            delayMs: 260,
            child: SectionCard(
              title: 'Safety Operations',
              action: FilledButton.icon(
                onPressed: _bulkTakeAction,
                icon: const Icon(Icons.shield_outlined),
                label: const Text('Take Action'),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      SizedBox(
                        width: 300,
                        child: TextField(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                              labelText: 'Search report id / target'),
                        ),
                      ),
                      SizedBox(
                        width: 170,
                        child: TextField(
                          controller: _categoryController,
                          onChanged: (_) => setState(() {}),
                          decoration:
                              const InputDecoration(labelText: 'Category'),
                        ),
                      ),
                      SizedBox(
                        width: 170,
                        child: TextField(
                          controller: _reporterController,
                          onChanged: (_) => setState(() {}),
                          decoration:
                              const InputDecoration(labelText: 'Reporter type'),
                        ),
                      ),
                      SizedBox(
                        width: 170,
                        child: TextField(
                          controller: _dateRangeController,
                          onChanged: (_) => setState(() {}),
                          decoration:
                              const InputDecoration(labelText: 'Date range'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ..._ReportStatus.values.map(
                        (status) => FilterChip(
                          label: Text(status.label),
                          selected: _statusFilters.contains(status),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _statusFilters.add(status);
                              } else {
                                _statusFilters.remove(status);
                              }
                            });
                          },
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: _exportCases,
                        icon:
                            const Icon(Icons.file_download_outlined, size: 18),
                        label: const Text('Export Cases'),
                      ),
                      TextButton(
                        onPressed: _clearFilters,
                        child: const Text('Clear filters'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _Entrance(
            delayMs: 330,
            child: SectionCard(
              title: 'Moderation Pipeline',
              child: _PipelineBoard(
                open: statusCounts[_ReportStatus.open] ?? 0,
                inReview: statusCounts[_ReportStatus.inReview] ?? 0,
                escalated: statusCounts[_ReportStatus.escalated] ?? 0,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _Entrance(
            delayMs: 390,
            child: SectionCard(
              title: 'Reports Queue',
              action: Text(
                '${filteredReports.length} records',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              child: filteredReports.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      child: Column(
                        children: [
                          Text(
                            'No reports found for current filters.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton(
                            onPressed: _clearFilters,
                            child: const Text('Reset filters'),
                          ),
                        ],
                      ),
                    )
                  : AppDataTable(
                      columns: const [
                        DataColumn(label: Text('Target')),
                        DataColumn(label: Text('Category')),
                        DataColumn(label: Text('Severity')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Source')),
                        DataColumn(label: Text('Risk')),
                        DataColumn(label: Text('Submitted')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: filteredReports
                          .map(
                            (r) => DataRow(
                              cells: [
                                DataCell(
                                  SizedBox(
                                    width: 220,
                                    child: Text(
                                      r.target,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(Text(r.category)),
                                DataCell(_SeverityTag(severity: r.severity)),
                                DataCell(_StatusTag(status: r.status)),
                                DataCell(Text(r.source)),
                                DataCell(
                                  SizedBox(
                                    width: 120,
                                    child: LinearProgressIndicator(
                                      value: r.risk / 100,
                                      minHeight: 9,
                                      borderRadius: BorderRadius.circular(99),
                                      backgroundColor: const Color(0xFFE2EBE7),
                                    ),
                                  ),
                                ),
                                DataCell(Text(r.submitted)),
                                DataCell(
                                  Wrap(
                                    spacing: 6,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () =>
                                            _investigate(_reports.indexOf(r)),
                                        child: const Text('Investigate'),
                                      ),
                                      OutlinedButton(
                                        onPressed: () =>
                                            _warn(_reports.indexOf(r)),
                                        child: const Text('Warn'),
                                      ),
                                      FilledButton.tonal(
                                        onPressed: () =>
                                            _suspend(_reports.indexOf(r)),
                                        child: const Text('Suspend'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          const _Entrance(delayMs: 470, child: _SafetyAnalytics()),
          const SizedBox(height: 12),
          const _Entrance(
            delayMs: 550,
            child: WorkflowCard(
              title: 'Reports & Safety Workflow',
              steps: [
                'Receive and classify report target type with severity scoring',
                'Investigate evidence, linked history, and repeated abuse patterns',
                'Apply moderation action with clear internal resolution notes',
                'Notify relevant parties and close or escalate based on policy',
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SafetyHero extends StatelessWidget {
  const _SafetyHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFFB71C1C), Color(0xFFD84315), Color(0xFFF4511E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2AB71C1C),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reports & Safety Controller',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Investigate abuse, enforce policy actions, and protect platform trust with full moderation visibility.',
            style: TextStyle(
              color: Color(0xF2FFFFFF),
              fontSize: 15,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _PipelineBoard extends StatelessWidget {
  const _PipelineBoard({
    required this.open,
    required this.inReview,
    required this.escalated,
  });

  final int open;
  final int inReview;
  final int escalated;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 900;
        final width =
            narrow ? constraints.maxWidth : (constraints.maxWidth - 24) / 3;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: width,
              child: _StageCard(
                title: 'Open',
                count: open.toString().padLeft(2, '0'),
                subtitle: 'Waiting investigation',
                color: const Color(0xFFD84315),
              ),
            ),
            SizedBox(
              width: width,
              child: _StageCard(
                title: 'In Review',
                count: inReview.toString().padLeft(2, '0'),
                subtitle: 'Under moderation',
                color: const Color(0xFF1565C0),
              ),
            ),
            SizedBox(
              width: width,
              child: _StageCard(
                title: 'Escalated',
                count: escalated.toString().padLeft(2, '0'),
                subtitle: 'Critical policy risk',
                color: const Color(0xFFB71C1C),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SafetyAnalytics extends StatelessWidget {
  const _SafetyAnalytics();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final vertical = constraints.maxWidth < 980;
        final width =
            vertical ? constraints.maxWidth : (constraints.maxWidth - 12) / 2;
        if (vertical) {
          return Column(
            children: [
              SizedBox(
                width: width,
                child: const SectionCard(
                  title: 'Reports Trend',
                  child: SizedBox(height: 220, child: _ReportsLineChart()),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: width,
                child: const SectionCard(
                  title: 'Category Breakdown',
                  child: SizedBox(height: 220, child: _CategoryPieChart()),
                ),
              ),
            ],
          );
        }
        return Row(
          children: [
            SizedBox(
              width: width,
              child: const SectionCard(
                title: 'Reports Trend',
                child: SizedBox(height: 220, child: _ReportsLineChart()),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: width,
              child: const SectionCard(
                title: 'Category Breakdown',
                child: SizedBox(height: 220, child: _CategoryPieChart()),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ReportsLineChart extends StatelessWidget {
  const _ReportsLineChart();

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) =>
              const FlLine(color: Color(0x160B6B46), strokeWidth: 1),
        ),
        titlesData: const FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(1, 22),
              FlSpot(2, 28),
              FlSpot(3, 24),
              FlSpot(4, 31),
              FlSpot(5, 27),
              FlSpot(6, 23),
            ],
            color: const Color(0xFFD84315),
            barWidth: 3.5,
            isCurved: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFD84315).withAlpha(72),
                  const Color(0xFFD84315).withAlpha(0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryPieChart extends StatelessWidget {
  const _CategoryPieChart();

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        centerSpaceRadius: 42,
        sectionsSpace: 3,
        sections: [
          PieChartSectionData(
            value: 36,
            title: 'Abuse',
            color: const Color(0xFFD84315),
            titleStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600),
          ),
          PieChartSectionData(
            value: 28,
            title: 'Harassment',
            color: const Color(0xFFB71C1C),
            titleStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600),
          ),
          PieChartSectionData(
            value: 21,
            title: 'Fraud',
            color: const Color(0xFF1565C0),
            titleStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600),
          ),
          PieChartSectionData(
            value: 15,
            title: 'Spam',
            color: const Color(0xFF6A1B9A),
            titleStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _StageCard extends StatelessWidget {
  const _StageCard({
    required this.title,
    required this.count,
    required this.subtitle,
    required this.color,
  });

  final String title;
  final String count;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: color.withAlpha(20),
        border: Border.all(color: color.withAlpha(38)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(color: color, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(
            count,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 2),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _SeverityTag extends StatelessWidget {
  const _SeverityTag({required this.severity});

  final _Severity severity;

  @override
  Widget build(BuildContext context) {
    switch (severity) {
      case _Severity.high:
        return const _Pill(label: 'High', color: Color(0xFFB71C1C));
      case _Severity.medium:
        return const _Pill(label: 'Medium', color: Color(0xFFD84315));
      case _Severity.low:
        return const _Pill(label: 'Low', color: Color(0xFF2E7D32));
    }
  }
}

class _StatusTag extends StatelessWidget {
  const _StatusTag({required this.status});

  final _ReportStatus status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case _ReportStatus.open:
        return const _Pill(label: 'Open', color: Color(0xFFD84315));
      case _ReportStatus.inReview:
        return const _Pill(label: 'In Review', color: Color(0xFF1565C0));
      case _ReportStatus.escalated:
        return const _Pill(label: 'Escalated', color: Color(0xFFB71C1C));
      case _ReportStatus.resolved:
        return const _Pill(label: 'Resolved', color: Color(0xFF2E7D32));
    }
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withAlpha(28),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style:
            TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _ReportItem {
  const _ReportItem({
    required this.target,
    required this.category,
    required this.severity,
    required this.status,
    required this.source,
    required this.submitted,
    required this.risk,
  });

  final String target;
  final String category;
  final _Severity severity;
  final _ReportStatus status;
  final String source;
  final String submitted;
  final int risk;

  _ReportItem copyWith({
    String? target,
    String? category,
    _Severity? severity,
    _ReportStatus? status,
    String? source,
    String? submitted,
    int? risk,
  }) {
    return _ReportItem(
      target: target ?? this.target,
      category: category ?? this.category,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      source: source ?? this.source,
      submitted: submitted ?? this.submitted,
      risk: risk ?? this.risk,
    );
  }
}

class _Entrance extends StatefulWidget {
  const _Entrance({required this.child, this.delayMs = 0});

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
      duration: const Duration(milliseconds: 420),
      offset: _visible ? Offset.zero : const Offset(0, 0.04),
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: const Duration(milliseconds: 380),
        child: widget.child,
      ),
    );
  }
}

enum _Severity { high, medium, low }

enum _ReportStatus { open, inReview, escalated, resolved }

extension on _ReportStatus {
  String get label {
    switch (this) {
      case _ReportStatus.open:
        return 'Open';
      case _ReportStatus.inReview:
        return 'In Review';
      case _ReportStatus.escalated:
        return 'Escalated';
      case _ReportStatus.resolved:
        return 'Resolved';
    }
  }
}

const List<_ReportItem> _seedReports = <_ReportItem>[
  _ReportItem(
    target: 'User: ahmed@mail.com',
    category: 'Abuse',
    severity: _Severity.high,
    status: _ReportStatus.open,
    source: 'User report',
    submitted: '5m ago',
    risk: 86,
  ),
  _ReportItem(
    target: 'Class: Fiqh Essentials',
    category: 'Harassment',
    severity: _Severity.medium,
    status: _ReportStatus.inReview,
    source: 'Auto-flag',
    submitted: '30m ago',
    risk: 62,
  ),
  _ReportItem(
    target: 'Charity: Clean Water - Sindh',
    category: 'Fraud suspicion',
    severity: _Severity.high,
    status: _ReportStatus.escalated,
    source: 'Admin audit',
    submitted: '1h ago',
    risk: 91,
  ),
  _ReportItem(
    target: 'Post: Daily inspiration #442',
    category: 'Misinformation',
    severity: _Severity.low,
    status: _ReportStatus.resolved,
    source: 'User report',
    submitted: 'Yesterday',
    risk: 28,
  ),
];
