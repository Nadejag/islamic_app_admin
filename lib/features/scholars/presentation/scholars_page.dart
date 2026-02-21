import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/admin_scaffold.dart';
import '../../../shared/widgets/app_data_table.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../shared/widgets/stat_card.dart';
import '../../../shared/widgets/workflow_card.dart';

class ScholarsPage extends StatefulWidget {
  const ScholarsPage({super.key});

  @override
  State<ScholarsPage> createState() => _ScholarsPageState();
}

class _ScholarsPageState extends State<ScholarsPage> {
  final _searchCtl = TextEditingController();
  bool _pending = true;
  bool _review = false;
  bool _approved = false;
  bool _rejected = false;

  late final List<_ScholarRequest> _requests = [
    const _ScholarRequest(
      name: 'Dr. Yusuf Al-Hanafi',
      specialization: 'Aqidah & Fiqh',
      docs: 4,
      submitted: '2h ago',
      status: _ScholarStatus.pending,
      badgeReady: false,
      askAccess: false,
      riskScore: 14,
    ),
    const _ScholarRequest(
      name: 'Shaykha Maryam Noor',
      specialization: 'Hadith Sciences',
      docs: 5,
      submitted: '5h ago',
      status: _ScholarStatus.review,
      badgeReady: false,
      askAccess: false,
      riskScore: 9,
    ),
    const _ScholarRequest(
      name: 'Imam Zayd Rahman',
      specialization: 'Quran Tafseer',
      docs: 6,
      submitted: 'Yesterday',
      status: _ScholarStatus.approved,
      badgeReady: true,
      askAccess: true,
      riskScore: 4,
    ),
    const _ScholarRequest(
      name: 'Ustadh Kareem Ali',
      specialization: 'Comparative Fiqh',
      docs: 3,
      submitted: '3d ago',
      status: _ScholarStatus.rejected,
      badgeReady: false,
      askAccess: false,
      riskScore: 37,
    ),
  ];

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  List<_ScholarRequest> get _filtered {
    final q = _searchCtl.text.trim().toLowerCase();
    return _requests.where((r) {
      final matchQ = q.isEmpty ||
          r.name.toLowerCase().contains(q) ||
          r.specialization.toLowerCase().contains(q);
      if (!matchQ) return false;
      if (_pending && r.status != _ScholarStatus.pending) return false;
      if (_review && r.status != _ScholarStatus.review) return false;
      if (_approved && r.status != _ScholarStatus.approved) return false;
      if (_rejected && r.status != _ScholarStatus.rejected) return false;
      return true;
    }).toList();
  }

  void _update(_ScholarRequest oldItem, _ScholarRequest newItem) {
    final idx = _requests.indexOf(oldItem);
    if (idx < 0) return;
    setState(() => _requests[idx] = newItem);
  }

  void _approve(_ScholarRequest r) {
    _update(
      r,
      r.copyWith(
        status: _ScholarStatus.approved,
        badgeReady: true,
        askAccess: true,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${r.name} approved and access granted.')),
    );
  }

  void _reject(_ScholarRequest r) {
    _update(
      r,
      r.copyWith(
        status: _ScholarStatus.rejected,
        badgeReady: false,
        askAccess: false,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${r.name} rejected.')),
    );
  }

  void _needInfo(_ScholarRequest r) {
    _update(r, r.copyWith(status: _ScholarStatus.review));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Requested more info from ${r.name}.')),
    );
  }

  void _toggleBadge(_ScholarRequest r) {
    _update(r, r.copyWith(badgeReady: !r.badgeReady));
  }

  void _toggleAccess(_ScholarRequest r) {
    final canGrant = r.status == _ScholarStatus.approved && r.badgeReady;
    if (!canGrant) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Approve and update badge before granting Ask access.'),
        ),
      );
      return;
    }
    _update(r, r.copyWith(askAccess: !r.askAccess));
  }

  Future<void> _previewDocs(_ScholarRequest r) async {
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Documents - ${r.name}'),
        content: Text(
            'Total uploaded documents: ${r.docs}\nSpecialization: ${r.specialization}\nRisk score: ${r.riskScore}'),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _openAudit(_ScholarRequest r) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Audit Trail: ${r.name}',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Current status: ${r.status.name}'),
            Text('Badge: ${r.badgeReady ? 'Updated' : 'Pending'}'),
            Text('Ask Access: ${r.askAccess ? 'Granted' : 'Blocked'}'),
            Text('Submitted: ${r.submitted}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final requests = _filtered;
    return AdminScaffold(
      title: 'Scholar Verification',
      body: ListView(
        cacheExtent: 900,
        children: [
          const _Entrance(delayMs: 20, child: _VerificationHero()),
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
                        label: 'Pending Verifications',
                        numericValue: 18,
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
                        label: 'Approved This Month',
                        numericValue: 42,
                        icon: Icons.verified_outlined,
                        trendLabel: '+11%',
                        accentColor: Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: const _Entrance(
                      delayMs: 160,
                      child: StatCard(
                        label: 'Rejected This Month',
                        numericValue: 6,
                        icon: Icons.cancel_outlined,
                        trendLabel: '-2',
                        accentColor: Color(0xFFD84315),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          _Entrance(
            delayMs: 320,
            child: SectionCard(
              title: 'Verification Controls',
              action: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _searchCtl.clear();
                    _pending = true;
                    _review = false;
                    _approved = false;
                    _rejected = false;
                  });
                },
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Sync Queue'),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      SizedBox(
                        width: 260,
                        child: TextField(
                          controller: _searchCtl,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                              labelText: 'Search scholar/email'),
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
                          label: const Text('Rejected'),
                          selected: _rejected,
                          onSelected: (v) => setState(() => _rejected = v)),
                      FilledButton.icon(
                        onPressed: () => setState(() {}),
                        icon: const Icon(Icons.filter_alt_outlined, size: 18),
                        label: const Text('Apply'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                                content: Text(
                                    'Exported ${requests.length} records.'))),
                        icon: const Icon(Icons.download_outlined, size: 18),
                        label: const Text('Export'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _Entrance(
            delayMs: 420,
            child: SectionCard(
              title: 'Scholar Requests',
              action: Text('${requests.length} records',
                  style: Theme.of(context).textTheme.bodySmall),
              child: AppDataTable(
                columns: const [
                  DataColumn(label: Text('Scholar')),
                  DataColumn(label: Text('Specialization')),
                  DataColumn(label: Text('Docs')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Badge')),
                  DataColumn(label: Text('Ask Access')),
                  DataColumn(label: Text('Risk')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: requests
                    .map(
                      (r) => DataRow(
                        cells: [
                          DataCell(
                            SizedBox(
                              width: 230,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(r.name,
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
                          DataCell(Text(r.specialization)),
                          DataCell(TextButton(
                              onPressed: () => _previewDocs(r),
                              child: Text('Preview (${r.docs})'))),
                          DataCell(_ScholarStatusTag(status: r.status)),
                          DataCell(_AccessTag(
                              label: r.badgeReady ? 'Updated' : 'Pending',
                              enabled: r.badgeReady)),
                          DataCell(_AccessTag(
                              label: r.askAccess ? 'Granted' : 'Blocked',
                              enabled: r.askAccess)),
                          DataCell(
                            SizedBox(
                              width: 120,
                              child: LinearProgressIndicator(
                                value: (100 - r.riskScore) / 100,
                                minHeight: 9,
                                borderRadius: BorderRadius.circular(99),
                                backgroundColor: const Color(0xFFE2EBE7),
                              ),
                            ),
                          ),
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
                                    onPressed: () => _needInfo(r),
                                    child: const Text('Need Info')),
                                PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'badge') _toggleBadge(r);
                                    if (value == 'access') _toggleAccess(r);
                                    if (value == 'audit') _openAudit(r);
                                  },
                                  itemBuilder: (_) => const [
                                    PopupMenuItem(
                                        value: 'badge',
                                        child: Text('Update Badge')),
                                    PopupMenuItem(
                                        value: 'access',
                                        child: Text('Grant Ask Access')),
                                    PopupMenuItem(
                                        value: 'audit',
                                        child: Text('Audit Trail')),
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
            delayMs: 520,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final vertical = constraints.maxWidth < 980;
                final w = vertical
                    ? constraints.maxWidth
                    : (constraints.maxWidth - 12) / 2;
                final cards = [
                  SizedBox(
                    width: w,
                    child: SectionCard(
                      title: 'Approval vs Rejection Trend',
                      child: SizedBox(
                        height: 220,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              getDrawingHorizontalLine: (_) => const FlLine(
                                  color: Color(0x160B6B46), strokeWidth: 1),
                            ),
                            borderData: FlBorderData(show: false),
                            titlesData: const FlTitlesData(
                              topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: const [
                                  FlSpot(1, 8),
                                  FlSpot(2, 10),
                                  FlSpot(3, 14),
                                  FlSpot(4, 13),
                                  FlSpot(5, 17),
                                  FlSpot(6, 20),
                                ],
                                color: const Color(0xFF2E7D32),
                                isCurved: true,
                                barWidth: 3,
                                dotData: const FlDotData(show: false),
                              ),
                              LineChartBarData(
                                spots: const [
                                  FlSpot(1, 3),
                                  FlSpot(2, 2),
                                  FlSpot(3, 4),
                                  FlSpot(4, 3),
                                  FlSpot(5, 2),
                                  FlSpot(6, 1),
                                ],
                                color: const Color(0xFFD84315),
                                isCurved: true,
                                barWidth: 3,
                                dotData: const FlDotData(show: false),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: w,
                    child: SectionCard(
                      title: 'Pipeline Stage Load',
                      child: SizedBox(
                        height: 220,
                        child: PieChart(
                          PieChartData(
                            centerSpaceRadius: 40,
                            sectionsSpace: 3,
                            sections: [
                              PieChartSectionData(
                                value: 48,
                                title: 'Pending',
                                color: const Color(0xFFF9A825),
                                titleStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              PieChartSectionData(
                                value: 34,
                                title: 'Review',
                                color: const Color(0xFF1565C0),
                                titleStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              PieChartSectionData(
                                value: 18,
                                title: 'Done',
                                color: const Color(0xFF2E7D32),
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
                    children: [cards[0], const SizedBox(height: 12), cards[1]],
                  );
                }
                return Row(
                  children: [cards[0], const SizedBox(width: 12), cards[1]],
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          const _Entrance(
            delayMs: 640,
            child: WorkflowCard(
              title: 'Scholar Verification Workflow',
              steps: [
                'Scholar submits verification with identity and certificates',
                'Admin reviews specialization, documents, and trust checks',
                'Admin approves or rejects request with a clear reason',
                'On approval, scholar badge is updated automatically',
                'Ask a Scholar access is granted only after badge update',
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _VerificationHero extends StatelessWidget {
  const _VerificationHero();

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
            'Scholar Verification Console',
            style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4),
          ),
          SizedBox(height: 8),
          Text(
            'Submit -> Approve/Reject -> Badge Update -> Ask a Scholar Access. End-to-end moderation with governance visibility.',
            style: TextStyle(color: Color(0xF0FFFFFF), height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _ScholarStatusTag extends StatelessWidget {
  const _ScholarStatusTag({required this.status});

  final _ScholarStatus status;

  @override
  Widget build(BuildContext context) {
    late final String label;
    late final Color bg;
    late final Color fg;
    switch (status) {
      case _ScholarStatus.pending:
        label = 'Pending';
        bg = const Color(0x16F9A825);
        fg = const Color(0xFF9A6A00);
      case _ScholarStatus.review:
        label = 'In Review';
        bg = const Color(0x161565C0);
        fg = const Color(0xFF1565C0);
      case _ScholarStatus.approved:
        label = 'Approved';
        bg = const Color(0x1E2E7D32);
        fg = const Color(0xFF2E7D32);
      case _ScholarStatus.rejected:
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
              TextStyle(fontSize: 12, color: fg, fontWeight: FontWeight.w600)),
    );
  }
}

class _AccessTag extends StatelessWidget {
  const _AccessTag({
    required this.label,
    required this.enabled,
  });

  final String label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: enabled ? const Color(0x1E0B6B46) : const Color(0x15000000),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: enabled ? const Color(0xFF0B6B46) : const Color(0xFF4B5D55),
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

class _ScholarRequest {
  const _ScholarRequest({
    required this.name,
    required this.specialization,
    required this.docs,
    required this.submitted,
    required this.status,
    required this.badgeReady,
    required this.askAccess,
    required this.riskScore,
  });

  final String name;
  final String specialization;
  final int docs;
  final String submitted;
  final _ScholarStatus status;
  final bool badgeReady;
  final bool askAccess;
  final int riskScore;

  _ScholarRequest copyWith({
    String? name,
    String? specialization,
    int? docs,
    String? submitted,
    _ScholarStatus? status,
    bool? badgeReady,
    bool? askAccess,
    int? riskScore,
  }) {
    return _ScholarRequest(
      name: name ?? this.name,
      specialization: specialization ?? this.specialization,
      docs: docs ?? this.docs,
      submitted: submitted ?? this.submitted,
      status: status ?? this.status,
      badgeReady: badgeReady ?? this.badgeReady,
      askAccess: askAccess ?? this.askAccess,
      riskScore: riskScore ?? this.riskScore,
    );
  }
}

enum _ScholarStatus { pending, review, approved, rejected }
