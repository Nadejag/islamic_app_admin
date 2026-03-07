import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/admin_scaffold.dart';
import '../../../shared/widgets/app_data_table.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../shared/widgets/stat_card.dart';
import '../../../shared/widgets/workflow_card.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _hijriController = TextEditingController();
  final TextEditingController _gregorianController = TextEditingController();
  final TextEditingController _scopeController = TextEditingController();

  late List<_EventItem> _events;
  final Set<_EventStatus> _statusFilters = <_EventStatus>{};
  bool _publishedOnly = false;

  @override
  void initState() {
    super.initState();
    _events = List<_EventItem>.of(_seedEvents);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _hijriController.dispose();
    _gregorianController.dispose();
    _scopeController.dispose();
    super.dispose();
  }

  List<_EventItem> get _filteredEvents =>
      _events.where(_matchesFilters).toList();

  bool _matchesFilters(_EventItem event) {
    final query = _searchController.text.trim().toLowerCase();
    final hijri = _hijriController.text.trim().toLowerCase();
    final gregorian = _gregorianController.text.trim().toLowerCase();
    final scope = _scopeController.text.trim().toLowerCase();

    final matchesQuery =
        query.isEmpty || event.title.toLowerCase().contains(query);
    final matchesHijri =
        hijri.isEmpty || event.hijriDate.toLowerCase().contains(hijri);
    final matchesGregorian = gregorian.isEmpty ||
        event.gregorianDate.toLowerCase().contains(gregorian);
    final matchesScope =
        scope.isEmpty || event.scope.toLowerCase().contains(scope);
    final matchesStatus =
        _statusFilters.isEmpty || _statusFilters.contains(event.status);
    final matchesPublished = !_publishedOnly || event.published;

    return matchesQuery &&
        matchesHijri &&
        matchesGregorian &&
        matchesScope &&
        matchesStatus &&
        matchesPublished;
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _hijriController.clear();
      _gregorianController.clear();
      _scopeController.clear();
      _statusFilters.clear();
      _publishedOnly = false;
    });
  }

  Future<void> _showEventDialog({int? editIndex}) async {
    final existing = editIndex == null ? null : _events[editIndex];
    final titleController = TextEditingController(text: existing?.title ?? '');
    final hijriController =
        TextEditingController(text: existing?.hijriDate ?? '');
    final gregorianController =
        TextEditingController(text: existing?.gregorianDate ?? '');
    final scopeController = TextEditingController(text: existing?.scope ?? '');

    var selectedStatus = existing?.status ?? _EventStatus.draft;
    var isPublished = existing?.published ?? false;

    final didSave = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            return AlertDialog(
              title: Text(existing == null ? 'Create Event' : 'Edit Event'),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 460,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration:
                            const InputDecoration(labelText: 'Event title'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: hijriController,
                        decoration:
                            const InputDecoration(labelText: 'Hijri date'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: gregorianController,
                        decoration:
                            const InputDecoration(labelText: 'Gregorian date'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: scopeController,
                        decoration: const InputDecoration(
                            labelText: 'Scope (Global/Regional/Local)'),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<_EventStatus>(
                        initialValue: selectedStatus,
                        items: _EventStatus.values
                            .map(
                              (status) => DropdownMenuItem<_EventStatus>(
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
                      const SizedBox(height: 8),
                      SwitchListTile.adaptive(
                        value: isPublished,
                        onChanged: (value) =>
                            setLocalState(() => isPublished = value),
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Published / Visible'),
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
                    final hijri = hijriController.text.trim();
                    final gregorian = gregorianController.text.trim();
                    final scope = scopeController.text.trim();
                    if (title.isEmpty ||
                        hijri.isEmpty ||
                        gregorian.isEmpty ||
                        scope.isEmpty) {
                      return;
                    }

                    final item = _EventItem(
                      title: title,
                      hijriDate: hijri,
                      gregorianDate: gregorian,
                      scope: scope,
                      status: selectedStatus,
                      published: isPublished,
                      registrations: existing?.registrations ?? 0,
                      notifications: existing?.notifications ?? 0,
                    );
                    setState(() {
                      if (editIndex == null) {
                        _events.insert(0, item);
                      } else {
                        _events[editIndex] = item;
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
    hijriController.dispose();
    gregorianController.dispose();
    scopeController.dispose();

    if (didSave == true) {
      _showSnack(existing == null
          ? 'Event created successfully.'
          : 'Event updated successfully.');
    }
  }

  void _togglePublish(int index) {
    final event = _events[index];
    setState(() {
      _events[index] = event.copyWith(published: !event.published);
    });
    _showSnack(_events[index].published
        ? 'Event published successfully.'
        : 'Event unpublished successfully.');
  }

  void _notifyEvent(int index) {
    final event = _events[index];
    final increment = math.max(500, (event.registrations * 0.2).round());
    setState(() {
      _events[index] =
          event.copyWith(notifications: event.notifications + increment);
    });
    _showSnack('Reminder notifications sent for "${event.title}".');
  }

  void _sendBulkReminder() {
    final indexes = <int>[];
    for (var i = 0; i < _events.length; i++) {
      if (_matchesFilters(_events[i])) {
        indexes.add(i);
      }
    }

    if (indexes.isEmpty) {
      _showSnack('No events match current filters.');
      return;
    }

    setState(() {
      for (final i in indexes) {
        final event = _events[i];
        final increment = math.max(500, (event.registrations * 0.1).round());
        _events[i] =
            event.copyWith(notifications: event.notifications + increment);
      }
    });
    _showSnack('Bulk reminders sent for ${indexes.length} events.');
  }

  @override
  Widget build(BuildContext context) {
    final filteredEvents = _filteredEvents;
    final publishedCount = _events.where((e) => e.published).length;
    final totalReach = _events.fold<int>(0, (sum, e) => sum + e.notifications);
    final statusCounts = <_EventStatus, int>{
      for (final status in _EventStatus.values)
        status: _events.where((event) => event.status == status).length,
    };

    return AdminScaffold(
      title: 'Islamic Events',
      body: ListView(
        children: [
          const _Entrance(delayMs: 20, child: _EventsHero()),
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
                        label: 'Upcoming Events',
                        numericValue: _events.length.toDouble(),
                        icon: Icons.event_available_outlined,
                        trendLabel: '+6',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _Entrance(
                      delayMs: 120,
                      child: StatCard(
                        label: 'Published Timelines',
                        numericValue: publishedCount.toDouble(),
                        icon: Icons.timeline_outlined,
                        trendLabel: '+3',
                        accentColor: const Color(0xFF1565C0),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _Entrance(
                      delayMs: 160,
                      child: StatCard(
                        label: 'Notification Reach',
                        numericValue: totalReach / 1000,
                        numberSuffix: 'k',
                        icon: Icons.notifications_active_outlined,
                        trendLabel: '+14%',
                        accentColor: const Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: const _Entrance(
                      delayMs: 200,
                      child: StatCard(
                        label: 'Avg Publish Time',
                        numericValue: 2.8,
                        numberSuffix: 'h',
                        icon: Icons.schedule_outlined,
                        trendLabel: '-0.6h',
                        accentColor: Color(0xFF6A1B9A),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          _Entrance(
            delayMs: 240,
            child: SectionCard(
              title: 'Operations Panel',
              action: FilledButton.icon(
                onPressed: _showEventDialog,
                icon: const Icon(Icons.add),
                label: const Text('Create Event'),
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
                              labelText: 'Search by title/tag'),
                        ),
                      ),
                      SizedBox(
                        width: 170,
                        child: TextField(
                          controller: _hijriController,
                          onChanged: (_) => setState(() {}),
                          decoration:
                              const InputDecoration(labelText: 'Hijri date'),
                        ),
                      ),
                      SizedBox(
                        width: 170,
                        child: TextField(
                          controller: _gregorianController,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                              labelText: 'Gregorian date'),
                        ),
                      ),
                      SizedBox(
                        width: 160,
                        child: TextField(
                          controller: _scopeController,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                              labelText: 'Location / Region'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ..._EventStatus.values.map(
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
                        label: const Text('Published'),
                        selected: _publishedOnly,
                        onSelected: (selected) {
                          setState(() => _publishedOnly = selected);
                        },
                      ),
                      OutlinedButton.icon(
                        onPressed: _sendBulkReminder,
                        icon:
                            const Icon(Icons.notifications_outlined, size: 18),
                        label: const Text('Send Bulk Reminder'),
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
            delayMs: 300,
            child: SectionCard(
              title: 'Lifecycle Board',
              child: _LifecycleBoard(
                draftCount: statusCounts[_EventStatus.draft] ?? 0,
                reviewCount: statusCounts[_EventStatus.review] ?? 0,
                scheduledCount: statusCounts[_EventStatus.scheduled] ?? 0,
                liveCount: statusCounts[_EventStatus.live] ?? 0,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _Entrance(
            delayMs: 360,
            child: SectionCard(
              title: 'Event Registry',
              action: Text(
                '${filteredEvents.length} records',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              child: filteredEvents.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      child: Column(
                        children: [
                          Text(
                            'No events found for current filters.',
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
                        DataColumn(label: Text('Event')),
                        DataColumn(label: Text('Hijri / Gregorian')),
                        DataColumn(label: Text('Scope')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Published')),
                        DataColumn(label: Text('Registrations')),
                        DataColumn(label: Text('Notifications')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: filteredEvents
                          .map(
                            (e) => DataRow(
                              cells: [
                                DataCell(
                                  SizedBox(
                                    width: 220,
                                    child: Text(
                                      e.title,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 180,
                                    child: Text(
                                        '${e.hijriDate}\n${e.gregorianDate}'),
                                  ),
                                ),
                                DataCell(Text(e.scope)),
                                DataCell(_StatusTag(status: e.status)),
                                DataCell(
                                  _Pill(
                                    label: e.published ? 'Visible' : 'Hidden',
                                    color: e.published
                                        ? const Color(0xFF2E7D32)
                                        : const Color(0xFF6B7280),
                                  ),
                                ),
                                DataCell(Text('${e.registrations}')),
                                DataCell(Text('${e.notifications}')),
                                DataCell(
                                  Wrap(
                                    spacing: 6,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () => _showEventDialog(
                                          editIndex: _events.indexOf(e),
                                        ),
                                        child: const Text('Edit'),
                                      ),
                                      OutlinedButton(
                                        onPressed: () =>
                                            _notifyEvent(_events.indexOf(e)),
                                        child: const Text('Notify'),
                                      ),
                                      FilledButton.tonal(
                                        onPressed: () =>
                                            _togglePublish(_events.indexOf(e)),
                                        child: Text(e.published
                                            ? 'Unpublish'
                                            : 'Publish'),
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
          const _Entrance(
            delayMs: 420,
            child: _AnalyticsSection(),
          ),
          const SizedBox(height: 12),
          const _Entrance(
            delayMs: 500,
            child: WorkflowCard(
              title: 'Islamic Events Workflow',
              steps: [
                'Create Hijri and Gregorian mapped events',
                'Set priority, reminders, and notification templates',
                'Publish to public timeline and campaign channels',
                'Track engagement and update event visibility',
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EventsHero extends StatelessWidget {
  const _EventsHero();

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
            'Events Controller',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Plan, approve, publish, and monitor Islamic events with precise timeline governance and notification control.',
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

class _LifecycleBoard extends StatelessWidget {
  const _LifecycleBoard({
    required this.draftCount,
    required this.reviewCount,
    required this.scheduledCount,
    required this.liveCount,
  });

  final int draftCount;
  final int reviewCount;
  final int scheduledCount;
  final int liveCount;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 900;
        final width =
            narrow ? constraints.maxWidth : (constraints.maxWidth - 36) / 4;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: width,
              child: _StageCard(
                title: 'Draft',
                count: draftCount.toString().padLeft(2, '0'),
                subtitle: 'Not published',
                color: const Color(0xFF6B7280),
              ),
            ),
            SizedBox(
              width: width,
              child: _StageCard(
                title: 'In Review',
                count: reviewCount.toString().padLeft(2, '0'),
                subtitle: 'Awaiting approval',
                color: const Color(0xFF1565C0),
              ),
            ),
            SizedBox(
              width: width,
              child: _StageCard(
                title: 'Scheduled',
                count: scheduledCount.toString().padLeft(2, '0'),
                subtitle: 'Next 30 days',
                color: const Color(0xFFF9A825),
              ),
            ),
            SizedBox(
              width: width,
              child: _StageCard(
                title: 'Live / Published',
                count: liveCount.toString().padLeft(2, '0'),
                subtitle: 'Visible to users',
                color: const Color(0xFF2E7D32),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AnalyticsSection extends StatelessWidget {
  const _AnalyticsSection();

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
                  title: 'Engagement Trend',
                  child: SizedBox(height: 220, child: _EventsLineChart()),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: width,
                child: const SectionCard(
                  title: 'Channel Performance',
                  child: SizedBox(height: 220, child: _ChannelBarChart()),
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
                title: 'Engagement Trend',
                child: SizedBox(height: 220, child: _EventsLineChart()),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: width,
              child: const SectionCard(
                title: 'Channel Performance',
                child: SizedBox(height: 220, child: _ChannelBarChart()),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EventsLineChart extends StatelessWidget {
  const _EventsLineChart();

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => const FlLine(
            color: Color(0x160B6B46),
            strokeWidth: 1,
          ),
        ),
        titlesData: const FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(1, 10),
              FlSpot(2, 18),
              FlSpot(3, 22),
              FlSpot(4, 26),
              FlSpot(5, 31),
              FlSpot(6, 36),
            ],
            isCurved: true,
            barWidth: 3.5,
            color: const Color(0xFF0B6B46),
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

class _ChannelBarChart extends StatelessWidget {
  const _ChannelBarChart();

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => const FlLine(
            color: Color(0x160B6B46),
            strokeWidth: 1,
          ),
        ),
        titlesData: const FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(toY: 68, color: Color(0xFF2E7D32), width: 14),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(toY: 52, color: Color(0xFF1565C0), width: 14),
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(toY: 40, color: Color(0xFFF9A825), width: 14),
            ],
          ),
          BarChartGroupData(
            x: 3,
            barRods: [
              BarChartRodData(toY: 28, color: Color(0xFF6A1B9A), width: 14),
            ],
          ),
        ],
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

  final _EventStatus status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case _EventStatus.draft:
        return const _Pill(label: 'Draft', color: Color(0xFF6B7280));
      case _EventStatus.review:
        return const _Pill(label: 'Review', color: Color(0xFF1565C0));
      case _EventStatus.scheduled:
        return const _Pill(label: 'Scheduled', color: Color(0xFFF9A825));
      case _EventStatus.live:
        return const _Pill(label: 'Live', color: Color(0xFF2E7D32));
    }
  }
}

class _EventItem {
  const _EventItem({
    required this.title,
    required this.hijriDate,
    required this.gregorianDate,
    required this.scope,
    required this.status,
    required this.published,
    required this.registrations,
    required this.notifications,
  });

  final String title;
  final String hijriDate;
  final String gregorianDate;
  final String scope;
  final _EventStatus status;
  final bool published;
  final int registrations;
  final int notifications;

  _EventItem copyWith({
    String? title,
    String? hijriDate,
    String? gregorianDate,
    String? scope,
    _EventStatus? status,
    bool? published,
    int? registrations,
    int? notifications,
  }) {
    return _EventItem(
      title: title ?? this.title,
      hijriDate: hijriDate ?? this.hijriDate,
      gregorianDate: gregorianDate ?? this.gregorianDate,
      scope: scope ?? this.scope,
      status: status ?? this.status,
      published: published ?? this.published,
      registrations: registrations ?? this.registrations,
      notifications: notifications ?? this.notifications,
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

enum _EventStatus { draft, review, scheduled, live }

extension on _EventStatus {
  String get label {
    switch (this) {
      case _EventStatus.draft:
        return 'Draft';
      case _EventStatus.review:
        return 'Review';
      case _EventStatus.scheduled:
        return 'Scheduled';
      case _EventStatus.live:
        return 'Live';
    }
  }
}

const List<_EventItem> _seedEvents = <_EventItem>[
  _EventItem(
    title: 'Eid al-Fitr Prayer',
    hijriDate: '1 Shawwal 1447',
    gregorianDate: '31 Mar 2026',
    scope: 'Global',
    status: _EventStatus.scheduled,
    published: true,
    registrations: 78000,
    notifications: 125000,
  ),
  _EventItem(
    title: 'Ashura Lecture Series',
    hijriDate: '10 Muharram 1448',
    gregorianDate: '16 Jul 2026',
    scope: 'Regional',
    status: _EventStatus.review,
    published: true,
    registrations: 21400,
    notifications: 33600,
  ),
  _EventItem(
    title: 'Ramadan Qiyam Program',
    hijriDate: '18 Ramadan 1447',
    gregorianDate: '12 Mar 2026',
    scope: 'Global',
    status: _EventStatus.draft,
    published: false,
    registrations: 0,
    notifications: 0,
  ),
  _EventItem(
    title: 'Friday Family Workshop',
    hijriDate: 'Weekly',
    gregorianDate: 'Every Friday',
    scope: 'Local',
    status: _EventStatus.live,
    published: true,
    registrations: 8600,
    notifications: 11200,
  ),
];
