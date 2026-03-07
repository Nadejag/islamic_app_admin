import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/admin_scaffold.dart';
import '../../../shared/widgets/app_data_table.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../shared/widgets/stat_card.dart';
import '../../../shared/widgets/workflow_card.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final _searchCtl = TextEditingController();
  bool _active = true;
  bool _banned = false;
  bool _unverified = false;
  bool _highRisk = false;

  late final List<_UserRecord> _records = [
    const _UserRecord(
      name: 'Ahmed Khan',
      email: 'ahmed@mail.com',
      role: 'Learner',
      status: _UserStatus.active,
      verified: true,
      lastActive: '2 min ago',
      score: 92,
    ),
    const _UserRecord(
      name: 'Fatima Ali',
      email: 'fatima@mail.com',
      role: 'Teacher',
      status: _UserStatus.active,
      verified: true,
      lastActive: '18 min ago',
      score: 89,
    ),
    const _UserRecord(
      name: 'Yusuf Rahman',
      email: 'yusuf@mail.com',
      role: 'Learner',
      status: _UserStatus.restricted,
      verified: false,
      lastActive: 'Yesterday',
      score: 48,
    ),
    const _UserRecord(
      name: 'Aisha Noor',
      email: 'aisha@mail.com',
      role: 'Scholar Candidate',
      status: _UserStatus.review,
      verified: false,
      lastActive: '1 hour ago',
      score: 73,
    ),
  ];

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  List<_UserRecord> get _filtered {
    final q = _searchCtl.text.trim().toLowerCase();
    return _records.where((u) {
      final matchQ = q.isEmpty ||
          u.name.toLowerCase().contains(q) ||
          u.email.toLowerCase().contains(q);
      if (!matchQ) return false;
      if (_active && u.status != _UserStatus.active) return false;
      if (_banned && u.status != _UserStatus.banned) return false;
      if (_unverified && u.verified) return false;
      if (_highRisk && u.score >= 55) return false;
      return true;
    }).toList();
  }

  void _refreshFilters() {
    setState(() {
      _searchCtl.clear();
      _active = true;
      _banned = false;
      _unverified = false;
      _highRisk = false;
    });
  }

  void _updateRecord(_UserRecord oldRecord, _UserRecord newRecord) {
    final idx = _records.indexOf(oldRecord);
    if (idx < 0) return;
    setState(() => _records[idx] = newRecord);
  }

  void _toggleVerify(_UserRecord u) {
    _updateRecord(u, u.copyWith(verified: !u.verified));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(u.verified ? 'User unverified.' : 'User verified.')),
    );
  }

  void _toggleBan(_UserRecord u) {
    final next = u.status == _UserStatus.banned
        ? u.copyWith(status: _UserStatus.active)
        : u.copyWith(status: _UserStatus.banned);
    _updateRecord(u, next);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            u.status == _UserStatus.banned ? 'User restored.' : 'User banned.'),
      ),
    );
  }

  Future<void> _editUser(_UserRecord u) async {
    final nameCtl = TextEditingController(text: u.name);
    final roleCtl = TextEditingController(text: u.role);
    final scoreCtl = TextEditingController(text: '${u.score}');
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit User'),
        content: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameCtl,
                  decoration: const InputDecoration(labelText: 'Name')),
              const SizedBox(height: 8),
              TextField(
                  controller: roleCtl,
                  decoration: const InputDecoration(labelText: 'Role')),
              const SizedBox(height: 8),
              TextField(
                controller: scoreCtl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Activity Score'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save')),
        ],
      ),
    );
    if (ok == true) {
      final score =
          (int.tryParse(scoreCtl.text.trim()) ?? u.score).clamp(1, 100);
      _updateRecord(
        u,
        u.copyWith(
          name: nameCtl.text.trim().isEmpty ? u.name : nameCtl.text.trim(),
          role: roleCtl.text.trim().isEmpty ? u.role : roleCtl.text.trim(),
          score: score,
        ),
      );
    }
  }

  void _showMetrics(_UserRecord u) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Metrics: ${u.name}',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Activity score: ${u.score}%'),
            Text('Verification: ${u.verified ? 'Verified' : 'Pending'}'),
            Text('Last active: ${u.lastActive}'),
            Text('Risk: ${u.score < 55 ? 'High' : 'Normal'}'),
          ],
        ),
      ),
    );
  }

  Future<void> _showNotes(_UserRecord u) async {
    final ctl = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Admin Notes - ${u.name}'),
        content: TextField(
          controller: ctl,
          maxLines: 4,
          decoration: const InputDecoration(labelText: 'Write note'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Save')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final records = _filtered;
    return AdminScaffold(
      title: 'Users Management',
      body: ListView(
        cacheExtent: 900,
        children: [
          const _Entrance(delayMs: 10, child: _UsersHero()),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, c) {
              final isNarrow = c.maxWidth < 850;
              final w = isNarrow ? c.maxWidth : (c.maxWidth - 24) / 3;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                      width: w,
                      child: const _Entrance(
                          delayMs: 90,
                          child: StatCard(
                              label: 'Total Users',
                              numericValue: 12450,
                              icon: Icons.group_outlined,
                              trendLabel: '+8.4%'))),
                  SizedBox(
                      width: w,
                      child: const _Entrance(
                          delayMs: 130,
                          child: StatCard(
                              label: 'Verified Users',
                              numericValue: 9672,
                              icon: Icons.verified_user_outlined,
                              trendLabel: '+4.2%',
                              accentColor: Color(0xFF2E7D32)))),
                  SizedBox(
                      width: w,
                      child: const _Entrance(
                          delayMs: 170,
                          child: StatCard(
                              label: 'Restricted/Banned',
                              numericValue: 184,
                              icon: Icons.gpp_bad_outlined,
                              trendLabel: '-12',
                              accentColor: Color(0xFFD84315)))),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          _Entrance(
            delayMs: 320,
            child: SectionCard(
              title: 'Filters & Controls',
              action: OutlinedButton.icon(
                  onPressed: _refreshFilters,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Refresh')),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      SizedBox(
                        width: 280,
                        child: TextField(
                          controller: _searchCtl,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                              labelText: 'Search name/email/UID'),
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
                          label: const Text('Active'),
                          selected: _active,
                          onSelected: (v) => setState(() => _active = v)),
                      FilterChip(
                          label: const Text('Banned'),
                          selected: _banned,
                          onSelected: (v) => setState(() => _banned = v)),
                      FilterChip(
                          label: const Text('Unverified'),
                          selected: _unverified,
                          onSelected: (v) => setState(() => _unverified = v)),
                      FilterChip(
                          label: const Text('High Risk'),
                          selected: _highRisk,
                          onSelected: (v) => setState(() => _highRisk = v)),
                      FilledButton.icon(
                          onPressed: () => setState(() {}),
                          icon: const Icon(Icons.filter_alt_outlined, size: 18),
                          label: const Text('Apply Filters')),
                      OutlinedButton.icon(
                        onPressed: () => ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                                content: Text(
                                    'Exported ${records.length} users to CSV.'))),
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
            delayMs: 420,
            child: SectionCard(
              title: 'Users Directory',
              action: Text('${records.length} shown',
                  style: Theme.of(context).textTheme.bodySmall),
              child: AppDataTable(
                columns: const [
                  DataColumn(label: Text('User')),
                  DataColumn(label: Text('Role')),
                  DataColumn(label: Text('Verification')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Last Active')),
                  DataColumn(label: Text('Activity Score')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: records
                    .map((u) => DataRow(cells: [
                          DataCell(SizedBox(
                              width: 240,
                              child: Row(children: [
                                CircleAvatar(
                                    radius: 18,
                                    backgroundColor:
                                        const Color(0xFF0B6B46).withAlpha(24),
                                    child: Text(u.name[0],
                                        style: const TextStyle(
                                            color: Color(0xFF0B6B46),
                                            fontWeight: FontWeight.w700))),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Text(u.name,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600)),
                                      Text(u.email,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                    ])),
                              ]))),
                          DataCell(Text(u.role)),
                          DataCell(_BoolTag(
                              label: u.verified ? 'Verified' : 'Pending',
                              value: u.verified)),
                          DataCell(_StatusTag(status: u.status)),
                          DataCell(Text(u.lastActive)),
                          DataCell(SizedBox(
                              width: 120,
                              child: LinearProgressIndicator(
                                  value: u.score / 100,
                                  minHeight: 9,
                                  borderRadius: BorderRadius.circular(99),
                                  backgroundColor: const Color(0xFFE2EBE7)))),
                          DataCell(Wrap(spacing: 6, children: [
                            OutlinedButton(
                                onPressed: () => _editUser(u),
                                child: const Text('Edit')),
                            OutlinedButton(
                                onPressed: () => _toggleVerify(u),
                                child:
                                    Text(u.verified ? 'Unverify' : 'Verify')),
                            FilledButton.tonal(
                                onPressed: () => _toggleBan(u),
                                child: Text(u.status == _UserStatus.banned
                                    ? 'Restore'
                                    : 'Ban')),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'metrics') _showMetrics(u);
                                if (value == 'logs') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Open Audit Logs from sidebar.')),
                                  );
                                }
                                if (value == 'notes') _showNotes(u);
                              },
                              itemBuilder: (_) => const [
                                PopupMenuItem(
                                    value: 'metrics',
                                    child: Text('View Metrics')),
                                PopupMenuItem(
                                    value: 'logs', child: Text('Audit Logs')),
                                PopupMenuItem(
                                    value: 'notes', child: Text('Admin Notes')),
                              ],
                            ),
                          ])),
                        ]))
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _Entrance(
            delayMs: 520,
            child: LayoutBuilder(
              builder: (context, c) {
                final vertical = c.maxWidth < 980;
                final itemW = vertical ? c.maxWidth : (c.maxWidth - 12) / 2;
                final cards = [
                  SizedBox(
                    width: itemW,
                    child: SectionCard(
                      title: 'Daily Sign-in Trend',
                      child: SizedBox(
                        height: 220,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                getDrawingHorizontalLine: (_) => const FlLine(
                                    color: Color(0x160B6B46), strokeWidth: 1)),
                            borderData: FlBorderData(show: false),
                            titlesData: const FlTitlesData(
                                topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false))),
                            lineBarsData: [
                              LineChartBarData(
                                spots: const [
                                  FlSpot(1, 240),
                                  FlSpot(2, 260),
                                  FlSpot(3, 300),
                                  FlSpot(4, 280),
                                  FlSpot(5, 340),
                                  FlSpot(6, 390),
                                  FlSpot(7, 420)
                                ],
                                color: const Color(0xFF0B6B46),
                                barWidth: 3.5,
                                isCurved: true,
                                dotData: const FlDotData(show: false),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: itemW,
                    child: SectionCard(
                      title: 'Risk Segments',
                      child: SizedBox(
                        height: 220,
                        child: BarChart(
                          BarChartData(
                            borderData: FlBorderData(show: false),
                            gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                getDrawingHorizontalLine: (_) => const FlLine(
                                    color: Color(0x160B6B46), strokeWidth: 1)),
                            titlesData: const FlTitlesData(
                                topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false))),
                            barGroups: [
                              BarChartGroupData(x: 0, barRods: [
                                BarChartRodData(
                                    toY: 18, color: const Color(0xFF2E7D32))
                              ]),
                              BarChartGroupData(x: 1, barRods: [
                                BarChartRodData(
                                    toY: 11, color: const Color(0xFFF9A825))
                              ]),
                              BarChartGroupData(x: 2, barRods: [
                                BarChartRodData(
                                    toY: 6, color: const Color(0xFFD84315))
                              ]),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ];
                if (vertical) {
                  return Column(children: [
                    cards[0],
                    const SizedBox(height: 12),
                    cards[1]
                  ]);
                }
                return Row(
                    children: [cards[0], const SizedBox(width: 12), cards[1]]);
              },
            ),
          ),
          const SizedBox(height: 12),
          const _Entrance(
            delayMs: 660,
            child: WorkflowCard(
              title: 'Users Management Workflow',
              steps: [
                'View all users with smart filters and activity metrics',
                'Edit profile metadata and user roles when required',
                'Verify or unverify users based on document/audit checks',
                'Ban, restore, or restrict users with clear admin notes',
                'Track engagement, sign-in trend, and risk indicators daily',
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UsersHero extends StatelessWidget {
  const _UsersHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF0B6B46), Color(0xFF1A8D5A), Color(0xFF28A86A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Users Management',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'View all users, edit accounts, ban/verify, and track activity metrics in one professional workflow.',
            style: TextStyle(color: Color(0xF0FFFFFF), height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _BoolTag extends StatelessWidget {
  const _BoolTag({required this.label, required this.value});

  final String label;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: value ? const Color(0x1E2E7D32) : const Color(0x14F9A825),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: value ? const Color(0xFF2E7D32) : const Color(0xFF9C6A00),
        ),
      ),
    );
  }
}

class _StatusTag extends StatelessWidget {
  const _StatusTag({required this.status});

  final _UserStatus status;

  @override
  Widget build(BuildContext context) {
    late final Color bg;
    late final Color fg;
    late final String label;

    switch (status) {
      case _UserStatus.active:
        bg = const Color(0x1E0B6B46);
        fg = const Color(0xFF0B6B46);
        label = 'Active';
      case _UserStatus.review:
        bg = const Color(0x16F9A825);
        fg = const Color(0xFF9A6A00);
        label = 'In Review';
      case _UserStatus.restricted:
        bg = const Color(0x16D84315);
        fg = const Color(0xFFB33C1A);
        label = 'Restricted';
      case _UserStatus.banned:
        bg = const Color(0x1FD32F2F);
        fg = const Color(0xFFB71C1C);
        label = 'Banned';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg),
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
        duration: const Duration(milliseconds: 400),
        child: widget.child,
      ),
    );
  }
}

class _UserRecord {
  const _UserRecord({
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.verified,
    required this.lastActive,
    required this.score,
  });

  final String name;
  final String email;
  final String role;
  final _UserStatus status;
  final bool verified;
  final String lastActive;
  final int score;

  _UserRecord copyWith({
    String? name,
    String? email,
    String? role,
    _UserStatus? status,
    bool? verified,
    String? lastActive,
    int? score,
  }) {
    return _UserRecord(
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      status: status ?? this.status,
      verified: verified ?? this.verified,
      lastActive: lastActive ?? this.lastActive,
      score: score ?? this.score,
    );
  }
}

enum _UserStatus { active, review, restricted, banned }
