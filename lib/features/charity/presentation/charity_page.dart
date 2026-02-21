import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/admin_scaffold.dart';
import '../../../shared/widgets/app_data_table.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../shared/widgets/stat_card.dart';
import '../../../shared/widgets/workflow_card.dart';

class CharityPage extends StatefulWidget {
  const CharityPage({super.key});

  @override
  State<CharityPage> createState() => _CharityPageState();
}

class _CharityPageState extends State<CharityPage> {
  final _searchCtl = TextEditingController();
  bool _pending = true;
  bool _review = false;
  bool _approved = false;
  bool _visible = false;

  late final List<_CharityRequest> _requests = [
    const _CharityRequest(
      project: 'Clean Water - Sindh',
      category: 'Water',
      target: 30000,
      raised: 9800,
      submitted: '2h ago',
      status: _ApprovalStatus.pending,
      visibleInSeekers: false,
    ),
    const _CharityRequest(
      project: 'Ramadan Food Drive - Karachi',
      category: 'Food',
      target: 45000,
      raised: 21200,
      submitted: '5h ago',
      status: _ApprovalStatus.review,
      visibleInSeekers: false,
    ),
    const _CharityRequest(
      project: 'Emergency Medical Support',
      category: 'Medical',
      target: 60000,
      raised: 43800,
      submitted: 'Yesterday',
      status: _ApprovalStatus.approved,
      visibleInSeekers: true,
    ),
    const _CharityRequest(
      project: 'Orphan Education Grant',
      category: 'Education',
      target: 25000,
      raised: 13400,
      submitted: '2d ago',
      status: _ApprovalStatus.approved,
      visibleInSeekers: true,
    ),
  ];

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  List<_CharityRequest> get _filtered {
    final q = _searchCtl.text.trim().toLowerCase();
    return _requests.where((r) {
      final matchQ = q.isEmpty ||
          r.project.toLowerCase().contains(q) ||
          r.category.toLowerCase().contains(q);
      if (!matchQ) return false;
      if (_pending && r.status != _ApprovalStatus.pending) return false;
      if (_review && r.status != _ApprovalStatus.review) return false;
      if (_approved && r.status != _ApprovalStatus.approved) return false;
      if (_visible && !r.visibleInSeekers) return false;
      return true;
    }).toList();
  }

  void _update(_CharityRequest oldItem, _CharityRequest newItem) {
    final idx = _requests.indexOf(oldItem);
    if (idx < 0) return;
    setState(() => _requests[idx] = newItem);
  }

  void _approve(_CharityRequest r) {
    _update(r,
        r.copyWith(status: _ApprovalStatus.approved, visibleInSeekers: true));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${r.project} approved and published.')),
    );
  }

  void _reject(_CharityRequest r) {
    _update(r,
        r.copyWith(status: _ApprovalStatus.rejected, visibleInSeekers: false));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${r.project} rejected.')),
    );
  }

  void _togglePublish(_CharityRequest r) {
    final canPublish = r.status == _ApprovalStatus.approved;
    if (!canPublish) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Approve campaign before publishing.')),
      );
      return;
    }
    _update(r, r.copyWith(visibleInSeekers: !r.visibleInSeekers));
  }

  void _track(_CharityRequest r) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tracking: ${r.project}',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Target: \$${r.target.toStringAsFixed(0)}'),
            Text('Raised: \$${r.raised.toStringAsFixed(0)}'),
            Text(
                'Progress: ${(r.raised / r.target * 100).toStringAsFixed(1)}%'),
            Text('Status: ${r.status.name}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final requests = _filtered;
    return AdminScaffold(
      title: 'Charity Management',
      body: ListView(
        cacheExtent: 900,
        children: [
          const _Entrance(delayMs: 20, child: _CharityHero()),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final narrow = constraints.maxWidth < 850;
              final width = narrow
                  ? constraints.maxWidth
                  : (constraints.maxWidth - 24) / 3;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: width,
                    child: const _Entrance(
                      delayMs: 80,
                      child: StatCard(
                        label: 'Pending Requests',
                        numericValue: 11,
                        icon: Icons.pending_actions_outlined,
                        trendLabel: 'Needs review',
                        accentColor: Color(0xFFF9A825),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: const _Entrance(
                      delayMs: 120,
                      child: StatCard(
                        label: 'Approved Campaigns',
                        numericValue: 38,
                        icon: Icons.verified_outlined,
                        trendLabel: '+7',
                        accentColor: Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: const _Entrance(
                      delayMs: 160,
                      child: StatCard(
                        label: 'Visible in Donation Seekers',
                        numericValue: 33,
                        icon: Icons.visibility_outlined,
                        trendLabel: '+5',
                        accentColor: Color(0xFF1565C0),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          _Entrance(
            delayMs: 340,
            child: SectionCard(
              title: 'Approval Controls',
              action: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _searchCtl.clear();
                    _pending = true;
                    _review = false;
                    _approved = false;
                    _visible = false;
                  });
                },
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Refresh Queue'),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _searchCtl,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        labelText: 'Search campaign/requester',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilterChip(
                          label: const Text('Pending'),
                          selected: _pending,
                          onSelected: (v) => setState(() => _pending = v)),
                      FilterChip(
                          label: const Text('In Review'),
                          selected: _review,
                          onSelected: (v) => setState(() => _review = v)),
                      FilterChip(
                          label: const Text('Approved'),
                          selected: _approved,
                          onSelected: (v) => setState(() => _approved = v)),
                      FilterChip(
                          label: const Text('Visible Seekers'),
                          selected: _visible,
                          onSelected: (v) => setState(() => _visible = v)),
                      FilledButton.icon(
                        onPressed: () => setState(() {}),
                        icon: const Icon(Icons.filter_alt_outlined, size: 18),
                        label: const Text('Apply'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () =>
                            ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Exported ${requests.length} campaigns.')),
                        ),
                        icon:
                            const Icon(Icons.file_download_outlined, size: 18),
                        label: const Text('Export CSV'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _Entrance(
            delayMs: 440,
            child: SectionCard(
              title: 'Donation Requests',
              action: Text('${requests.length} records',
                  style: Theme.of(context).textTheme.bodySmall),
              child: AppDataTable(
                columns: const [
                  DataColumn(label: Text('Campaign')),
                  DataColumn(label: Text('Category')),
                  DataColumn(label: Text('Target')),
                  DataColumn(label: Text('Raised')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Donation Seekers')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: requests
                    .map(
                      (r) => DataRow(
                        cells: [
                          DataCell(
                            SizedBox(
                              width: 250,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(r.project,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  Text('Submitted ${r.submitted}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                ],
                              ),
                            ),
                          ),
                          DataCell(Text(r.category)),
                          DataCell(Text('\$${r.target.toStringAsFixed(0)}')),
                          DataCell(
                            SizedBox(
                              width: 130,
                              child: LinearProgressIndicator(
                                value: r.raised / r.target,
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(99),
                                backgroundColor: const Color(0xFFE2EBE7),
                              ),
                            ),
                          ),
                          DataCell(_ApprovalTag(status: r.status)),
                          DataCell(_VisibilityTag(visible: r.visibleInSeekers)),
                          DataCell(
                            Wrap(
                              spacing: 6,
                              children: [
                                FilledButton(
                                    onPressed: () => _approve(r),
                                    child: const Text('Approve')),
                                OutlinedButton(
                                    onPressed: () => _reject(r),
                                    child: const Text('Reject')),
                                OutlinedButton(
                                  onPressed: () => _togglePublish(r),
                                  child: Text(
                                      r.visibleInSeekers ? 'Hide' : 'Publish'),
                                ),
                                PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'track') _track(r);
                                    if (value == 'audit') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Open Audit Logs from sidebar.')),
                                      );
                                    }
                                    if (value == 'flag') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Fraud review flag added.')),
                                      );
                                    }
                                  },
                                  itemBuilder: (_) => const [
                                    PopupMenuItem(
                                        value: 'track',
                                        child: Text('Track Donations')),
                                    PopupMenuItem(
                                        value: 'audit',
                                        child: Text('Audit Logs')),
                                    PopupMenuItem(
                                        value: 'flag',
                                        child: Text('Fraud Check')),
                                  ],
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
          _Entrance(
            delayMs: 560,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final vertical = constraints.maxWidth < 980;
                final width = vertical
                    ? constraints.maxWidth
                    : (constraints.maxWidth - 12) / 2;
                if (vertical) {
                  return Column(
                    children: [
                      SizedBox(
                          width: width, child: const _DonationsTrendCard()),
                      const SizedBox(height: 12),
                      SizedBox(width: width, child: const _CategorySplitCard()),
                    ],
                  );
                }
                return Row(
                  children: [
                    SizedBox(width: width, child: const _DonationsTrendCard()),
                    const SizedBox(width: 12),
                    SizedBox(width: width, child: const _CategorySplitCard()),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          const _Entrance(
            delayMs: 660,
            child: WorkflowCard(
              title: 'Charity Approvals Workflow',
              steps: [
                'Donation request is submitted with proof and campaign details',
                'Admin reviews and approves or rejects the request',
                'Approved campaigns become visible in Donation Seekers',
                'Donation stream is tracked with risk and progress monitoring',
                'Impact updates are reviewed before public publishing',
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CharityHero extends StatelessWidget {
  const _CharityHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF0B6B46), Color(0xFF1A8D5A), Color(0xFF2EA36D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Charity Approval Console',
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 8),
          Text(
            'Donation requests -> admin approval -> visible in Donation Seekers -> continuous donation tracking.',
            style: TextStyle(color: Color(0xF0FFFFFF), height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _DonationsTrendCard extends StatelessWidget {
  const _DonationsTrendCard();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Donation Tracking Trend',
      child: SizedBox(
        height: 220,
        child: LineChart(
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
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(1, 20),
                  FlSpot(2, 28),
                  FlSpot(3, 34),
                  FlSpot(4, 41),
                  FlSpot(5, 52),
                  FlSpot(6, 61),
                ],
                color: const Color(0xFF0B6B46),
                isCurved: true,
                barWidth: 3.5,
                dotData: const FlDotData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategorySplitCard extends StatelessWidget {
  const _CategorySplitCard();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Donation Split by Category',
      child: SizedBox(
        height: 220,
        child: PieChart(
          PieChartData(
            centerSpaceRadius: 40,
            sectionsSpace: 3,
            sections: [
              PieChartSectionData(
                value: 38,
                title: 'Water',
                color: const Color(0xFF1D8A5D),
                titleStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
              PieChartSectionData(
                value: 33,
                title: 'Food',
                color: const Color(0xFF00A889),
                titleStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
              PieChartSectionData(
                value: 29,
                title: 'Medical',
                color: const Color(0xFF38B4A2),
                titleStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ApprovalTag extends StatelessWidget {
  const _ApprovalTag({required this.status});

  final _ApprovalStatus status;

  @override
  Widget build(BuildContext context) {
    late final String label;
    late final Color bg;
    late final Color fg;
    switch (status) {
      case _ApprovalStatus.pending:
        label = 'Pending';
        bg = const Color(0x16F9A825);
        fg = const Color(0xFF9A6A00);
      case _ApprovalStatus.review:
        label = 'In Review';
        bg = const Color(0x161565C0);
        fg = const Color(0xFF1565C0);
      case _ApprovalStatus.approved:
        label = 'Approved';
        bg = const Color(0x1E2E7D32);
        fg = const Color(0xFF2E7D32);
      case _ApprovalStatus.rejected:
        label = 'Rejected';
        bg = const Color(0x16D84315);
        fg = const Color(0xFFD84315);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(label,
          style:
              TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg)),
    );
  }
}

class _VisibilityTag extends StatelessWidget {
  const _VisibilityTag({required this.visible});

  final bool visible;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: visible ? const Color(0x1E0B6B46) : const Color(0x15000000),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        visible ? 'Visible' : 'Hidden',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: visible ? const Color(0xFF0B6B46) : const Color(0xFF4B5D55),
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
      duration: const Duration(milliseconds: 460),
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

class _CharityRequest {
  const _CharityRequest({
    required this.project,
    required this.category,
    required this.target,
    required this.raised,
    required this.submitted,
    required this.status,
    required this.visibleInSeekers,
  });

  final String project;
  final String category;
  final double target;
  final double raised;
  final String submitted;
  final _ApprovalStatus status;
  final bool visibleInSeekers;

  _CharityRequest copyWith({
    String? project,
    String? category,
    double? target,
    double? raised,
    String? submitted,
    _ApprovalStatus? status,
    bool? visibleInSeekers,
  }) {
    return _CharityRequest(
      project: project ?? this.project,
      category: category ?? this.category,
      target: target ?? this.target,
      raised: raised ?? this.raised,
      submitted: submitted ?? this.submitted,
      status: status ?? this.status,
      visibleInSeekers: visibleInSeekers ?? this.visibleInSeekers,
    );
  }
}

enum _ApprovalStatus { pending, review, approved, rejected }
