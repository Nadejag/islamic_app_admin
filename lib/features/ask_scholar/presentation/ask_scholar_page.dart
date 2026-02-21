import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/admin_scaffold.dart';
import '../../../shared/widgets/app_data_table.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../shared/widgets/stat_card.dart';
import '../../../shared/widgets/workflow_card.dart';

class AskScholarPage extends StatefulWidget {
  const AskScholarPage({super.key});

  @override
  State<AskScholarPage> createState() => _AskScholarPageState();
}

class _AskScholarPageState extends State<AskScholarPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _scholarController = TextEditingController();
  final TextEditingController _dateRangeController = TextEditingController();

  late List<_QuestionItem> _queue;
  final Set<_QuestionStatus> _statusFilters = <_QuestionStatus>{};
  bool _highPriorityOnly = false;

  @override
  void initState() {
    super.initState();
    _queue = List<_QuestionItem>.of(_seedQuestions);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _topicController.dispose();
    _scholarController.dispose();
    _dateRangeController.dispose();
    super.dispose();
  }

  List<_QuestionItem> get _filteredQueue =>
      _queue.where(_matchesFilters).toList();

  bool _matchesFilters(_QuestionItem item) {
    final query = _searchController.text.trim().toLowerCase();
    final topic = _topicController.text.trim().toLowerCase();
    final scholar = _scholarController.text.trim().toLowerCase();
    final date = _dateRangeController.text.trim().toLowerCase();

    final matchesQuery = query.isEmpty ||
        item.question.toLowerCase().contains(query) ||
        item.assignedTo.toLowerCase().contains(query);
    final matchesTopic =
        topic.isEmpty || item.topic.toLowerCase().contains(topic);
    final matchesScholar =
        scholar.isEmpty || item.assignedTo.toLowerCase().contains(scholar);
    final matchesDate =
        date.isEmpty || item.submitted.toLowerCase().contains(date);
    final matchesStatus =
        _statusFilters.isEmpty || _statusFilters.contains(item.status);
    final matchesPriority =
        !_highPriorityOnly || item.priority == _Priority.high;

    return matchesQuery &&
        matchesTopic &&
        matchesScholar &&
        matchesDate &&
        matchesStatus &&
        matchesPriority;
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _topicController.clear();
      _scholarController.clear();
      _dateRangeController.clear();
      _statusFilters.clear();
      _highPriorityOnly = false;
    });
  }

  void _assignBulk() {
    final indexes = <int>[];
    for (var i = 0; i < _queue.length; i++) {
      if (_matchesFilters(_queue[i])) {
        indexes.add(i);
      }
    }
    if (indexes.isEmpty) {
      _showSnack('No questions match current filters.');
      return;
    }

    const scholar = 'Shaykh Idris';
    setState(() {
      for (final i in indexes) {
        final q = _queue[i];
        if (q.status == _QuestionStatus.pending) {
          _queue[i] = q.copyWith(
            status: _QuestionStatus.assigned,
            assignedTo: scholar,
            confidence: math.max(40, q.confidence),
          );
        }
      }
    });
    _showSnack('Bulk assignment completed for ${indexes.length} questions.');
  }

  void _showEscalations() {
    final count = _queue.where((q) => q.priority == _Priority.high).length;
    _showSnack(count == 0
        ? 'No high-priority escalations in queue.'
        : '$count high-priority questions need close monitoring.');
  }

  void _assignSingle(int index) {
    final q = _queue[index];
    if (q.status == _QuestionStatus.locked) {
      _showSnack('Locked thread cannot be reassigned.');
      return;
    }

    setState(() {
      _queue[index] = q.copyWith(
        status: _QuestionStatus.assigned,
        assignedTo: q.assignedTo == 'Unassigned' ? 'Dr. Amina' : q.assignedTo,
        confidence: math.max(q.confidence, 55),
      );
    });
    _showSnack('Question assigned to ${_queue[index].assignedTo}.');
  }

  void _reviewSingle(int index) {
    final q = _queue[index];
    if (q.status == _QuestionStatus.locked) {
      _showSnack('Thread already locked.');
      return;
    }

    setState(() {
      _queue[index] = q.copyWith(
        status: _QuestionStatus.reviewed,
        confidence: math.min(100, q.confidence + 12),
      );
    });
    _showSnack('Answer reviewed and quality-checked.');
  }

  void _lockSingle(int index) {
    final q = _queue[index];
    setState(() {
      _queue[index] = q.copyWith(
        status: _QuestionStatus.locked,
        confidence: math.min(100, q.confidence + 8),
      );
    });
    _showSnack('Thread locked and published as read-only.');
  }

  @override
  Widget build(BuildContext context) {
    final filteredQueue = _filteredQueue;
    final openCount =
        _queue.where((q) => q.status != _QuestionStatus.locked).length;
    final answeredToday = _queue
        .where((q) =>
            q.status == _QuestionStatus.reviewed ||
            q.status == _QuestionStatus.locked)
        .length;
    final avgResponse = _queue.isEmpty
        ? 0.0
        : (_queue.where((q) => q.status != _QuestionStatus.pending).length /
                _queue.length) *
            4.0;
    final lockedCount =
        _queue.where((q) => q.status == _QuestionStatus.locked).length;

    final statusCounts = <_QuestionStatus, int>{
      for (final status in _QuestionStatus.values)
        status: _queue.where((q) => q.status == status).length,
    };

    return AdminScaffold(
      title: 'Ask a Scholar',
      body: ListView(
        children: [
          const _Entrance(delayMs: 20, child: _AskHero()),
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
                        label: 'Open Questions',
                        numericValue: openCount.toDouble(),
                        icon: Icons.live_help_outlined,
                        trendLabel: '+12',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _Entrance(
                      delayMs: 120,
                      child: StatCard(
                        label: 'Answered Today',
                        numericValue: answeredToday.toDouble(),
                        icon: Icons.mark_chat_read_outlined,
                        trendLabel: '+9',
                        accentColor: const Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _Entrance(
                      delayMs: 160,
                      child: StatCard(
                        label: 'Avg Response (hrs)',
                        numericValue: avgResponse,
                        icon: Icons.timer_outlined,
                        trendLabel: '-0.8',
                        accentColor: const Color(0xFF1565C0),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _Entrance(
                      delayMs: 200,
                      child: StatCard(
                        label: 'Locked Threads',
                        numericValue: lockedCount.toDouble(),
                        icon: Icons.lock_outline,
                        trendLabel: '+14',
                        accentColor: const Color(0xFF6A1B9A),
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
              title: 'Q&A Operations',
              action: FilledButton.icon(
                onPressed: _assignBulk,
                icon: const Icon(Icons.person_add_alt_1_outlined),
                label: const Text('Assign in Bulk'),
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
                              labelText: 'Search question / user / id'),
                        ),
                      ),
                      SizedBox(
                        width: 170,
                        child: TextField(
                          controller: _topicController,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(labelText: 'Topic'),
                        ),
                      ),
                      SizedBox(
                        width: 170,
                        child: TextField(
                          controller: _scholarController,
                          onChanged: (_) => setState(() {}),
                          decoration:
                              const InputDecoration(labelText: 'Scholar'),
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
                      ..._QuestionStatus.values.map(
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
                        label: const Text('High Priority'),
                        selected: _highPriorityOnly,
                        onSelected: (selected) {
                          setState(() => _highPriorityOnly = selected);
                        },
                      ),
                      OutlinedButton.icon(
                        onPressed: _showEscalations,
                        icon:
                            const Icon(Icons.warning_amber_outlined, size: 18),
                        label: const Text('Escalations'),
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
              child: _QnaLifecycleBoard(
                pending: statusCounts[_QuestionStatus.pending] ?? 0,
                assigned: statusCounts[_QuestionStatus.assigned] ?? 0,
                reviewedLocked: (statusCounts[_QuestionStatus.reviewed] ?? 0) +
                    (statusCounts[_QuestionStatus.locked] ?? 0),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _Entrance(
            delayMs: 380,
            child: SectionCard(
              title: 'Question Queue',
              action: Text(
                '${filteredQueue.length} records',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              child: filteredQueue.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      child: Column(
                        children: [
                          Text(
                            'No questions found for current filters.',
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
                        DataColumn(label: Text('Question')),
                        DataColumn(label: Text('Topic')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Priority')),
                        DataColumn(label: Text('Assigned')),
                        DataColumn(label: Text('Confidence')),
                        DataColumn(label: Text('Submitted')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: filteredQueue
                          .map(
                            (q) => DataRow(
                              cells: [
                                DataCell(
                                  SizedBox(
                                    width: 260,
                                    child: Text(
                                      q.question,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(Text(q.topic)),
                                DataCell(_StatusTag(status: q.status)),
                                DataCell(_PriorityTag(priority: q.priority)),
                                DataCell(Text(q.assignedTo)),
                                DataCell(
                                  SizedBox(
                                    width: 120,
                                    child: LinearProgressIndicator(
                                      value: q.confidence / 100,
                                      minHeight: 9,
                                      borderRadius: BorderRadius.circular(99),
                                      backgroundColor: const Color(0xFFE2EBE7),
                                    ),
                                  ),
                                ),
                                DataCell(Text(q.submitted)),
                                DataCell(
                                  Wrap(
                                    spacing: 6,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () =>
                                            _assignSingle(_queue.indexOf(q)),
                                        child: const Text('Assign'),
                                      ),
                                      OutlinedButton(
                                        onPressed: () =>
                                            _reviewSingle(_queue.indexOf(q)),
                                        child: const Text('Review'),
                                      ),
                                      FilledButton.tonal(
                                        onPressed: () =>
                                            _lockSingle(_queue.indexOf(q)),
                                        child: const Text('Lock'),
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
          const _Entrance(delayMs: 450, child: _AskAnalyticsSection()),
          const SizedBox(height: 12),
          const _Entrance(
            delayMs: 540,
            child: WorkflowCard(
              title: 'Ask a Scholar Workflow',
              steps: [
                'Receive question from user queue and classify by topic/risk',
                'Assign to verified scholar based on specialization and load',
                'Review, approve, and quality-check final answer',
                'Lock thread and publish authoritative read-only response',
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AskHero extends StatelessWidget {
  const _AskHero();

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
            'Ask Scholar Q&A Controller',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Assign, review, approve, and lock authoritative responses with transparent moderation and throughput control.',
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

class _QnaLifecycleBoard extends StatelessWidget {
  const _QnaLifecycleBoard({
    required this.pending,
    required this.assigned,
    required this.reviewedLocked,
  });

  final int pending;
  final int assigned;
  final int reviewedLocked;

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
                title: 'Pending Queue',
                count: pending.toString().padLeft(2, '0'),
                subtitle: 'Needs assignment',
                color: const Color(0xFFF9A825),
              ),
            ),
            SizedBox(
              width: width,
              child: _StageCard(
                title: 'Assigned',
                count: assigned.toString().padLeft(2, '0'),
                subtitle: 'Scholar in progress',
                color: const Color(0xFF1565C0),
              ),
            ),
            SizedBox(
              width: width,
              child: _StageCard(
                title: 'Reviewed/Locked',
                count: reviewedLocked.toString().padLeft(2, '0'),
                subtitle: 'Published answers',
                color: const Color(0xFF2E7D32),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AskAnalyticsSection extends StatelessWidget {
  const _AskAnalyticsSection();

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
                  title: 'Q&A Throughput',
                  child: SizedBox(height: 220, child: _AskAreaChart()),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: width,
                child: const SectionCard(
                  title: 'Topic Distribution',
                  child: SizedBox(height: 220, child: _TopicPieChart()),
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
                title: 'Q&A Throughput',
                child: SizedBox(height: 220, child: _AskAreaChart()),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: width,
              child: const SectionCard(
                title: 'Topic Distribution',
                child: SizedBox(height: 220, child: _TopicPieChart()),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AskAreaChart extends StatelessWidget {
  const _AskAreaChart();

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
              FlSpot(1, 18),
              FlSpot(2, 24),
              FlSpot(3, 27),
              FlSpot(4, 33),
              FlSpot(5, 38),
              FlSpot(6, 44),
            ],
            isCurved: true,
            barWidth: 3.5,
            color: const Color(0xFF0B6B46),
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
    );
  }
}

class _TopicPieChart extends StatelessWidget {
  const _TopicPieChart();

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        centerSpaceRadius: 42,
        sectionsSpace: 3,
        sections: [
          PieChartSectionData(
            value: 35,
            title: 'Fiqh',
            color: const Color(0xFF1D8A5D),
            titleStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600),
          ),
          PieChartSectionData(
            value: 27,
            title: 'Tafseer',
            color: const Color(0xFF00A889),
            titleStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600),
          ),
          PieChartSectionData(
            value: 22,
            title: 'Hadith',
            color: const Color(0xFF38B4A2),
            titleStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600),
          ),
          PieChartSectionData(
            value: 16,
            title: 'Aqidah',
            color: const Color(0xFF1565C0),
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

class _StatusTag extends StatelessWidget {
  const _StatusTag({required this.status});

  final _QuestionStatus status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case _QuestionStatus.pending:
        return const _Pill(label: 'Pending', color: Color(0xFFF9A825));
      case _QuestionStatus.assigned:
        return const _Pill(label: 'Assigned', color: Color(0xFF1565C0));
      case _QuestionStatus.reviewed:
        return const _Pill(label: 'Reviewed', color: Color(0xFF2E7D32));
      case _QuestionStatus.locked:
        return const _Pill(label: 'Locked', color: Color(0xFF6B7280));
    }
  }
}

class _PriorityTag extends StatelessWidget {
  const _PriorityTag({required this.priority});

  final _Priority priority;

  @override
  Widget build(BuildContext context) {
    switch (priority) {
      case _Priority.high:
        return const _Pill(label: 'High', color: Color(0xFFD84315));
      case _Priority.medium:
        return const _Pill(label: 'Medium', color: Color(0xFF1565C0));
      case _Priority.low:
        return const _Pill(label: 'Low', color: Color(0xFF2E7D32));
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

class _QuestionItem {
  const _QuestionItem({
    required this.question,
    required this.topic,
    required this.status,
    required this.priority,
    required this.submitted,
    required this.assignedTo,
    required this.confidence,
  });

  final String question;
  final String topic;
  final _QuestionStatus status;
  final _Priority priority;
  final String submitted;
  final String assignedTo;
  final int confidence;

  _QuestionItem copyWith({
    String? question,
    String? topic,
    _QuestionStatus? status,
    _Priority? priority,
    String? submitted,
    String? assignedTo,
    int? confidence,
  }) {
    return _QuestionItem(
      question: question ?? this.question,
      topic: topic ?? this.topic,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      submitted: submitted ?? this.submitted,
      assignedTo: assignedTo ?? this.assignedTo,
      confidence: confidence ?? this.confidence,
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

enum _QuestionStatus { pending, assigned, reviewed, locked }

enum _Priority { high, medium, low }

extension on _QuestionStatus {
  String get label {
    switch (this) {
      case _QuestionStatus.pending:
        return 'Pending';
      case _QuestionStatus.assigned:
        return 'Assigned';
      case _QuestionStatus.reviewed:
        return 'Reviewed';
      case _QuestionStatus.locked:
        return 'Locked';
    }
  }
}

const List<_QuestionItem> _seedQuestions = <_QuestionItem>[
  _QuestionItem(
    question: 'Is missed fast expiation required?',
    topic: 'Fiqh',
    status: _QuestionStatus.pending,
    priority: _Priority.high,
    submitted: '3m ago',
    assignedTo: 'Unassigned',
    confidence: 0,
  ),
  _QuestionItem(
    question: 'Meaning of ayah 2:286',
    topic: 'Tafseer',
    status: _QuestionStatus.assigned,
    priority: _Priority.medium,
    submitted: '20m ago',
    assignedTo: 'Shaykh Zayd',
    confidence: 78,
  ),
  _QuestionItem(
    question: 'Hadith reference on intention',
    topic: 'Hadith',
    status: _QuestionStatus.reviewed,
    priority: _Priority.low,
    submitted: '1h ago',
    assignedTo: 'Dr. Amina',
    confidence: 93,
  ),
  _QuestionItem(
    question: 'Can zakat be paid monthly?',
    topic: 'Fiqh',
    status: _QuestionStatus.assigned,
    priority: _Priority.medium,
    submitted: '2h ago',
    assignedTo: 'Ustadh Kareem',
    confidence: 81,
  ),
];
