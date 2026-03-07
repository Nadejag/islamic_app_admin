import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/admin_scaffold.dart';
import '../../../shared/widgets/app_data_table.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../shared/widgets/stat_card.dart';
import '../../../shared/widgets/workflow_card.dart';

class TeachingPage extends StatefulWidget {
  const TeachingPage({super.key});

  @override
  State<TeachingPage> createState() => _TeachingPageState();
}

class _TeachingPageState extends State<TeachingPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();

  late List<_ClassItem> _classes;
  final Set<_ClassStatus> _statusFilters = <_ClassStatus>{};
  bool _lowRatingOnly = false;

  @override
  void initState() {
    super.initState();
    _classes = List<_ClassItem>.of(_seedClasses);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _categoryController.dispose();
    _languageController.dispose();
    _startDateController.dispose();
    super.dispose();
  }

  List<_ClassItem> get _filteredClasses =>
      _classes.where(_matchesFilters).toList();

  bool _matchesFilters(_ClassItem item) {
    final query = _searchController.text.trim().toLowerCase();
    final category = _categoryController.text.trim().toLowerCase();
    final language = _languageController.text.trim().toLowerCase();
    final startDate = _startDateController.text.trim().toLowerCase();

    final matchesQuery = query.isEmpty ||
        item.title.toLowerCase().contains(query) ||
        item.teacher.toLowerCase().contains(query);
    final matchesCategory =
        category.isEmpty || item.category.toLowerCase().contains(category);
    final matchesLanguage =
        language.isEmpty || item.language.toLowerCase().contains(language);
    final matchesStartDate =
        startDate.isEmpty || item.startDate.toLowerCase().contains(startDate);
    final matchesStatus =
        _statusFilters.isEmpty || _statusFilters.contains(item.status);
    final matchesLowRating = !_lowRatingOnly || item.rating < 4.5;

    return matchesQuery &&
        matchesCategory &&
        matchesLanguage &&
        matchesStartDate &&
        matchesStatus &&
        matchesLowRating;
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _categoryController.clear();
      _languageController.clear();
      _startDateController.clear();
      _statusFilters.clear();
      _lowRatingOnly = false;
    });
  }

  Future<void> _showClassDialog({int? editIndex}) async {
    final existing = editIndex == null ? null : _classes[editIndex];
    final titleController = TextEditingController(text: existing?.title ?? '');
    final teacherController =
        TextEditingController(text: existing?.teacher ?? '');
    final categoryController =
        TextEditingController(text: existing?.category ?? '');
    final languageController =
        TextEditingController(text: existing?.language ?? '');
    final startController =
        TextEditingController(text: existing?.startDate ?? '');

    var selectedStatus = existing?.status ?? _ClassStatus.scheduled;

    final didSave = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            return AlertDialog(
              title: Text(existing == null ? 'Create Class' : 'Edit Class'),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 500,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration:
                            const InputDecoration(labelText: 'Class title'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: teacherController,
                        decoration: const InputDecoration(labelText: 'Teacher'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: categoryController,
                        decoration:
                            const InputDecoration(labelText: 'Category'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: languageController,
                        decoration:
                            const InputDecoration(labelText: 'Language'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: startController,
                        decoration:
                            const InputDecoration(labelText: 'Start date'),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<_ClassStatus>(
                        initialValue: selectedStatus,
                        items: _ClassStatus.values
                            .map(
                              (status) => DropdownMenuItem<_ClassStatus>(
                                value: status,
                                child: Text(status.label),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setLocalState(() => selectedStatus = value);
                        },
                        decoration: const InputDecoration(labelText: 'Status'),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    final teacher = teacherController.text.trim();
                    final category = categoryController.text.trim();
                    final language = languageController.text.trim();
                    final startDate = startController.text.trim();
                    if (title.isEmpty ||
                        teacher.isEmpty ||
                        category.isEmpty ||
                        language.isEmpty ||
                        startDate.isEmpty) {
                      return;
                    }

                    final item = _ClassItem(
                      title: title,
                      teacher: teacher,
                      category: category,
                      language: language,
                      startDate: startDate,
                      students: existing?.students ?? 0,
                      status: selectedStatus,
                      rating: existing?.rating ?? 4.5,
                      completion: existing?.completion ?? 0,
                      certificates: existing?.certificates ?? 0,
                      flags: existing?.flags ?? 0,
                    );
                    setState(() {
                      if (editIndex == null) {
                        _classes.insert(0, item);
                      } else {
                        _classes[editIndex] = item;
                      }
                    });
                    Navigator.of(context).pop(true);
                  },
                  child: Text(existing == null ? 'Create' : 'Save'),
                ),
              ],
            );
          },
        );
      },
    );

    titleController.dispose();
    teacherController.dispose();
    categoryController.dispose();
    languageController.dispose();
    startController.dispose();

    if (didSave == true) {
      _showSnack(existing == null
          ? 'Class created successfully.'
          : 'Class updated successfully.');
    }
  }

  void _openClass(int index) {
    final classItem = _classes[index];
    _showSnack('Opened class workspace: ${classItem.title}');
  }

  void _moderateClass(int index) {
    final classItem = _classes[index];
    setState(() {
      final nextFlags = math.max(0, classItem.flags - 1).toInt();
      _classes[index] = classItem.copyWith(
        flags: nextFlags,
        status: nextFlags == 0 ? _ClassStatus.live : _ClassStatus.review,
      );
    });
    _showSnack('Moderation updated for ${classItem.title}.');
  }

  void _issueCertificate(int index) {
    final classItem = _classes[index];
    final newCertificates = classItem.certificates +
        math.max(1, (classItem.students * 0.08).round()).toInt();
    setState(() {
      _classes[index] = classItem.copyWith(certificates: newCertificates);
    });
    _showSnack('Certificates issued for ${classItem.title}.');
  }

  void _openFlagsQueue() {
    final flagged = _classes.where((c) => c.flags > 0).length;
    _showSnack(flagged == 0
        ? 'No flagged classes right now.'
        : '$flagged classes currently require moderation.');
  }

  @override
  Widget build(BuildContext context) {
    final filteredClasses = _filteredClasses;
    final activeClasses =
        _classes.where((c) => c.status == _ClassStatus.live).length;
    final avgRating = _classes.isEmpty
        ? 0.0
        : _classes.fold<double>(0, (sum, c) => sum + c.rating) /
            _classes.length;
    final totalCertificates =
        _classes.fold<int>(0, (sum, c) => sum + c.certificates);

    final statusCounts = <_ClassStatus, int>{
      for (final status in _ClassStatus.values)
        status: _classes.where((c) => c.status == status).length,
    };

    return AdminScaffold(
      title: 'Teaching Platform',
      body: ListView(
        children: [
          const _Entrance(delayMs: 20, child: _TeachingHero()),
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
                        label: 'Active Classes',
                        numericValue: activeClasses.toDouble(),
                        icon: Icons.class_outlined,
                        trendLabel: '+5',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _Entrance(
                      delayMs: 120,
                      child: StatCard(
                        label: 'Certified Teachers',
                        numericValue: _classes
                            .map((c) => c.teacher)
                            .toSet()
                            .length
                            .toDouble(),
                        icon: Icons.school_outlined,
                        trendLabel: '+3',
                        accentColor: const Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _Entrance(
                      delayMs: 160,
                      child: StatCard(
                        label: 'Avg Class Rating',
                        numericValue: avgRating,
                        icon: Icons.star_outline,
                        trendLabel: '+0.2',
                        accentColor: const Color(0xFFF9A825),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _Entrance(
                      delayMs: 200,
                      child: StatCard(
                        label: 'Certificates Issued',
                        numericValue: totalCertificates.toDouble(),
                        icon: Icons.workspace_premium_outlined,
                        trendLabel: '+11%',
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
            delayMs: 250,
            child: SectionCard(
              title: 'Teaching Operations',
              action: FilledButton.icon(
                onPressed: _showClassDialog,
                icon: const Icon(Icons.add),
                label: const Text('Create Class'),
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
                              labelText: 'Search class/teacher'),
                        ),
                      ),
                      SizedBox(
                        width: 160,
                        child: TextField(
                          controller: _categoryController,
                          onChanged: (_) => setState(() {}),
                          decoration:
                              const InputDecoration(labelText: 'Category'),
                        ),
                      ),
                      SizedBox(
                        width: 160,
                        child: TextField(
                          controller: _languageController,
                          onChanged: (_) => setState(() {}),
                          decoration:
                              const InputDecoration(labelText: 'Language'),
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: TextField(
                          controller: _startDateController,
                          onChanged: (_) => setState(() {}),
                          decoration:
                              const InputDecoration(labelText: 'Start date'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ..._ClassStatus.values.map(
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
                      FilterChip(
                        label: const Text('Low Rating'),
                        selected: _lowRatingOnly,
                        onSelected: (selected) {
                          setState(() => _lowRatingOnly = selected);
                        },
                      ),
                      OutlinedButton.icon(
                        onPressed: _openFlagsQueue,
                        icon: const Icon(Icons.gpp_bad_outlined, size: 18),
                        label: const Text('Open Flags'),
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
            delayMs: 320,
            child: SectionCard(
              title: 'Lifecycle Board',
              child: _TeachingLifecycleBoard(
                scheduled: statusCounts[_ClassStatus.scheduled] ?? 0,
                live: statusCounts[_ClassStatus.live] ?? 0,
                review: statusCounts[_ClassStatus.review] ?? 0,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _Entrance(
            delayMs: 380,
            child: SectionCard(
              title: 'Class Registry',
              action: Text(
                '${filteredClasses.length} records',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              child: filteredClasses.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      child: Column(
                        children: [
                          Text(
                            'No classes found for current filters.',
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
                        DataColumn(label: Text('Class')),
                        DataColumn(label: Text('Teacher')),
                        DataColumn(label: Text('Students')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Rating')),
                        DataColumn(label: Text('Completion')),
                        DataColumn(label: Text('Certificates')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: filteredClasses
                          .map(
                            (c) => DataRow(
                              cells: [
                                DataCell(
                                  SizedBox(
                                    width: 220,
                                    child: Text(
                                      c.title,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(Text(c.teacher)),
                                DataCell(Text('${c.students}')),
                                DataCell(_ClassStatusTag(status: c.status)),
                                DataCell(Text(c.rating.toStringAsFixed(1))),
                                DataCell(
                                  SizedBox(
                                    width: 120,
                                    child: LinearProgressIndicator(
                                      value: c.completion / 100,
                                      minHeight: 9,
                                      borderRadius: BorderRadius.circular(99),
                                      backgroundColor: const Color(0xFFE2EBE7),
                                    ),
                                  ),
                                ),
                                DataCell(Text('${c.certificates}')),
                                DataCell(
                                  Wrap(
                                    spacing: 6,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () =>
                                            _openClass(_classes.indexOf(c)),
                                        child: const Text('Open'),
                                      ),
                                      OutlinedButton(
                                        onPressed: () =>
                                            _moderateClass(_classes.indexOf(c)),
                                        child: const Text('Moderate'),
                                      ),
                                      FilledButton.tonal(
                                        onPressed: () => _issueCertificate(
                                            _classes.indexOf(c)),
                                        child: const Text('Certificate'),
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
          const _Entrance(delayMs: 460, child: _TeachingAnalyticsSection()),
          const SizedBox(height: 12),
          const _Entrance(
            delayMs: 540,
            child: WorkflowCard(
              title: 'Teaching Platform Workflow',
              steps: [
                'Review teacher quality, ratings, and class delivery consistency',
                'Monitor live classes and moderate classroom behavior issues',
                'Track completion and learning outcomes by cohort and instructor',
                'Approve certificates only after quality and attendance checks',
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TeachingHero extends StatelessWidget {
  const _TeachingHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF0B6B46), Color(0xFF1A8D5A), Color(0xFF2EA36D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2A0B6B46),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Teaching Controller',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Manage teacher quality, class operations, moderation, and certification from one governance console.',
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

class _TeachingLifecycleBoard extends StatelessWidget {
  const _TeachingLifecycleBoard({
    required this.scheduled,
    required this.live,
    required this.review,
  });

  final int scheduled;
  final int live;
  final int review;

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
                title: 'Scheduled',
                count: scheduled.toString().padLeft(2, '0'),
                subtitle: 'Upcoming sessions',
                color: const Color(0xFF1565C0),
              ),
            ),
            SizedBox(
              width: width,
              child: _StageCard(
                title: 'Live Now',
                count: live.toString().padLeft(2, '0'),
                subtitle: 'Running classes',
                color: const Color(0xFF2E7D32),
              ),
            ),
            SizedBox(
              width: width,
              child: _StageCard(
                title: 'Under Review',
                count: review.toString().padLeft(2, '0'),
                subtitle: 'Needs moderation',
                color: const Color(0xFFF9A825),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TeachingAnalyticsSection extends StatelessWidget {
  const _TeachingAnalyticsSection();

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
                  title: 'Attendance Trend',
                  child: SizedBox(height: 220, child: _AttendanceLineChart()),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: width,
                child: const SectionCard(
                  title: 'Moderation Load',
                  child: SizedBox(height: 220, child: _ModerationBarChart()),
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
                title: 'Attendance Trend',
                child: SizedBox(height: 220, child: _AttendanceLineChart()),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: width,
              child: const SectionCard(
                title: 'Moderation Load',
                child: SizedBox(height: 220, child: _ModerationBarChart()),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AttendanceLineChart extends StatelessWidget {
  const _AttendanceLineChart();

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
              FlSpot(1, 64),
              FlSpot(2, 69),
              FlSpot(3, 71),
              FlSpot(4, 76),
              FlSpot(5, 81),
              FlSpot(6, 84),
            ],
            color: const Color(0xFF0B6B46),
            barWidth: 3.5,
            isCurved: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF0B6B46).withAlpha(64),
                  const Color(0xFF0B6B46).withAlpha(0),
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

class _ModerationBarChart extends StatelessWidget {
  const _ModerationBarChart();

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
          for (var i = 0; i < 5; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: 14 + (i * 7),
                  width: 14,
                  borderRadius: BorderRadius.circular(6),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0B6B46), Color(0xFF2EA36D)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ],
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

class _ClassStatusTag extends StatelessWidget {
  const _ClassStatusTag({required this.status});

  final _ClassStatus status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case _ClassStatus.live:
        return const _Pill(label: 'Live', color: Color(0xFF2E7D32));
      case _ClassStatus.scheduled:
        return const _Pill(label: 'Scheduled', color: Color(0xFF1565C0));
      case _ClassStatus.review:
        return const _Pill(label: 'Review', color: Color(0xFFF9A825));
      case _ClassStatus.paused:
        return const _Pill(label: 'Paused', color: Color(0xFF6B7280));
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

class _ClassItem {
  const _ClassItem({
    required this.title,
    required this.teacher,
    required this.category,
    required this.language,
    required this.startDate,
    required this.students,
    required this.status,
    required this.rating,
    required this.completion,
    required this.certificates,
    required this.flags,
  });

  final String title;
  final String teacher;
  final String category;
  final String language;
  final String startDate;
  final int students;
  final _ClassStatus status;
  final double rating;
  final int completion;
  final int certificates;
  final int flags;

  _ClassItem copyWith({
    String? title,
    String? teacher,
    String? category,
    String? language,
    String? startDate,
    int? students,
    _ClassStatus? status,
    double? rating,
    int? completion,
    int? certificates,
    int? flags,
  }) {
    return _ClassItem(
      title: title ?? this.title,
      teacher: teacher ?? this.teacher,
      category: category ?? this.category,
      language: language ?? this.language,
      startDate: startDate ?? this.startDate,
      students: students ?? this.students,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      completion: completion ?? this.completion,
      certificates: certificates ?? this.certificates,
      flags: flags ?? this.flags,
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

enum _ClassStatus { live, scheduled, review, paused }

extension on _ClassStatus {
  String get label {
    switch (this) {
      case _ClassStatus.live:
        return 'Live';
      case _ClassStatus.scheduled:
        return 'Scheduled';
      case _ClassStatus.review:
        return 'Review';
      case _ClassStatus.paused:
        return 'Paused';
    }
  }
}

const List<_ClassItem> _seedClasses = <_ClassItem>[
  _ClassItem(
    title: 'Quran Tajweed Level 2',
    teacher: 'Ustadh Salman',
    category: 'Quran',
    language: 'English',
    startDate: '12 Mar 2026',
    students: 120,
    status: _ClassStatus.live,
    rating: 4.8,
    completion: 78,
    certificates: 32,
    flags: 1,
  ),
  _ClassItem(
    title: 'Fiqh Essentials',
    teacher: 'Dr. Huzaifa',
    category: 'Fiqh',
    language: 'Urdu',
    startDate: '20 Apr 2026',
    students: 86,
    status: _ClassStatus.scheduled,
    rating: 4.7,
    completion: 56,
    certificates: 19,
    flags: 0,
  ),
  _ClassItem(
    title: 'Hadith Deep Dive',
    teacher: 'Shaykha Iman',
    category: 'Hadith',
    language: 'Arabic',
    startDate: '05 May 2026',
    students: 64,
    status: _ClassStatus.review,
    rating: 4.9,
    completion: 84,
    certificates: 27,
    flags: 2,
  ),
  _ClassItem(
    title: 'Aqidah Fundamentals',
    teacher: 'Ustadh Kareem',
    category: 'Aqidah',
    language: 'English',
    startDate: '28 Feb 2026',
    students: 91,
    status: _ClassStatus.live,
    rating: 4.6,
    completion: 68,
    certificates: 21,
    flags: 0,
  ),
];
