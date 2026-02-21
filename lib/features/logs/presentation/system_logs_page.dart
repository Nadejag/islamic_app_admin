import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/admin_scaffold.dart';
import '../../../shared/widgets/app_data_table.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../shared/widgets/stat_card.dart';
import '../../../shared/widgets/workflow_card.dart';

class SystemLogsPage extends StatefulWidget {
  const SystemLogsPage({super.key});

  @override
  State<SystemLogsPage> createState() => _SystemLogsPageState();
}

class _SystemLogsPageState extends State<SystemLogsPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _moduleController = TextEditingController();
  final TextEditingController _severityController = TextEditingController();
  final TextEditingController _timeRangeController = TextEditingController();

  late List<_AuditEntry> _entries;
  bool _highRiskOnly = false;
  bool _rolePermissionOnly = false;
  bool _verifiedHashOnly = false;

  @override
  void initState() {
    super.initState();
    _entries = List<_AuditEntry>.of(_seedEntries);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _moduleController.dispose();
    _severityController.dispose();
    _timeRangeController.dispose();
    super.dispose();
  }

  List<_AuditEntry> get _filteredEntries =>
      _entries.where(_matchesFilters).toList();

  bool _matchesFilters(_AuditEntry entry) {
    final query = _searchController.text.trim().toLowerCase();
    final module = _moduleController.text.trim().toLowerCase();
    final severity = _severityController.text.trim().toLowerCase();
    final time = _timeRangeController.text.trim().toLowerCase();

    final matchesQuery = query.isEmpty ||
        entry.actor.toLowerCase().contains(query) ||
        entry.action.toLowerCase().contains(query) ||
        entry.hash.toLowerCase().contains(query);
    final matchesModule =
        module.isEmpty || entry.module.toLowerCase().contains(module);
    final matchesSeverity = severity.isEmpty ||
        entry.severity.label.toLowerCase().contains(severity);
    final matchesTime =
        time.isEmpty || entry.timestamp.toLowerCase().contains(time);
    final matchesHighRisk = !_highRiskOnly || entry.severity == _Severity.high;
    final matchesRole = !_rolePermissionOnly ||
        entry.action.toLowerCase().contains('role') ||
        entry.action.toLowerCase().contains('permission');
    final matchesVerified =
        !_verifiedHashOnly || entry.status == _LogStatus.verified;

    return matchesQuery &&
        matchesModule &&
        matchesSeverity &&
        matchesTime &&
        matchesHighRisk &&
        matchesRole &&
        matchesVerified;
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _moduleController.clear();
      _severityController.clear();
      _timeRangeController.clear();
      _highRiskOnly = false;
      _rolePermissionOnly = false;
      _verifiedHashOnly = false;
    });
  }

  void _exportCompliancePack() {
    _showSnack(
        'Compliance pack prepared for ${_filteredEntries.length} entries.');
  }

  void _replayTimeline() {
    _showSnack('Timeline replay generated for current forensic filters.');
  }

  void _viewDiff(int index) {
    final entry = _entries[index];
    _showSnack('Diff opened for ${entry.module} action.');
  }

  void _traceEntry(int index) {
    final entry = _entries[index];
    setState(() {
      _entries[index] = entry.copyWith(status: _LogStatus.review);
    });
    _showSnack('Trace initiated for digest ${entry.hash}.');
  }

  void _flagEntry(int index) {
    final entry = _entries[index];
    setState(() {
      _entries[index] = entry.copyWith(status: _LogStatus.flagged);
    });
    _showSnack('Entry flagged for integrity investigation.');
  }

  @override
  Widget build(BuildContext context) {
    final filteredEntries = _filteredEntries;
    final highRisk = _entries.where((e) => e.severity == _Severity.high).length;
    final integrityVerified = _entries.isEmpty
        ? 0.0
        : (_entries.where((e) => e.status == _LogStatus.verified).length /
                _entries.length) *
            100;
    final reviewCount =
        _entries.where((e) => e.status == _LogStatus.review).length;

    return AdminScaffold(
      title: 'Audit Logs',
      body: ListView(
        children: [
          const _Entrance(delayMs: 20, child: _AuditHero()),
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
                        label: 'Entries Today',
                        numericValue: _entries.length.toDouble(),
                        icon: Icons.receipt_long_outlined,
                        trendLabel: '+28',
                        accentColor: const Color(0xFF37474F),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _Entrance(
                      delayMs: 120,
                      child: StatCard(
                        label: 'High-Risk Events',
                        numericValue: highRisk.toDouble(),
                        icon: Icons.warning_amber_outlined,
                        trendLabel: '+2',
                        accentColor: const Color(0xFFD84315),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _Entrance(
                      delayMs: 160,
                      child: StatCard(
                        label: 'Integrity Verified',
                        numericValue: integrityVerified,
                        numberSuffix: '%',
                        icon: Icons.verified_user_outlined,
                        trendLabel: 'Stable',
                        accentColor: const Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _Entrance(
                      delayMs: 200,
                      child: StatCard(
                        label: 'Compliance Exports',
                        numericValue: reviewCount.toDouble(),
                        icon: Icons.file_download_outlined,
                        trendLabel: 'This week',
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
              title: 'Forensics Filters',
              action: FilledButton.icon(
                onPressed: _exportCompliancePack,
                icon: const Icon(Icons.download_for_offline_outlined),
                label: const Text('Export Compliance Pack'),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      SizedBox(
                        width: 320,
                        child: TextField(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                              labelText: 'Search actor / action / hash'),
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: TextField(
                          controller: _moduleController,
                          onChanged: (_) => setState(() {}),
                          decoration:
                              const InputDecoration(labelText: 'Module'),
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: TextField(
                          controller: _severityController,
                          onChanged: (_) => setState(() {}),
                          decoration:
                              const InputDecoration(labelText: 'Severity'),
                        ),
                      ),
                      SizedBox(
                        width: 190,
                        child: TextField(
                          controller: _timeRangeController,
                          onChanged: (_) => setState(() {}),
                          decoration:
                              const InputDecoration(labelText: 'Time range'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('High Risk'),
                        selected: _highRiskOnly,
                        onSelected: (selected) =>
                            setState(() => _highRiskOnly = selected),
                      ),
                      FilterChip(
                        label: const Text('Role/Permission'),
                        selected: _rolePermissionOnly,
                        onSelected: (selected) =>
                            setState(() => _rolePermissionOnly = selected),
                      ),
                      FilterChip(
                        label: const Text('Verified Hash'),
                        selected: _verifiedHashOnly,
                        onSelected: (selected) =>
                            setState(() => _verifiedHashOnly = selected),
                      ),
                      OutlinedButton.icon(
                        onPressed: _replayTimeline,
                        icon: const Icon(Icons.history_toggle_off, size: 18),
                        label: const Text('Replay Timeline'),
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
              title: 'Chain of Custody Board',
              child: _CustodyBoard(
                captured: _entries.length,
                verified: _entries
                    .where((e) => e.status == _LogStatus.verified)
                    .length,
                underAudit: _entries
                    .where((e) => e.status != _LogStatus.verified)
                    .length,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _Entrance(
            delayMs: 390,
            child: SectionCard(
              title: 'Audit Trail Records',
              action: Text(
                '${filteredEntries.length} records',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              child: filteredEntries.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      child: Column(
                        children: [
                          Text(
                            'No audit entries found for current filters.',
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
                        DataColumn(label: Text('Actor')),
                        DataColumn(label: Text('Action')),
                        DataColumn(label: Text('Module')),
                        DataColumn(label: Text('Severity')),
                        DataColumn(label: Text('Integrity')),
                        DataColumn(label: Text('Timestamp')),
                        DataColumn(label: Text('Digest')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: filteredEntries
                          .map(
                            (e) => DataRow(
                              cells: [
                                DataCell(
                                  SizedBox(
                                    width: 210,
                                    child: Text(
                                      e.actor,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 250,
                                    child: Text(
                                      e.action,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(Text(e.module)),
                                DataCell(_SeverityTag(severity: e.severity)),
                                DataCell(_StatusTag(status: e.status)),
                                DataCell(Text(e.timestamp)),
                                DataCell(_HashTag(hash: e.hash)),
                                DataCell(
                                  Wrap(
                                    spacing: 6,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () =>
                                            _viewDiff(_entries.indexOf(e)),
                                        child: const Text('View Diff'),
                                      ),
                                      OutlinedButton(
                                        onPressed: () =>
                                            _traceEntry(_entries.indexOf(e)),
                                        child: const Text('Trace'),
                                      ),
                                      FilledButton.tonal(
                                        onPressed: () =>
                                            _flagEntry(_entries.indexOf(e)),
                                        child: const Text('Flag'),
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
          const _Entrance(delayMs: 470, child: _AuditAnalytics()),
          const SizedBox(height: 12),
          const _Entrance(
            delayMs: 540,
            child: WorkflowCard(
              title: 'Audit Compliance Workflow',
              steps: [
                'Capture each super admin action with before/after payload signatures',
                'Filter logs by module, actor, risk, and integrity state',
                'Investigate high-risk events and append compliance notes',
                'Export regulator-ready audit packs with cryptographic digest references',
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AuditHero extends StatelessWidget {
  const _AuditHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E2A32), Color(0xFF2C3E50), Color(0xFF415A6B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2A000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Audit Command Console',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'A distinct forensic interface for integrity tracking, compliance evidence, and high-risk action investigation.',
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

class _CustodyBoard extends StatelessWidget {
  const _CustodyBoard({
    required this.captured,
    required this.verified,
    required this.underAudit,
  });

  final int captured;
  final int verified;
  final int underAudit;

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
                title: 'Captured',
                count: '$captured',
                subtitle: 'Raw immutable entries',
                color: const Color(0xFF37474F),
              ),
            ),
            SizedBox(
              width: width,
              child: _StageCard(
                title: 'Verified',
                count: '$verified',
                subtitle: 'Digest matched',
                color: const Color(0xFF2E7D32),
              ),
            ),
            SizedBox(
              width: width,
              child: _StageCard(
                title: 'Under Audit',
                count: '$underAudit',
                subtitle: 'Integrity investigation',
                color: const Color(0xFFD84315),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AuditAnalytics extends StatelessWidget {
  const _AuditAnalytics();

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
                  title: 'Risk Event Trend',
                  child: SizedBox(height: 220, child: _AuditLineChart()),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: width,
                child: const SectionCard(
                  title: 'Module Risk Distribution',
                  child: SizedBox(height: 220, child: _AuditBarChart()),
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
                title: 'Risk Event Trend',
                child: SizedBox(height: 220, child: _AuditLineChart()),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: width,
              child: const SectionCard(
                title: 'Module Risk Distribution',
                child: SizedBox(height: 220, child: _AuditBarChart()),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AuditLineChart extends StatelessWidget {
  const _AuditLineChart();

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
              FlSpot(1, 8),
              FlSpot(2, 12),
              FlSpot(3, 11),
              FlSpot(4, 15),
              FlSpot(5, 13),
              FlSpot(6, 9),
            ],
            color: const Color(0xFFD84315),
            barWidth: 3.5,
            isCurved: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFD84315).withAlpha(70),
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

class _AuditBarChart extends StatelessWidget {
  const _AuditBarChart();

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
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
        barGroups: [
          BarChartGroupData(x: 0, barRods: [
            BarChartRodData(toY: 14, color: const Color(0xFF37474F), width: 14)
          ]),
          BarChartGroupData(x: 1, barRods: [
            BarChartRodData(toY: 19, color: const Color(0xFFD84315), width: 14)
          ]),
          BarChartGroupData(x: 2, barRods: [
            BarChartRodData(toY: 11, color: const Color(0xFF1565C0), width: 14)
          ]),
          BarChartGroupData(x: 3, barRods: [
            BarChartRodData(toY: 7, color: const Color(0xFF2E7D32), width: 14)
          ]),
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
        return const _Pill(label: 'High', color: Color(0xFFD84315));
      case _Severity.medium:
        return const _Pill(label: 'Medium', color: Color(0xFFF9A825));
      case _Severity.low:
        return const _Pill(label: 'Low', color: Color(0xFF2E7D32));
    }
  }
}

class _StatusTag extends StatelessWidget {
  const _StatusTag({required this.status});

  final _LogStatus status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case _LogStatus.verified:
        return const _Pill(label: 'Verified', color: Color(0xFF2E7D32));
      case _LogStatus.review:
        return const _Pill(label: 'Review', color: Color(0xFF1565C0));
      case _LogStatus.flagged:
        return const _Pill(label: 'Flagged', color: Color(0xFFD84315));
    }
  }
}

class _HashTag extends StatelessWidget {
  const _HashTag({required this.hash});

  final String hash;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF263238).withAlpha(26),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        hash,
        style: const TextStyle(
          color: Color(0xFF263238),
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
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

class _AuditEntry {
  const _AuditEntry({
    required this.actor,
    required this.action,
    required this.module,
    required this.severity,
    required this.status,
    required this.timestamp,
    required this.hash,
  });

  final String actor;
  final String action;
  final String module;
  final _Severity severity;
  final _LogStatus status;
  final String timestamp;
  final String hash;

  _AuditEntry copyWith({
    String? actor,
    String? action,
    String? module,
    _Severity? severity,
    _LogStatus? status,
    String? timestamp,
    String? hash,
  }) {
    return _AuditEntry(
      actor: actor ?? this.actor,
      action: action ?? this.action,
      module: module ?? this.module,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      hash: hash ?? this.hash,
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

enum _LogStatus { verified, review, flagged }

extension on _Severity {
  String get label {
    switch (this) {
      case _Severity.high:
        return 'High';
      case _Severity.medium:
        return 'Medium';
      case _Severity.low:
        return 'Low';
    }
  }
}

const List<_AuditEntry> _seedEntries = <_AuditEntry>[
  _AuditEntry(
    actor: 'admin.yusuf@askislam.org',
    action: 'Approved scholar verification',
    module: 'Scholar Verify',
    severity: _Severity.medium,
    status: _LogStatus.verified,
    timestamp: '2026-02-21 13:21 UTC',
    hash: '0xA4F2C9',
  ),
  _AuditEntry(
    actor: 'admin.amina@askislam.org',
    action: 'Published charity campaign',
    module: 'Charity',
    severity: _Severity.high,
    status: _LogStatus.verified,
    timestamp: '2026-02-21 12:54 UTC',
    hash: '0xC1D8B7',
  ),
  _AuditEntry(
    actor: 'admin.kareem@askislam.org',
    action: 'Role update on teacher account',
    module: 'Teaching',
    severity: _Severity.high,
    status: _LogStatus.review,
    timestamp: '2026-02-21 11:38 UTC',
    hash: '0xF9312E',
  ),
  _AuditEntry(
    actor: 'admin.noor@askislam.org',
    action: 'Edited tafseer entry metadata',
    module: 'Content Control',
    severity: _Severity.low,
    status: _LogStatus.verified,
    timestamp: '2026-02-21 10:12 UTC',
    hash: '0x88B40D',
  ),
];
