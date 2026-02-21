import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/admin_scaffold.dart';
import '../../../shared/widgets/app_data_table.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../shared/widgets/stat_card.dart';
import '../../../shared/widgets/workflow_card.dart';

class CmsPage extends StatefulWidget {
  const CmsPage({super.key});

  @override
  State<CmsPage> createState() => _CmsPageState();
}

class _CmsPageState extends State<CmsPage> {
  final _searchCtl = TextEditingController();
  bool _draft = false;
  bool _review = true;
  bool _published = false;

  late final List<_ContentAsset> _assets = [
    const _ContentAsset(
      section: 'Quran',
      title: 'Surah Al-Baqarah metadata',
      editor: 'Admin Yusuf',
      status: _AssetStatus.published,
      version: 'v2.1.0',
      updated: '2h ago',
    ),
    const _ContentAsset(
      section: 'Tafseer',
      title: 'Ibn Kathir - Ayah 2:255',
      editor: 'Editor Maryam',
      status: _AssetStatus.review,
      version: 'v1.4.2',
      updated: '5h ago',
    ),
    const _ContentAsset(
      section: 'Ahadees',
      title: 'Sahih Bukhari #52 authenticity note',
      editor: 'Scholar Team',
      status: _AssetStatus.published,
      version: 'v3.0.4',
      updated: 'Yesterday',
    ),
    const _ContentAsset(
      section: 'Daily Inspiration',
      title: 'Friday reminder scheduled post',
      editor: 'Content Bot',
      status: _AssetStatus.draft,
      version: 'v0.9.1',
      updated: '20m ago',
    ),
  ];

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  List<_ContentAsset> get _filtered {
    final q = _searchCtl.text.trim().toLowerCase();
    return _assets.where((a) {
      final matchQ = q.isEmpty ||
          a.title.toLowerCase().contains(q) ||
          a.section.toLowerCase().contains(q) ||
          a.editor.toLowerCase().contains(q);
      if (!matchQ) return false;
      if (_draft && a.status != _AssetStatus.draft) return false;
      if (_review && a.status != _AssetStatus.review) return false;
      if (_published && a.status != _AssetStatus.published) return false;
      return true;
    }).toList();
  }

  void _updateAsset(_ContentAsset oldItem, _ContentAsset newItem) {
    final idx = _assets.indexOf(oldItem);
    if (idx < 0) return;
    setState(() => _assets[idx] = newItem);
  }

  Future<void> _addContent() async {
    final titleCtl = TextEditingController();
    String section = 'Quran';
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Content'),
        content: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: section,
                decoration: const InputDecoration(labelText: 'Section'),
                items: const [
                  'Quran',
                  'Tafseer',
                  'Ahadees',
                  'Daily Inspiration'
                ]
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => section = v ?? section,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: titleCtl,
                decoration: const InputDecoration(labelText: 'Title'),
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
              child: const Text('Create')),
        ],
      ),
    );
    if (ok == true && titleCtl.text.trim().isNotEmpty) {
      setState(() {
        _assets.insert(
          0,
          _ContentAsset(
            section: section,
            title: titleCtl.text.trim(),
            editor: 'Super Admin',
            status: _AssetStatus.draft,
            version: 'v1.0.0',
            updated: 'now',
          ),
        );
      });
    }
  }

  Future<void> _editAsset(_ContentAsset a) async {
    final titleCtl = TextEditingController(text: a.title);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Content'),
        content: TextField(
            controller: titleCtl,
            decoration: const InputDecoration(labelText: 'Title')),
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
      _updateAsset(a, a.copyWith(title: titleCtl.text.trim(), updated: 'now'));
    }
  }

  void _deleteAsset(_ContentAsset a) {
    setState(() => _assets.remove(a));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Deleted "${a.title}".')),
    );
  }

  void _newVersion(_ContentAsset a) {
    _updateAsset(
        a, a.copyWith(version: _bumpVersion(a.version), updated: 'now'));
  }

  void _setStatus(_ContentAsset a, _AssetStatus status) {
    _updateAsset(a, a.copyWith(status: status, updated: 'now'));
  }

  String _bumpVersion(String version) {
    final raw = version.replaceFirst('v', '');
    final parts = raw.split('.');
    if (parts.length != 3) return version;
    final major = int.tryParse(parts[0]) ?? 1;
    final minor = int.tryParse(parts[1]) ?? 0;
    final patch = int.tryParse(parts[2]) ?? 0;
    return 'v$major.$minor.${patch + 1}';
  }

  void _showInfo(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final assets = _filtered;
    return AdminScaffold(
      title: 'Content Control',
      body: ListView(
        cacheExtent: 900,
        children: [
          const _Entrance(delayMs: 20, child: _ContentHero()),
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
                        label: 'Quran Records',
                        numericValue: 6236,
                        icon: Icons.menu_book_outlined,
                        trendLabel: '+18',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: const _Entrance(
                      delayMs: 120,
                      child: StatCard(
                        label: 'Tafseer Entries',
                        numericValue: 1820,
                        icon: Icons.auto_stories_outlined,
                        trendLabel: '+9',
                        accentColor: Color(0xFF1565C0),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: const _Entrance(
                      delayMs: 160,
                      child: StatCard(
                        label: 'Draft Items',
                        numericValue: 27,
                        icon: Icons.edit_note_outlined,
                        trendLabel: 'Needs publish',
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
            delayMs: 340,
            child: SectionCard(
              title: 'Controller Actions',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: _addContent,
                    icon: const Icon(Icons.add_circle_outline, size: 18),
                    label: const Text('Add Content'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _showInfo(
                        'Bulk edit panel can be connected to backend batch APIs.'),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Bulk Edit'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () =>
                        _showInfo('Select records and use row Delete for now.'),
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('Delete Selected'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _showInfo(
                        'Version history is available via row menu actions.'),
                    icon: const Icon(Icons.history_toggle_off, size: 18),
                    label: const Text('Version History'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _Entrance(
            delayMs: 390,
            child: SectionCard(
              title: 'Registry Filters',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 320,
                    child: TextField(
                      controller: _searchCtl,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                          labelText: 'Search title/section/editor'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('Draft'),
                        selected: _draft,
                        onSelected: (v) => setState(() => _draft = v),
                      ),
                      FilterChip(
                        label: const Text('In Review'),
                        selected: _review,
                        onSelected: (v) => setState(() => _review = v),
                      ),
                      FilterChip(
                        label: const Text('Published'),
                        selected: _published,
                        onSelected: (v) => setState(() => _published = v),
                      ),
                      FilledButton.icon(
                        onPressed: () => setState(() {}),
                        icon: const Icon(Icons.filter_alt_outlined, size: 18),
                        label: const Text('Apply'),
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
              title: 'Content Registry',
              action: Text('${assets.length} records',
                  style: Theme.of(context).textTheme.bodySmall),
              child: AppDataTable(
                columns: const [
                  DataColumn(label: Text('Section')),
                  DataColumn(label: Text('Title')),
                  DataColumn(label: Text('Editor')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Version')),
                  DataColumn(label: Text('Updated')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: assets
                    .map(
                      (a) => DataRow(
                        cells: [
                          DataCell(Text(a.section)),
                          DataCell(
                            SizedBox(
                              width: 260,
                              child: Text(a.title,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          DataCell(Text(a.editor)),
                          DataCell(_StatusTag(status: a.status)),
                          DataCell(Text(a.version)),
                          DataCell(Text(a.updated)),
                          DataCell(
                            Wrap(
                              spacing: 6,
                              children: [
                                OutlinedButton(
                                  onPressed: () => _editAsset(a),
                                  child: const Text('Edit'),
                                ),
                                OutlinedButton(
                                  onPressed: () => _deleteAsset(a),
                                  child: const Text('Delete'),
                                ),
                                FilledButton.tonal(
                                  onPressed: () => _newVersion(a),
                                  child: const Text('New Version'),
                                ),
                                PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'preview') {
                                      _showInfo('Preview: ${a.title}');
                                    } else if (value == 'compare') {
                                      _showInfo(
                                          'Compare current ${a.version} with previous version.');
                                    } else if (value == 'rollback') {
                                      _setStatus(a, _AssetStatus.review);
                                      _showInfo(
                                          'Rolled back ${a.title} to review state.');
                                    } else if (value == 'publish') {
                                      _setStatus(a, _AssetStatus.published);
                                    } else if (value == 'archive') {
                                      _setStatus(a, _AssetStatus.archived);
                                    }
                                  },
                                  itemBuilder: (_) => const [
                                    PopupMenuItem(
                                        value: 'preview',
                                        child: Text('Preview')),
                                    PopupMenuItem(
                                        value: 'compare',
                                        child: Text('Compare Versions')),
                                    PopupMenuItem(
                                        value: 'rollback',
                                        child: Text('Rollback')),
                                    PopupMenuItem(
                                        value: 'publish',
                                        child: Text('Publish')),
                                    PopupMenuItem(
                                        value: 'archive',
                                        child: Text('Archive')),
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
            delayMs: 530,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final vertical = constraints.maxWidth < 980;
                final width = vertical
                    ? constraints.maxWidth
                    : (constraints.maxWidth - 12) / 2;
                if (vertical) {
                  return Column(
                    children: [
                      SizedBox(width: width, child: const _EditsTrendCard()),
                      const SizedBox(height: 12),
                      SizedBox(width: width, child: const _SectionSplitCard()),
                    ],
                  );
                }
                return Row(
                  children: [
                    SizedBox(width: width, child: const _EditsTrendCard()),
                    const SizedBox(width: 12),
                    SizedBox(width: width, child: const _SectionSplitCard()),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          const _Entrance(
            delayMs: 640,
            child: WorkflowCard(
              title: 'Content Control Workflow',
              steps: [
                'Manage Quran, Tafseer, Ahadees, and Daily Inspirations from one control panel',
                'Add, edit, and delete entries with proper reviewer accountability',
                'Create new versions for each update and keep change notes',
                'Use version history to compare and rollback when quality issues appear',
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentHero extends StatelessWidget {
  const _ContentHero();

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
            'Content Control Center',
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 8),
          Text(
            'Unified controller for Quran, Tafseer, Ahadees, and Daily Inspirations with strict version governance.',
            style: TextStyle(color: Color(0xF0FFFFFF), height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _EditsTrendCard extends StatelessWidget {
  const _EditsTrendCard();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Edits & Releases Trend',
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
                  FlSpot(1, 8),
                  FlSpot(2, 12),
                  FlSpot(3, 10),
                  FlSpot(4, 16),
                  FlSpot(5, 21),
                  FlSpot(6, 24),
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
    );
  }
}

class _SectionSplitCard extends StatelessWidget {
  const _SectionSplitCard();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Section Contribution',
      child: SizedBox(
        height: 220,
        child: PieChart(
          PieChartData(
            centerSpaceRadius: 40,
            sectionsSpace: 3,
            sections: [
              PieChartSectionData(
                value: 35,
                title: 'Quran',
                color: const Color(0xFF1D8A5D),
                titleStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
              PieChartSectionData(
                value: 25,
                title: 'Tafseer',
                color: const Color(0xFF00A889),
                titleStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
              PieChartSectionData(
                value: 25,
                title: 'Ahadees',
                color: const Color(0xFF38B4A2),
                titleStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
              PieChartSectionData(
                value: 15,
                title: 'Daily',
                color: const Color(0xFF1565C0),
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

class _StatusTag extends StatelessWidget {
  const _StatusTag({required this.status});

  final _AssetStatus status;

  @override
  Widget build(BuildContext context) {
    late final String label;
    late final Color bg;
    late final Color fg;
    switch (status) {
      case _AssetStatus.draft:
        label = 'Draft';
        bg = const Color(0x16F9A825);
        fg = const Color(0xFF9A6A00);
      case _AssetStatus.review:
        label = 'In Review';
        bg = const Color(0x161565C0);
        fg = const Color(0xFF1565C0);
      case _AssetStatus.published:
        label = 'Published';
        bg = const Color(0x1E2E7D32);
        fg = const Color(0xFF2E7D32);
      case _AssetStatus.archived:
        label = 'Archived';
        bg = const Color(0x15000000);
        fg = const Color(0xFF4B5D55);
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

class _ContentAsset {
  const _ContentAsset({
    required this.section,
    required this.title,
    required this.editor,
    required this.status,
    required this.version,
    required this.updated,
  });

  final String section;
  final String title;
  final String editor;
  final _AssetStatus status;
  final String version;
  final String updated;

  _ContentAsset copyWith({
    String? section,
    String? title,
    String? editor,
    _AssetStatus? status,
    String? version,
    String? updated,
  }) {
    return _ContentAsset(
      section: section ?? this.section,
      title: title ?? this.title,
      editor: editor ?? this.editor,
      status: status ?? this.status,
      version: version ?? this.version,
      updated: updated ?? this.updated,
    );
  }
}

enum _AssetStatus { draft, review, published, archived }
