import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

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
  bool _review = false;
  bool _published = false;

  CollectionReference<Map<String, dynamic>> get _contentRegistryRef =>
      FirebaseFirestore.instance.collection('content_registry');

  String _currentEditorLabel() {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName?.trim();
    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    }
    final email = user?.email?.trim();
    if (email != null && email.isNotEmpty) {
      return email;
    }
    return user?.uid ?? 'Super Admin';
  }

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  List<_ContentAsset> _filtered(List<_ContentAsset> assets) {
    final q = _searchCtl.text.trim().toLowerCase();
    final selectedStatuses = <_AssetStatus>{
      if (_draft) _AssetStatus.draft,
      if (_review) _AssetStatus.review,
      if (_published) _AssetStatus.published,
    };

    return assets.where((a) {
      final matchQ =
          q.isEmpty ||
          a.title.toLowerCase().contains(q) ||
          a.section.toLowerCase().contains(q) ||
          a.editor.toLowerCase().contains(q);
      if (!matchQ) return false;
      if (selectedStatuses.isEmpty) return true;
      return selectedStatuses.contains(a.status);
    }).toList();
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
                items:
                    const ['Quran', 'Tafseer', 'Ahadees', 'Daily Inspiration']
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
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Create'),
          ),
        ],
      ),
    );

    final title = titleCtl.text.trim();
    if (ok != true || title.isEmpty) return;

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? 'unknown_admin';
      await _contentRegistryRef.add({
        'section': section,
        'title': title,
        'editor': _currentEditorLabel(),
        'status': _AssetStatus.draft.name,
        'version': 'v1.0.0',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'createdBy': uid,
        'updatedBy': uid,
      });
      if (!mounted) return;
      _showInfo('Created "$title" in the live registry.');
    } catch (e) {
      if (!mounted) return;
      _showInfo('Could not create content: $e');
    }
  }

  Future<void> _editAsset(_ContentAsset a) async {
    final titleCtl = TextEditingController(text: a.title);
    String section = a.section;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Content'),
        content: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: section,
                decoration: const InputDecoration(labelText: 'Section'),
                items:
                    const ['Quran', 'Tafseer', 'Ahadees', 'Daily Inspiration']
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
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    final title = titleCtl.text.trim();
    if (ok != true || title.isEmpty) return;

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? 'unknown_admin';
      await _contentRegistryRef.doc(a.id).set({
        'section': section,
        'title': title,
        'editor': _currentEditorLabel(),
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': uid,
      }, SetOptions(merge: true));
      if (!mounted) return;
      _showInfo('Updated "$title".');
    } catch (e) {
      if (!mounted) return;
      _showInfo('Could not update content: $e');
    }
  }

  Future<void> _deleteAsset(_ContentAsset a) async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Content?'),
            content: Text('This will permanently remove "${a.title}".'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed) return;

    try {
      await _contentRegistryRef.doc(a.id).delete();
      if (!mounted) return;
      _showInfo('Deleted "${a.title}".');
    } catch (e) {
      if (!mounted) return;
      _showInfo('Could not delete content: $e');
    }
  }

  Future<void> _newVersion(_ContentAsset a) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? 'unknown_admin';
      final nextVersion = _bumpVersion(a.version);
      await _contentRegistryRef.doc(a.id).set({
        'version': nextVersion,
        'editor': _currentEditorLabel(),
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': uid,
      }, SetOptions(merge: true));
      if (!mounted) return;
      _showInfo('Created $nextVersion for ${a.title}.');
    } catch (e) {
      if (!mounted) return;
      _showInfo('Could not create a new version: $e');
    }
  }

  Future<void> _setStatus(_ContentAsset a, _AssetStatus status) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? 'unknown_admin';
      await _contentRegistryRef.doc(a.id).set({
        'status': status.name,
        'editor': _currentEditorLabel(),
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': uid,
      }, SetOptions(merge: true));
      if (!mounted) return;
      _showInfo('${a.title} marked as ${status.name}.');
    } catch (e) {
      if (!mounted) return;
      _showInfo('Could not change status: $e');
    }
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
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
                      'Bulk edit panel can be connected to backend batch APIs.',
                    ),
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
                      'Version history is available via row menu actions.',
                    ),
                    icon: const Icon(Icons.history_toggle_off, size: 18),
                    label: const Text('Version History'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const _Entrance(delayMs: 360, child: _AyahRealtimeControlCard()),
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
                        labelText: 'Search title/section/editor',
                      ),
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
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _contentRegistryRef
                  .orderBy('updatedAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return SectionCard(
                    title: 'Content Registry',
                    child: Text(
                      'Could not load realtime content registry: ${snapshot.error}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  );
                }

                final docs =
                    snapshot.data?.docs ??
                    <QueryDocumentSnapshot<Map<String, dynamic>>>[];
                final assets = _filtered(
                  docs.map((doc) => _ContentAsset.fromDoc(doc)).toList(),
                );

                return SectionCard(
                  title: 'Content Registry',
                  action: Text(
                    '${assets.length} records',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (snapshot.connectionState == ConnectionState.waiting &&
                          !snapshot.hasData)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: LinearProgressIndicator(),
                        )
                      else if (assets.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            docs.isEmpty
                                ? 'No live content records yet. Use Add Content to create the first one.'
                                : 'No records match the current filters.',
                          ),
                        )
                      else
                        AppDataTable(
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
                                        child: Text(
                                          a.title,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    DataCell(Text(a.editor)),
                                    DataCell(_StatusTag(status: a.status)),
                                    DataCell(Text(a.version)),
                                    DataCell(Text(a.updated)),
                                    DataCell(
                                      Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
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
                                            onSelected: (value) async {
                                              if (value == 'preview') {
                                                _showInfo(
                                                  'Preview: ${a.title}',
                                                );
                                              } else if (value == 'compare') {
                                                _showInfo(
                                                  'Live version for ${a.title}: ${a.version}',
                                                );
                                              } else if (value == 'rollback') {
                                                await _setStatus(
                                                  a,
                                                  _AssetStatus.review,
                                                );
                                              } else if (value == 'publish') {
                                                await _setStatus(
                                                  a,
                                                  _AssetStatus.published,
                                                );
                                              } else if (value == 'archive') {
                                                await _setStatus(
                                                  a,
                                                  _AssetStatus.archived,
                                                );
                                              }
                                            },
                                            itemBuilder: (_) => const [
                                              PopupMenuItem(
                                                value: 'preview',
                                                child: Text('Preview'),
                                              ),
                                              PopupMenuItem(
                                                value: 'compare',
                                                child: Text('Live Version'),
                                              ),
                                              PopupMenuItem(
                                                value: 'rollback',
                                                child: Text('Move to Review'),
                                              ),
                                              PopupMenuItem(
                                                value: 'publish',
                                                child: Text('Publish'),
                                              ),
                                              PopupMenuItem(
                                                value: 'archive',
                                                child: Text('Archive'),
                                              ),
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
                    ],
                  ),
                );
              },
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
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
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
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
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
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              PieChartSectionData(
                value: 25,
                title: 'Tafseer',
                color: const Color(0xFF00A889),
                titleStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              PieChartSectionData(
                value: 25,
                title: 'Ahadees',
                color: const Color(0xFF38B4A2),
                titleStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              PieChartSectionData(
                value: 15,
                title: 'Daily',
                color: const Color(0xFF1565C0),
                titleStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
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
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg),
      ),
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

class _AyahRealtimeControlCard extends StatefulWidget {
  const _AyahRealtimeControlCard();

  @override
  State<_AyahRealtimeControlCard> createState() =>
      _AyahRealtimeControlCardState();
}

class _AyahRealtimeControlCardState extends State<_AyahRealtimeControlCard> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtl = TextEditingController();
  final _imageUrlCtl = TextEditingController();
  final _arabicCtl = TextEditingController();
  final _translationCtl = TextEditingController();
  final _referenceCtl = TextEditingController();
  final _audioUrlCtl = TextEditingController();
  final _cloudNameCtl = TextEditingController();
  final _uploadPresetCtl = TextEditingController();
  final _folderCtl = TextEditingController(text: 'ayah_of_the_day');

  bool _isSaving = false;
  bool _isUploading = false;
  bool _isDeleting = false;
  bool _isHydrating = false;
  bool _isDirty = false;
  String _lastFingerprint = '';

  DocumentReference<Map<String, dynamic>> get _docRef => FirebaseFirestore
      .instance
      .collection('home_content')
      .doc('ayah_of_the_day');

  @override
  void initState() {
    super.initState();
    for (final ctl in [
      _titleCtl,
      _imageUrlCtl,
      _arabicCtl,
      _translationCtl,
      _referenceCtl,
      _audioUrlCtl,
      _cloudNameCtl,
      _uploadPresetCtl,
      _folderCtl,
    ]) {
      ctl.addListener(_markDirty);
    }
    _refreshAyahFromServer();
  }

  Future<void> _refreshAyahFromServer() async {
    try {
      final snapshot = await _docRef.get(GetOptions(source: Source.server));
      if (!mounted || !snapshot.exists) return;
      final data = snapshot.data();
      if (data == null) return;
      final fingerprint = _fingerprint(data);
      if (fingerprint == _lastFingerprint) return;
      _lastFingerprint = fingerprint;
      _hydrateFromDoc(data);
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Could not refresh Ayah from server: $e');
    }
  }

  @override
  void dispose() {
    _titleCtl.dispose();
    _imageUrlCtl.dispose();
    _arabicCtl.dispose();
    _translationCtl.dispose();
    _referenceCtl.dispose();
    _audioUrlCtl.dispose();
    _cloudNameCtl.dispose();
    _uploadPresetCtl.dispose();
    _folderCtl.dispose();
    super.dispose();
  }

  void _markDirty() {
    if (_isHydrating || _isDirty) return;
    setState(() => _isDirty = true);
  }

  String _readableCloudinaryUploadMessage(Object error) {
    final raw = error.toString();
    final normalized = raw.toLowerCase();

    if (normalized.contains(
      'upload preset must be whitelisted for unsigned uploads',
    )) {
      return 'Cloudinary preset is not unsigned. In Cloudinary → Settings → Upload → Upload presets, create or edit a preset, enable "Unsigned", then try again.';
    }

    if (normalized.contains('must supply api_key')) {
      return 'Cloudinary API key or preset configuration is missing. Please check your Cloudinary settings.';
    }

    return raw;
  }

  String _fingerprint(Map<String, dynamic> data) {
    return [
      data['title'] ?? '',
      data['imageUrl'] ?? '',
      data['arabic'] ?? '',
      data['translation'] ?? '',
      data['reference'] ?? '',
      data['audioUrl'] ?? '',
      data['cloudinaryCloudName'] ?? '',
      data['cloudinaryUploadPreset'] ?? '',
      data['cloudinaryFolder'] ?? '',
    ].join('||');
  }

  void _hydrateFromDoc(Map<String, dynamic> data) {
    _isHydrating = true;
    _titleCtl.text = (data['title'] as String?) ?? 'Ayah of the Day';
    _imageUrlCtl.text = (data['imageUrl'] as String?) ?? '';
    _arabicCtl.text = (data['arabic'] as String?) ?? '';
    _translationCtl.text = (data['translation'] as String?) ?? '';
    _referenceCtl.text = (data['reference'] as String?) ?? '';
    _audioUrlCtl.text = (data['audioUrl'] as String?) ?? '';
    _cloudNameCtl.text = (data['cloudinaryCloudName'] as String?) ?? '';
    _uploadPresetCtl.text = (data['cloudinaryUploadPreset'] as String?) ?? '';
    _folderCtl.text =
        (data['cloudinaryFolder'] as String?) ?? 'ayah_of_the_day';
    _isHydrating = false;
    _isDirty = false;
  }

  Future<void> _seedDefaultAyah() async {
    setState(() => _isSaving = true);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? 'unknown_admin';
      await _docRef.set({
        'title': 'Ayah of the Day',
        'imageUrl':
            'https://deih43ym53wif.cloudfront.net/blue-mosque-glorius-sunset-istanbul-sultan-ahmed-turkey-shutterstock_174067919.jpg_1404e76369.jpg',
        'arabic': 'وَإِذَا سَأَلَكَ عِبَادِي عَنِّي فَإِنِّي قَرِيبٌ',
        'translation': 'Indeed, I am near.',
        'reference': 'Surah Al-Baqarah 2:186',
        'audioUrl':
            'https://everyayah.com/data/English/Sahih_Intnl_Ibrahim_Walk_192kbps/002009.mp3',
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': uid,
      }, SetOptions(merge: true));
      if (!mounted) return;
      setState(() => _isDirty = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Default Ayah content synced live.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not seed default Ayah: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _saveAyah() async {
    final title = _titleCtl.text.trim();
    final imageUrl = _imageUrlCtl.text.trim();
    final arabic = _arabicCtl.text.trim();
    final translation = _translationCtl.text.trim();
    final reference = _referenceCtl.text.trim();
    final audioUrl = _audioUrlCtl.text.trim();

    setState(() => _isSaving = true);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? 'unknown_admin';
      await _docRef.set({
        'title': title.isEmpty ? 'Ayah of the Day' : title,
        'imageUrl': imageUrl.isEmpty ? FieldValue.delete() : imageUrl,
        'arabic': arabic.isEmpty ? FieldValue.delete() : arabic,
        'translation': translation.isEmpty ? FieldValue.delete() : translation,
        'reference': reference.isEmpty ? FieldValue.delete() : reference,
        'audioUrl': audioUrl.isEmpty ? FieldValue.delete() : audioUrl,
        'cloudinaryCloudName': _cloudNameCtl.text.trim(),
        'cloudinaryUploadPreset': _uploadPresetCtl.text.trim(),
        'cloudinaryFolder': _folderCtl.text.trim().isEmpty
            ? 'ayah_of_the_day'
            : _folderCtl.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': uid,
      }, SetOptions(merge: true));
      if (!mounted) return;
      setState(() => _isDirty = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ayah of the Day updated in realtime.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update Ayah: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _uploadAssetToCloudinary({
    required FileType fileType,
    required String targetField,
    required String publicIdField,
    required String assetLabel,
  }) async {
    final cloudName = _cloudNameCtl.text.trim();
    final uploadPreset = _uploadPresetCtl.text.trim();
    if (cloudName.isEmpty || uploadPreset.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter Cloudinary cloud name and upload preset first.'),
        ),
      );
      return;
    }

    setState(() => _isUploading = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: fileType,
        withData: true,
      );
      if (!mounted) return;
      if (result == null || result.files.isEmpty) return;

      final file = result.files.single;
      final bytes = file.bytes;
      if (bytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not read selected $assetLabel bytes.')),
        );
        return;
      }

      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/auto/upload',
      );
      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = uploadPreset;

      final folder = _folderCtl.text.trim();
      if (folder.isNotEmpty) {
        request.fields['folder'] = folder;
      }

      request.files.add(
        http.MultipartFile.fromBytes('file', bytes, filename: file.name),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Cloudinary upload failed: $responseBody');
      }

      final decoded = jsonDecode(responseBody);
      if (decoded is! Map<String, dynamic>) {
        throw Exception('Unexpected Cloudinary response: $responseBody');
      }

      final secureUrl = decoded['secure_url'] as String?;
      final publicId = decoded['public_id'] as String?;
      if (secureUrl == null || secureUrl.isEmpty) {
        throw Exception('Cloudinary did not return secure_url.');
      }

      if (targetField == 'imageUrl') {
        _imageUrlCtl.text = secureUrl;
      } else if (targetField == 'audioUrl') {
        _audioUrlCtl.text = secureUrl;
      }

      final uid = FirebaseAuth.instance.currentUser?.uid ?? 'unknown_admin';
      await _docRef.set({
        targetField: secureUrl,
        publicIdField: publicId,
        'cloudinaryCloudName': cloudName,
        'cloudinaryUploadPreset': uploadPreset,
        'cloudinaryFolder': folder,
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': uid,
      }, SetOptions(merge: true));

      if (!mounted) return;
      setState(() => _isDirty = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$assetLabel uploaded and synced successfully.'),
        ),
      );
    } catch (e) {
      debugPrint('Ayah Cloudinary upload failed: $e');
      if (!mounted) return;
      final friendlyMessage = _readableCloudinaryUploadMessage(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(friendlyMessage),
          duration: const Duration(seconds: 8),
        ),
      );
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _uploadImageToCloudinary() async {
    await _uploadAssetToCloudinary(
      fileType: FileType.image,
      targetField: 'imageUrl',
      publicIdField: 'imagePublicId',
      assetLabel: 'Image',
    );
  }

  Future<void> _uploadAudioToCloudinary() async {
    await _uploadAssetToCloudinary(
      fileType: FileType.audio,
      targetField: 'audioUrl',
      publicIdField: 'audioPublicId',
      assetLabel: 'Audio',
    );
  }

  Future<void> _deleteAyahField({
    required String fieldName,
    required TextEditingController controller,
    required String successMessage,
    String? publicIdField,
  }) async {
    setState(() => _isDeleting = true);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? 'unknown_admin';
      controller.clear();
      await _docRef.set({
        fieldName: FieldValue.delete(),
        ...?(publicIdField == null
            ? null
            : <String, dynamic>{publicIdField: FieldValue.delete()}),
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': uid,
      }, SetOptions(merge: true));
      if (!mounted) return;
      setState(() => _isDirty = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(successMessage)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not update Ayah field: $e')),
      );
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  Future<void> _removeImageUrl() async {
    await _deleteAyahField(
      fieldName: 'imageUrl',
      controller: _imageUrlCtl,
      publicIdField: 'imagePublicId',
      successMessage: 'Image removed from Ayah card.',
    );
  }

  Future<void> _removeAudioUrl() async {
    await _deleteAyahField(
      fieldName: 'audioUrl',
      controller: _audioUrlCtl,
      publicIdField: 'audioPublicId',
      successMessage: 'Audio removed from Ayah card.',
    );
  }

  Future<void> _deleteAyahDocument() async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Ayah Document?'),
            content: const Text(
              'This removes home_content/ayah_of_the_day. The app may recreate default content.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed) return;
    setState(() => _isDeleting = true);
    try {
      await _docRef.delete();
      if (!mounted) return;
      setState(() => _isDirty = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ayah document deleted.')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Ayah of the Day (Realtime)',
      action: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _docRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text('Connecting...');
          }
          final exists = snapshot.data?.exists == true;
          return Text(
            exists ? 'Live connected' : 'No document yet',
            style: Theme.of(context).textTheme.bodySmall,
          );
        },
      ),
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _docRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(
              'Realtime load failed: ${snapshot.error}',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            );
          }

          final data = snapshot.data?.data() ?? <String, dynamic>{};
          final fingerprint = _fingerprint(data);
          if (!_isDirty && fingerprint != _lastFingerprint) {
            _lastFingerprint = fingerprint;
            _hydrateFromDoc(data);
          }

          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    SizedBox(
                      width: 260,
                      child: TextFormField(
                        controller: _cloudNameCtl,
                        decoration: const InputDecoration(
                          labelText: 'Cloudinary Cloud Name',
                          helperText: 'Needed for image and audio upload',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 260,
                      child: TextFormField(
                        controller: _uploadPresetCtl,
                        decoration: const InputDecoration(
                          labelText: 'Cloudinary Upload Preset',
                          helperText: 'Use your unsigned upload preset',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 240,
                      child: TextFormField(
                        controller: _folderCtl,
                        decoration: const InputDecoration(
                          labelText: 'Cloudinary Folder (optional)',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    FilledButton.icon(
                      onPressed: _isUploading ? null : _uploadImageToCloudinary,
                      icon: const Icon(Icons.cloud_upload_outlined, size: 18),
                      label: Text(
                        _isUploading ? 'Uploading...' : 'Upload Image',
                      ),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: _isUploading ? null : _uploadAudioToCloudinary,
                      icon: const Icon(Icons.audio_file_outlined, size: 18),
                      label: const Text('Upload Audio'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _isDeleting ? null : _removeImageUrl,
                      icon: const Icon(
                        Icons.image_not_supported_outlined,
                        size: 18,
                      ),
                      label: const Text('Remove Image'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _isDeleting ? null : _removeAudioUrl,
                      icon: const Icon(Icons.music_off_outlined, size: 18),
                      label: const Text('Remove Audio'),
                    ),
                    OutlinedButton.icon(
                      onPressed: (_isSaving || _isDeleting)
                          ? null
                          : _seedDefaultAyah,
                      icon: const Icon(Icons.auto_fix_high_outlined, size: 18),
                      label: const Text('Seed Default Ayah'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _isDeleting ? null : _deleteAyahDocument,
                      icon: const Icon(Icons.delete_forever_outlined, size: 18),
                      label: const Text('Delete Ayah Doc'),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                AnimatedBuilder(
                  animation: Listenable.merge([
                    _titleCtl,
                    _imageUrlCtl,
                    _arabicCtl,
                    _translationCtl,
                    _referenceCtl,
                    _audioUrlCtl,
                  ]),
                  builder: (context, _) {
                    final previewImage = _imageUrlCtl.text.trim();
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7FBF8),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0x140B6B46)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Live Preview',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 10),
                          if (previewImage.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                previewImage,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      height: 150,
                                      color: const Color(0x11000000),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'Image preview unavailable',
                                      ),
                                    ),
                              ),
                            )
                          else
                            Container(
                              height: 80,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0x110B6B46),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text('No image selected yet'),
                            ),
                          const SizedBox(height: 10),
                          Text(
                            _titleCtl.text.trim().isEmpty
                                ? 'Ayah of the Day'
                                : _titleCtl.text.trim(),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _arabicCtl.text.trim().isEmpty
                                ? 'Arabic ayah preview will appear here.'
                                : _arabicCtl.text.trim(),
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                              fontSize: 18,
                              height: 1.6,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _translationCtl.text.trim().isEmpty
                                ? 'Translation preview will appear here.'
                                : _translationCtl.text.trim(),
                          ),
                          if (_referenceCtl.text.trim().isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              _referenceCtl.text.trim(),
                              style: const TextStyle(
                                color: Color(0xFF0B6B46),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0x110B6B46),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _audioUrlCtl.text.trim().isEmpty
                                      ? Icons.music_off_outlined
                                      : Icons.audiotrack,
                                  color: const Color(0xFF0B6B46),
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _audioUrlCtl.text.trim().isEmpty
                                        ? 'No audio linked yet'
                                        : 'Audio URL is live and connected',
                                    style: const TextStyle(
                                      color: Color(0xFF0B6B46),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _titleCtl,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    helperText: 'Leave blank to use "Ayah of the Day"',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _imageUrlCtl,
                  decoration: const InputDecoration(
                    labelText: 'Image URL',
                    helperText: 'Paste an image URL or use Upload Image',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _arabicCtl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Arabic Ayah',
                    helperText:
                        'Edit live Arabic text; clear and save to remove it',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _translationCtl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Translation',
                    helperText:
                        'Edit live translation; clear and save to remove it',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _referenceCtl,
                  decoration: const InputDecoration(
                    labelText: 'Reference',
                    helperText:
                        'Edit live reference; clear and save to remove it',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _audioUrlCtl,
                  decoration: const InputDecoration(
                    labelText: 'Audio URL',
                    helperText:
                        'Paste a URL or use Upload Audio; clear and save to delete',
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    FilledButton.icon(
                      onPressed: _isSaving ? null : _saveAyah,
                      icon: const Icon(Icons.save_outlined, size: 18),
                      label: Text(_isSaving ? 'Saving...' : 'Save Ayah'),
                    ),
                    const SizedBox(width: 10),
                    FilledButton.tonalIcon(
                      onPressed: _refreshAyahFromServer,
                      icon: const Icon(Icons.refresh_outlined, size: 18),
                      label: const Text('Refresh from Server'),
                    ),
                    const SizedBox(width: 10),
                    if (_isDirty)
                      Text(
                        'Unsaved local edits',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      )
                    else
                      const Text('Synced with Firestore'),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ContentAsset {
  const _ContentAsset({
    required this.id,
    required this.section,
    required this.title,
    required this.editor,
    required this.status,
    required this.version,
    required this.updated,
  });

  factory _ContentAsset.fromDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    return _ContentAsset(
      id: doc.id,
      section: (data['section'] as String?) ?? 'General',
      title: (data['title'] as String?) ?? 'Untitled content',
      editor: (data['editor'] as String?) ?? 'Unknown editor',
      status: _parseStatus(data['status']),
      version: (data['version'] as String?) ?? 'v1.0.0',
      updated: formatUpdated(data['updatedAt']),
    );
  }

  final String id;
  final String section;
  final String title;
  final String editor;
  final _AssetStatus status;
  final String version;
  final String updated;

  _ContentAsset copyWith({
    String? id,
    String? section,
    String? title,
    String? editor,
    _AssetStatus? status,
    String? version,
    String? updated,
  }) {
    return _ContentAsset(
      id: id ?? this.id,
      section: section ?? this.section,
      title: title ?? this.title,
      editor: editor ?? this.editor,
      status: status ?? this.status,
      version: version ?? this.version,
      updated: updated ?? this.updated,
    );
  }

  static _AssetStatus _parseStatus(dynamic value) {
    switch ((value as String? ?? '').toLowerCase()) {
      case 'review':
      case 'in_review':
      case 'in review':
        return _AssetStatus.review;
      case 'published':
        return _AssetStatus.published;
      case 'archived':
        return _AssetStatus.archived;
      case 'draft':
      default:
        return _AssetStatus.draft;
    }
  }

  static String formatUpdated(dynamic value) {
    DateTime? dateTime;
    if (value is Timestamp) {
      dateTime = value.toDate();
    } else if (value is DateTime) {
      dateTime = value;
    } else if (value is String) {
      dateTime = DateTime.tryParse(value);
    }

    if (dateTime == null) return 'now';

    final diff = DateTime.now().difference(dateTime);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}

enum _AssetStatus { draft, review, published, archived }
