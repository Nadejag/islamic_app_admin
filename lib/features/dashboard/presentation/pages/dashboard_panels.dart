part of 'dashboard_page.dart';

class _PendingQueuePanel extends StatelessWidget {
  const _PendingQueuePanel();

  @override
  Widget build(BuildContext context) {
    final queue = context.select((DashboardCubit cubit) => cubit.state.overviewQueue);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF12392A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.stroke),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 18, 18, 14),
              child: Row(
                children: [
                  Text('Pending Approvals Queue', style: TextStyle(color: AppColors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                  Spacer(),
                  Text('View All Queue', style: TextStyle(color: AppColors.green, fontSize: 14, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.stroke),
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 16, 18, 10),
              child: Row(
                children: [
                  Expanded(flex: 4, child: Text('ENTITY', style: tableHeadStyle)),
                  Expanded(flex: 2, child: Text('TYPE', style: tableHeadStyle)),
                  Expanded(flex: 3, child: Text('DATE\nSUBMITTED', style: tableHeadStyle)),
                  Expanded(flex: 2, child: Text('ACTIONS', style: tableHeadStyle)),
                ],
              ),
            ),
            for (final item in queue)
              _QueueRow(
                id: item.id,
                initials: item.initials,
                name: item.name,
                subtitle: item.subtitle,
                type: item.type,
                date: item.date,
                typePurple: item.typePurple,
              ),
            Padding(
              padding: EdgeInsets.only(bottom: 14),
              child: Text('Showing ${queue.length} pending requests', style: TextStyle(color: AppColors.muted, fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }
}

class _PendingQueuePanelCompact extends StatelessWidget {
  const _PendingQueuePanelCompact();

  @override
  Widget build(BuildContext context) {
    final queue = context.select((DashboardCubit cubit) => cubit.state.overviewQueue);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF12392A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.stroke),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(14, 14, 14, 10),
              child: Row(
                children: [
                  Text('Pending Approvals Queue', style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                  Spacer(),
                  Text('View All', style: TextStyle(color: AppColors.green, fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.stroke),
            for (final item in queue)
              _QueueRow(
                id: item.id,
                initials: item.initials,
                name: item.name,
                subtitle: item.subtitle,
                type: item.type,
                date: item.date,
                typePurple: item.typePurple,
                compact: true,
              ),
            Padding(
              padding: EdgeInsets.fromLTRB(12, 6, 12, 12),
              child: Text('Showing ${queue.length} pending requests', style: TextStyle(color: AppColors.muted, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}

class _QueueRow extends StatelessWidget {
  const _QueueRow({
    required this.id,
    required this.initials,
    required this.name,
    required this.subtitle,
    required this.type,
    required this.date,
    this.typePurple = false,
    this.compact = false,
  });

  final String id;
  final String initials;
  final String name;
  final String subtitle;
  final String type;
  final String date;
  final bool typePurple;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0x1FFFFFFF)))),
      padding: EdgeInsets.fromLTRB(compact ? 12 : 18, compact ? 10 : 14, compact ? 12 : 18, compact ? 10 : 14),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Container(
                  width: compact ? 30 : 36,
                  height: compact ? 30 : 36,
                  decoration: BoxDecoration(color: const Color(0xFF20335A), borderRadius: BorderRadius.circular(8)),
                  child: Center(child: Text(initials, style: TextStyle(color: const Color(0xFFE4CC54), fontSize: compact ? 11 : 13, fontWeight: FontWeight.w700))),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: TextStyle(color: AppColors.white, fontSize: compact ? 14 : 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(subtitle, style: TextStyle(color: AppColors.muted, fontSize: compact ? 11 : 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: typePurple ? const Color(0xFF4A2F69).withValues(alpha: 0.18) : const Color(0xFF2B618C).withValues(alpha: 0.20),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: typePurple ? const Color(0xFFB17BFF).withValues(alpha: 0.4) : const Color(0xFF5CC4FF).withValues(alpha: 0.45)),
                ),
                child: Text(
                  type,
                  style: TextStyle(color: typePurple ? const Color(0xFFD6A8FF) : const Color(0xFF80D3FF), fontSize: compact ? 11 : 12, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
          Expanded(flex: 3, child: Text(date, style: TextStyle(color: AppColors.muted, fontSize: compact ? 12 : 13))),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.green,
                    side: const BorderSide(color: AppColors.green),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    textStyle: TextStyle(fontSize: compact ? 12 : 14, fontWeight: FontWeight.w700),
                  ),
                  onPressed: () => context.read<DashboardCubit>().approveOverviewQueueItem(id),
                  child: const Text('Approve'),
                ),
                if (!compact) const SizedBox(height: 6),
                if (!compact)
                  InkWell(
                    onTap: () => context.read<DashboardCubit>().rejectOverviewQueueItem(id),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 2),
                      child: Text('Reject', style: TextStyle(color: AppColors.muted, fontSize: 12)),
                    ),
                  ),
                if (compact)
                  InkWell(
                    onTap: () => context.read<DashboardCubit>().rejectOverviewQueueItem(id),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 4, left: 2),
                      child: Text('Reject', style: TextStyle(color: AppColors.muted, fontSize: 11)),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RightPanels extends StatelessWidget {
  const _RightPanels({required this.onOpenMediaScreen});
  final VoidCallback onOpenMediaScreen;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 7,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              color: const Color(0xFF12392A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.stroke),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text('Content Overview', style: TextStyle(color: AppColors.white, fontSize: 24, fontWeight: FontWeight.w700))),
                    Icon(Icons.more_vert, color: AppColors.muted, size: 18),
                  ],
                ),
                const SizedBox(height: 12),
                _ContentCard(icon: Icons.lightbulb, iconBg: const Color(0xFF0F4D38), title: 'DAILY INSPIRATION', main: 'The Virtue of Sabr (Patience)', status: 'LIVE', progress: 0.93, progressColor: AppColors.green, footer: 'Published 4h ago'),
                const SizedBox(height: 12),
                _ContentCard(icon: Icons.menu_book, iconBg: const Color(0xFF4B4A1C), title: 'QURANIC CONTENT', main: 'Surah Al-Kahf Audio Indexing', status: 'Processing', progress: 0.52, progressColor: const Color(0xFFE2C64A), footer: '98% Synchronized'),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF7FA69A),
                      side: const BorderSide(color: AppColors.stroke),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    onPressed: onOpenMediaScreen,
                    child: const Text('Manage All Media'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            decoration: BoxDecoration(
              color: const Color(0xFF12392A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.stroke),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Platform Health', style: TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                SizedBox(height: 16),
                _HealthRow('API Status', 'OPERATIONAL'),
                SizedBox(height: 10),
                _HealthRow('Database Node 1', '99.9% UPTIME'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RightPanelsCompact extends StatelessWidget {
  const _RightPanelsCompact({required this.onOpenMediaScreen});
  final VoidCallback onOpenMediaScreen;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: BoxDecoration(
            color: const Color(0xFF12392A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.stroke),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Content Overview', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              _ContentCard(icon: Icons.lightbulb, iconBg: const Color(0xFF0F4D38), title: 'DAILY INSPIRATION', main: 'The Virtue of Sabr (Patience)', status: 'LIVE', progress: 0.93, progressColor: AppColors.green, footer: 'Published 4h ago', compact: true),
              const SizedBox(height: 10),
              _ContentCard(icon: Icons.menu_book, iconBg: const Color(0xFF4B4A1C), title: 'QURANIC CONTENT', main: 'Surah Al-Kahf Audio Indexing', status: 'Processing', progress: 0.52, progressColor: const Color(0xFFE2C64A), footer: '98% Synchronized', compact: true),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF7FA69A),
                    side: const BorderSide(color: AppColors.stroke),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  onPressed: onOpenMediaScreen,
                  child: const Text('Manage All Media'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: BoxDecoration(
            color: const Color(0xFF12392A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.stroke),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Platform Health', style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w700)),
              SizedBox(height: 10),
              _HealthRow('API Status', 'OPERATIONAL'),
              SizedBox(height: 8),
              _HealthRow('Database Node 1', '99.9% UPTIME'),
            ],
          ),
        ),
      ],
    );
  }
}

class _WeeklyGoalsOverviewPanel extends StatelessWidget {
  const _WeeklyGoalsOverviewPanel({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        compact ? 12 : 14,
        compact ? 12 : 14,
        compact ? 12 : 14,
        compact ? 12 : 14,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF12392A), Color(0xFF0E3226)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: compact ? 34 : 38,
                height: compact ? 34 : 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF0A4B35),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.flag_circle_rounded,
                  color: AppColors.green,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly Goals',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: compact ? 16 : 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Prayer, Quran, and important habits',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: compact ? 11 : 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (!compact)
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.green,
                    side: const BorderSide(color: AppColors.stroke),
                  ),
                  onPressed: () => _showWeeklyGoalEditor(context),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Goal'),
                ),
              const SizedBox(width: 8),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: const Color(0xFF032519),
                  textStyle: TextStyle(
                    fontSize: compact ? 12 : 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: () => _showWeeklyGoalsManager(context),
                icon: const Icon(Icons.tune, size: 16),
                label: const Text('Manage'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: compact ? 138 : 156,
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('home_weekly_goals')
                  .orderBy('order')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Could not load weekly goals.',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  );
                }
                final docs = snapshot.data?.docs ?? const [];
                if (docs.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B3023),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.stroke),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'No weekly goals yet. Tap Add Goal to create one.',
                            style: TextStyle(color: AppColors.muted),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () => _showWeeklyGoalEditor(context),
                          child: const Text('Add Goal'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) =>
                      _WeeklyGoalOverviewCard(doc: docs[index], compact: compact),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyGoalOverviewCard extends StatelessWidget {
  const _WeeklyGoalOverviewCard({required this.doc, this.compact = false});

  final QueryDocumentSnapshot<Map<String, dynamic>> doc;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final data = doc.data();
    final rawTitle = ((data['title'] as String?) ?? '').trim();
    final title = rawTitle.isEmpty ? doc.id : rawTitle;
    final completed = _weeklyGoalToDouble(data['completed']);
    final target = _weeklyGoalToDouble(data['target']);
    final unit = ((data['unit'] as String?) ?? '').trim();
    final color = _weeklyGoalColorFromHex((data['color'] as String?) ?? '');
    final percent = target <= 0 ? 0.0 : (completed / target).clamp(0.0, 1.0);
    final metric = unit.isEmpty
        ? '${completed.toStringAsFixed(0)} / ${target.toStringAsFixed(0)}'
        : '${completed.toStringAsFixed(0)}$unit / ${target.toStringAsFixed(0)}$unit';

    return InkWell(
      onTap: () => _showWeeklyGoalEditor(context, doc: doc),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: compact ? 180 : 206,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.lerp(const Color(0xFF0A3023), color, 0.22)!,
              const Color(0xFF0A3023),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.45)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: compact ? 44 : 50,
              height: compact ? 44 : 50,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: percent,
                    strokeWidth: 5,
                    backgroundColor: const Color(0xFF19483A),
                    color: color,
                  ),
                  Text(
                    '${(percent * 100).round()}%',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: compact ? 10 : 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: compact ? 13 : 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    metric,
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: compact ? 11 : 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFF174538),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: FractionallySizedBox(
                      widthFactor: percent,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.main,
    required this.status,
    required this.progress,
    required this.progressColor,
    required this.footer,
    this.compact = false,
  });

  final IconData icon;
  final Color iconBg;
  final String title;
  final String main;
  final String status;
  final double progress;
  final Color progressColor;
  final String footer;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F3427),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(9)),
                child: Icon(icon, color: AppColors.green, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(title, style: TextStyle(color: const Color(0xFF7A968A), fontSize: compact ? 11 : 12, fontWeight: FontWeight.w700))),
                        Text(status, style: const TextStyle(color: AppColors.green, fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(main, style: TextStyle(color: AppColors.white, fontSize: compact ? 13 : 15, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _AnimatedBar(progress: progress, color: progressColor),
          const SizedBox(height: 8),
          Text(footer, style: TextStyle(color: AppColors.muted, fontSize: compact ? 11 : 12)),
        ],
      ),
    );
  }
}

class _WeeklyGoalsManagementBody extends StatelessWidget {
  const _WeeklyGoalsManagementBody({this.compact = false, this.mobile = false});

  final bool compact;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final titleSize = mobile ? 26.0 : (compact ? 30.0 : 38.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weekly Goals',
          style: TextStyle(
            color: AppColors.white,
            fontSize: titleSize,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Create goals like Prayer, Quran, and important weekly habits for the home screen.',
          style: TextStyle(
            color: AppColors.muted,
            fontSize: mobile ? 12 : 13,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: const Color(0xFF032519),
              ),
              onPressed: () => _showWeeklyGoalEditor(context),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Goal'),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: () => _showWeeklyGoalsManager(context),
              icon: const Icon(Icons.tune, size: 17),
              label: const Text('Advanced Manager'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _WeeklyGoalsOverviewPanel(compact: compact || mobile),
        const SizedBox(height: 12),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF12392A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.stroke),
            ),
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('home_weekly_goals')
                  .orderBy('order')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Failed to load weekly goals.',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  );
                }
                final docs = snapshot.data?.docs ?? const [];
                if (docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No goals found. Tap Add Goal to create one.',
                      style: TextStyle(color: AppColors.muted),
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) =>
                      _WeeklyGoalAdminTile(doc: docs[index]),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> _showWeeklyGoalsManager(BuildContext context) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF0A2F23),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => const SafeArea(
      child: FractionallySizedBox(
        heightFactor: 0.92,
        child: _WeeklyGoalsAdminSheet(),
      ),
    ),
  );
}

class _WeeklyGoalsAdminSheet extends StatelessWidget {
  const _WeeklyGoalsAdminSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.strokeBright,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Weekly Goals',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: const Color(0xFF032519),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => _showWeeklyGoalEditor(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Goal'),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Create and update goals like Prayer, Quran, and other important weekly targets.',
            style: TextStyle(color: AppColors.muted, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('home_weekly_goals')
                  .orderBy('order')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Unable to load weekly goals: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  );
                }
                final docs = snapshot.data?.docs ?? const [];
                if (docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'No weekly goals yet.',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Use "Add Goal" to create the first weekly target.',
                          style: TextStyle(color: AppColors.muted),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          onPressed: () => _showWeeklyGoalEditor(context),
                          icon: const Icon(Icons.add),
                          label: const Text('Add First Goal'),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return _WeeklyGoalAdminTile(doc: docs[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyGoalAdminTile extends StatelessWidget {
  const _WeeklyGoalAdminTile({required this.doc});

  final QueryDocumentSnapshot<Map<String, dynamic>> doc;

  @override
  Widget build(BuildContext context) {
    final data = doc.data();
    final title = ((data['title'] as String?) ?? '').trim();
    final completed = _weeklyGoalToDouble(data['completed']);
    final target = _weeklyGoalToDouble(data['target']);
    final unit = ((data['unit'] as String?) ?? '').trim();
    final order = (data['order'] as num?)?.toInt() ?? 0;
    final color = _weeklyGoalColorFromHex((data['color'] as String?) ?? '');
    final percent = target <= 0 ? 0.0 : (completed / target).clamp(0.0, 1.0);
    final subtitle = target <= 0
        ? '${completed.toStringAsFixed(0)} completed'
        : unit.isEmpty
        ? '${completed.toStringAsFixed(0)} / ${target.toStringAsFixed(0)}'
        : '${completed.toStringAsFixed(0)}$unit / ${target.toStringAsFixed(0)}$unit';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(const Color(0xFF12392A), color, 0.15)!,
            const Color(0xFF12392A),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title.isEmpty ? doc.id : title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF0E3529),
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: AppColors.stroke),
                ),
                child: Text(
                  'Order $order',
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(color: AppColors.muted, fontSize: 12),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percent,
            minHeight: 7,
            color: color,
            backgroundColor: const Color(0xFF0A2F23),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () => _showWeeklyGoalEditor(context, doc: doc),
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Edit'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFF9090),
                  side: const BorderSide(color: Color(0xFF6A2E2E)),
                ),
                onPressed: () => _deleteWeeklyGoal(context, doc),
                icon: const Icon(Icons.delete_outline, size: 16),
                label: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

const List<String> _weeklyGoalPresetHex = [
  '#1FF08D',
  '#59C4FF',
  '#F7C948',
  '#FF8A65',
  '#C792EA',
  '#FF6B8A',
  '#00D2B8',
  '#90CAF9',
];

Future<void> _showWeeklyGoalEditor(
  BuildContext context, {
  QueryDocumentSnapshot<Map<String, dynamic>>? doc,
}) async {
  final existing = doc?.data() ?? const <String, dynamic>{};
  final titleCtl = TextEditingController(
    text: ((existing['title'] as String?) ?? '').trim(),
  );
  final targetCtl = TextEditingController(
    text: _weeklyGoalToDouble(existing['target']).toStringAsFixed(0),
  );
  final completedCtl = TextEditingController(
    text: _weeklyGoalToDouble(existing['completed']).toStringAsFixed(0),
  );
  final unitCtl = TextEditingController(
    text: ((existing['unit'] as String?) ?? '').trim(),
  );
  final orderCtl = TextEditingController(
    text: ((existing['order'] as num?)?.toInt() ?? 0).toString(),
  );
  final colorCtl = TextEditingController(
    text: ((existing['color'] as String?) ?? '').trim(),
  );
  var selectedColorHex = _normalizeWeeklyGoalColorHex(colorCtl.text);
  if (selectedColorHex.isEmpty) {
    selectedColorHex = _weeklyGoalPresetHex.first;
  }
  colorCtl.text = selectedColorHex;

  final confirmed =
      await showDialog<bool>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (context, setState) {
            final preview = _weeklyGoalColorFromHex(selectedColorHex);
            return AlertDialog(
              backgroundColor: const Color(0xFF103628),
              title: Text(
                doc == null ? 'Add Weekly Goal' : 'Edit Weekly Goal',
                style: const TextStyle(color: AppColors.white),
              ),
              content: SizedBox(
                width: 430,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: titleCtl,
                        style: const TextStyle(color: AppColors.white),
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          hintText: 'Prayer, Quran, Charity...',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: targetCtl,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: AppColors.white),
                              decoration: const InputDecoration(
                                labelText: 'Target',
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: completedCtl,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: AppColors.white),
                              decoration: const InputDecoration(
                                labelText: 'Completed',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: unitCtl,
                              style: const TextStyle(color: AppColors.white),
                              decoration: const InputDecoration(
                                labelText: 'Unit (optional)',
                                hintText: 'times, pages',
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: orderCtl,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: AppColors.white),
                              decoration: const InputDecoration(
                                labelText: 'Order',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Goal Color',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _weeklyGoalPresetHex.map((hex) {
                          final swatch = _weeklyGoalColorFromHex(hex);
                          final active = selectedColorHex == hex;
                          return InkWell(
                            onTap: () {
                              setState(() => selectedColorHex = hex);
                              colorCtl.text = hex;
                            },
                            borderRadius: BorderRadius.circular(99),
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: swatch,
                                borderRadius: BorderRadius.circular(99),
                                border: Border.all(
                                  color: active
                                      ? AppColors.white
                                      : Colors.white.withValues(alpha: 0.35),
                                  width: active ? 2 : 1,
                                ),
                              ),
                              child: active
                                  ? const Icon(
                                      Icons.check,
                                      size: 15,
                                      color: Color(0xFF032519),
                                    )
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: preview,
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: colorCtl,
                              style: const TextStyle(color: AppColors.white),
                              decoration: const InputDecoration(
                                labelText: 'Custom Color Hex',
                                hintText: '#1FF08D',
                              ),
                              onChanged: (value) {
                                final normalized =
                                    _normalizeWeeklyGoalColorHex(value);
                                if (normalized.isNotEmpty) {
                                  setState(() => selectedColorHex = normalized);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        ),
      ) ??
      false;

  if (!confirmed) return;

  final title = titleCtl.text.trim();
  if (title.isEmpty) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Title is required.')));
    return;
  }

  final target = _weeklyGoalParseDouble(targetCtl.text.trim());
  final completed = _weeklyGoalParseDouble(completedCtl.text.trim());
  final order = int.tryParse(orderCtl.text.trim()) ?? 0;
  final payload = <String, dynamic>{
    'title': title,
    'target': target < 0 ? 0.0 : target,
    'completed': completed < 0 ? 0.0 : completed,
    'unit': unitCtl.text.trim(),
    'order': order,
    'color': _normalizeWeeklyGoalColorHex(colorCtl.text.trim()),
    'updatedAt': FieldValue.serverTimestamp(),
  };

  try {
    final goals = FirebaseFirestore.instance.collection('home_weekly_goals');
    if (doc == null) {
      payload['createdAt'] = FieldValue.serverTimestamp();
      await goals.add(payload);
    } else {
      await goals.doc(doc.id).set(payload, SetOptions(merge: true));
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          doc == null ? 'Weekly goal created.' : 'Weekly goal updated.',
        ),
      ),
    );
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Could not save goal: $e')));
  }
}

Future<void> _deleteWeeklyGoal(
  BuildContext context,
  QueryDocumentSnapshot<Map<String, dynamic>> doc,
) async {
  final data = doc.data();
  final title = ((data['title'] as String?) ?? '').trim();
  final confirmed =
      await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: const Color(0xFF103628),
          title: const Text(
            'Delete Weekly Goal?',
            style: TextStyle(color: AppColors.white),
          ),
          content: Text(
            'This will remove "${title.isEmpty ? doc.id : title}" from home weekly goals.',
            style: const TextStyle(color: AppColors.muted),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF8A2D2D),
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Delete'),
            ),
          ],
        ),
      ) ??
      false;

  if (!confirmed) return;
  try {
    await FirebaseFirestore.instance
        .collection('home_weekly_goals')
        .doc(doc.id)
        .delete();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Weekly goal deleted.')),
    );
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Could not delete goal: $e')));
  }
}

double _weeklyGoalParseDouble(String value) => double.tryParse(value) ?? 0.0;

double _weeklyGoalToDouble(Object? value) =>
    (value as num?)?.toDouble() ?? 0.0;

String _normalizeWeeklyGoalColorHex(String raw) {
  final cleaned = raw.trim().replaceAll('#', '');
  if (cleaned.length == 6 && int.tryParse(cleaned, radix: 16) != null) {
    return '#${cleaned.toUpperCase()}';
  }
  if (cleaned.length == 8 && int.tryParse(cleaned, radix: 16) != null) {
    return '#${cleaned.substring(2).toUpperCase()}';
  }
  return '';
}

Color _weeklyGoalColorFromHex(String raw) {
  final cleaned = _normalizeWeeklyGoalColorHex(raw).replaceAll('#', '');
  if (cleaned.length == 6) {
    final parsed = int.tryParse('FF$cleaned', radix: 16);
    if (parsed != null) return Color(parsed);
  }
  return AppColors.green;
}

class _CharityApprovalsBody extends StatelessWidget {
  const _CharityApprovalsBody({this.compact = false, this.mobile = false});

  final bool compact;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DashboardCubit>().state;
    final requests = state.pendingCharityRequests;
    final selectedRequest = state.selectedCharityRequest;
    final titleSize = mobile ? 24.0 : (compact ? 32.0 : 40.0);
    final showAsCards = compact || mobile;
    final topGap = mobile ? 10.0 : 14.0;
    final totalFunds = _formatTotalFunds(requests);
    final activeCampaigns = state.charityRequests.where((request) => request.status == 'APPROVED').length;

    if (selectedRequest != null) {
      return _CharityApprovalDetail(
        request: selectedRequest,
        compact: compact,
        mobile: mobile,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Charity Approvals',
          style: TextStyle(
            color: AppColors.white,
            fontSize: titleSize,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: topGap),
        if (showAsCards)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _CharityMetricsWrap(
                    compact: compact,
                    mobile: mobile,
                    totalFunds: totalFunds,
                    pendingCount: state.charityPendingCount,
                    activeCampaigns: activeCampaigns,
                  ),
                  const SizedBox(height: 12),
                  _CharityRequestsPanel(
                    requests: requests,
                    compact: compact,
                    mobile: mobile,
                  ),
                  const SizedBox(height: 12),
                  _CharityBottomCards(compact: compact, mobile: mobile),
                ],
              ),
            ),
          )
        else ...[
          _CharityMetricsRow(
            totalFunds: totalFunds,
            pendingCount: state.charityPendingCount,
            activeCampaigns: activeCampaigns,
          ),
          const SizedBox(height: 14),
          Expanded(
            child: _CharityRequestsPanel(requests: requests),
          ),
          const SizedBox(height: 14),
          const _CharityBottomCards(),
        ],
      ],
    );
  }

  static int _extractAmountValue(String amount) {
    final digits = amount.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
  }

  static String _formatTotalFunds(List<CharityRequest> requests) {
    final total = requests.fold<int>(0, (sum, request) => sum + _extractAmountValue(request.amount));
    if (total >= 1000000) {
      return '\$${(total / 1000000).toStringAsFixed(2)}M';
    }
    if (total >= 1000) {
      return '\$${(total / 1000).toStringAsFixed(0)}K';
    }
    return '\$$total';
  }
}

class _CharityMetricsRow extends StatelessWidget {
  const _CharityMetricsRow({
    required this.totalFunds,
    required this.pendingCount,
    required this.activeCampaigns,
  });

  final String totalFunds;
  final int pendingCount;
  final int activeCampaigns;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _CharityMetricCard(
            title: 'TOTAL FUNDS SOUGHT',
            value: totalFunds,
            subtitle: '+18% from last month',
            icon: Icons.payments_outlined,
            tone: _CharityMetricTone.success,
          ),
        ),
        SizedBox(width: 14),
        Expanded(
          child: _CharityMetricCard(
            title: 'PENDING APPROVALS',
            value: '$pendingCount',
            subtitle: pendingCount == 0 ? 'Queue is clear' : 'Requires manual review',
            icon: Icons.assignment_outlined,
            tone: _CharityMetricTone.warning,
          ),
        ),
        SizedBox(width: 14),
        Expanded(
          child: _CharityMetricCard(
            title: 'ACTIVE CAMPAIGNS',
            value: '$activeCampaigns',
            subtitle: 'Approved and currently active',
            icon: Icons.campaign_outlined,
            tone: _CharityMetricTone.info,
          ),
        ),
      ],
    );
  }
}

class _CharityApprovalDetail extends StatefulWidget {
  const _CharityApprovalDetail({
    required this.request,
    this.compact = false,
    this.mobile = false,
  });

  final CharityRequest request;
  final bool compact;
  final bool mobile;

  @override
  State<_CharityApprovalDetail> createState() => _CharityApprovalDetailState();
}

class _CharityApprovalDetailState extends State<_CharityApprovalDetail> {
  bool identityVerified = false;
  bool financialNeedConfirmed = true;
  bool bankValidated = false;
  bool taxCompliance = false;
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final request = widget.request;
    final compact = widget.compact;
    final mobile = widget.mobile;
    final titleSize = mobile ? 24.0 : (compact ? 28.0 : 34.0);

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => context.read<DashboardCubit>().closeCharityRequestDetail(),
              icon: const Icon(Icons.arrow_back, color: AppColors.item),
            ),
            Expanded(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                runSpacing: 6,
                children: [
                  Text(
                    'Review ${request.name}',
                    style: TextStyle(color: AppColors.white, fontSize: titleSize, fontWeight: FontWeight.w700),
                  ),
                  const _StatusChip(text: 'PENDING REVIEW'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: mobile || compact
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      _CharityOverviewCard(request: request),
                      const SizedBox(height: 12),
                      _DueDiligencePanel(
                        identityVerified: identityVerified,
                        financialNeedConfirmed: financialNeedConfirmed,
                        bankValidated: bankValidated,
                        taxCompliance: taxCompliance,
                        noteController: _noteController,
                        onIdentityChanged: (value) => setState(() => identityVerified = value),
                        onFinancialChanged: (value) => setState(() => financialNeedConfirmed = value),
                        onBankChanged: (value) => setState(() => bankValidated = value),
                        onTaxChanged: (value) => setState(() => taxCompliance = value),
                      ),
                    ],
                  ),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 10, child: _CharityOverviewCard(request: request)),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 6,
                      child: _DueDiligencePanel(
                        identityVerified: identityVerified,
                        financialNeedConfirmed: financialNeedConfirmed,
                        bankValidated: bankValidated,
                        taxCompliance: taxCompliance,
                        noteController: _noteController,
                        onIdentityChanged: (value) => setState(() => identityVerified = value),
                        onFinancialChanged: (value) => setState(() => financialNeedConfirmed = value),
                        onBankChanged: (value) => setState(() => bankValidated = value),
                        onTaxChanged: (value) => setState(() => taxCompliance = value),
                      ),
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 12),
        _DetailActionBar(
          onReject: () => context.read<DashboardCubit>().rejectCharityRequest(request.id),
          onApprove: () => context.read<DashboardCubit>().approveCharityRequest(request.id),
        ),
      ],
    );
  }
}

class _CharityOverviewCard extends StatelessWidget {
  const _CharityOverviewCard({required this.request});

  final CharityRequest request;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF12392A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Campaign Overview', style: TextStyle(color: AppColors.white, fontSize: 26, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          const Text('CAMPAIGN TITLE', style: TextStyle(color: AppColors.muted, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: .7)),
          const SizedBox(height: 4),
          Text(request.name, style: const TextStyle(color: AppColors.white, fontSize: 30, fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          const Text('MISSION STATEMENT', style: TextStyle(color: AppColors.muted, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: .7)),
          const SizedBox(height: 4),
          Text(
            'Provide urgent relief for vulnerable families and verified local communities. '
            'Funds will be disbursed in audited phases after compliance checks are completed.',
            style: const TextStyle(color: AppColors.item, fontSize: 18, height: 1.45),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F3427),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.stroke),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('TARGET GOAL', style: TextStyle(color: AppColors.muted, fontSize: 11, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(request.amount, style: const TextStyle(color: AppColors.green, fontSize: 34, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: _KeyValueCard(label: 'REQUESTED FOR', value: 'Emergency Relief'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F3427),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.stroke),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: request.iconBg, borderRadius: BorderRadius.circular(12)),
                  child: Icon(request.icon, color: request.iconColor),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(request.solicitor, style: const TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text('Submitted ${request.submittedOn}', style: const TextStyle(color: AppColors.muted, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KeyValueCard extends StatelessWidget {
  const _KeyValueCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F3427),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 11, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(color: AppColors.white, fontSize: 28, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _DueDiligencePanel extends StatelessWidget {
  const _DueDiligencePanel({
    required this.identityVerified,
    required this.financialNeedConfirmed,
    required this.bankValidated,
    required this.taxCompliance,
    required this.noteController,
    required this.onIdentityChanged,
    required this.onFinancialChanged,
    required this.onBankChanged,
    required this.onTaxChanged,
  });

  final bool identityVerified;
  final bool financialNeedConfirmed;
  final bool bankValidated;
  final bool taxCompliance;
  final TextEditingController noteController;
  final ValueChanged<bool> onIdentityChanged;
  final ValueChanged<bool> onFinancialChanged;
  final ValueChanged<bool> onBankChanged;
  final ValueChanged<bool> onTaxChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF12392A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('DUE DILIGENCE CHECKLIST', style: TextStyle(color: AppColors.item, fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          _ChecklistItem(
            title: 'Identity Verified',
            value: identityVerified,
            onChanged: onIdentityChanged,
          ),
          const SizedBox(height: 8),
          _ChecklistItem(
            title: 'Financial Need Confirmed',
            value: financialNeedConfirmed,
            onChanged: onFinancialChanged,
          ),
          const SizedBox(height: 8),
          _ChecklistItem(
            title: 'Bank Details Validated',
            value: bankValidated,
            onChanged: onBankChanged,
          ),
          const SizedBox(height: 8),
          _ChecklistItem(
            title: 'Tax Compliance Check',
            value: taxCompliance,
            onChanged: onTaxChanged,
          ),
          const SizedBox(height: 18),
          const Text('INTERNAL NOTES', style: TextStyle(color: AppColors.item, fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: .6)),
          const SizedBox(height: 8),
          TextField(
            controller: noteController,
            maxLines: 5,
            style: const TextStyle(color: AppColors.white),
            decoration: InputDecoration(
              hintText: 'Add a private note for other admins...',
              hintStyle: const TextStyle(color: AppColors.muted),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.stroke)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.green)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: value ? const Color(0xFF0F4A35).withValues(alpha: 0.45) : const Color(0xFF0F3427),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: (next) => onChanged(next ?? false),
            activeColor: AppColors.green,
          ),
          Expanded(child: Text(title, style: const TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}

class _DetailActionBar extends StatelessWidget {
  const _DetailActionBar({
    required this.onReject,
    required this.onApprove,
  });

  final VoidCallback onReject;
  final VoidCallback onApprove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF12392A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onReject,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFFF7373)),
                foregroundColor: const Color(0xFFFF7373),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Reject with Feedback', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton(
              onPressed: onApprove,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: const Color(0xFF032519),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Approve & List Publicly', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF4A431D).withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2C64A).withValues(alpha: 0.45)),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFFE2C64A), fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _CharityMetricsWrap extends StatelessWidget {
  const _CharityMetricsWrap({
    required this.totalFunds,
    required this.pendingCount,
    required this.activeCampaigns,
    this.compact = false,
    this.mobile = false,
  });

  final String totalFunds;
  final int pendingCount;
  final int activeCampaigns;
  final bool compact;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final spacing = mobile ? 10.0 : 12.0;
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: [
        SizedBox(
          width: double.infinity,
          child: _CharityMetricCard(
            compact: compact,
            title: 'TOTAL FUNDS SOUGHT',
            value: totalFunds,
            subtitle: '+18% from last month',
            icon: Icons.payments_outlined,
            tone: _CharityMetricTone.success,
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: _CharityMetricCard(
            compact: compact,
            title: 'PENDING APPROVALS',
            value: '$pendingCount',
            subtitle: pendingCount == 0 ? 'Queue is clear' : 'Requires manual review',
            icon: Icons.assignment_outlined,
            tone: _CharityMetricTone.warning,
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: _CharityMetricCard(
            compact: compact,
            title: 'ACTIVE CAMPAIGNS',
            value: '$activeCampaigns',
            subtitle: 'Approved and currently active',
            icon: Icons.campaign_outlined,
            tone: _CharityMetricTone.info,
          ),
        ),
      ],
    );
  }
}

class _CharityMetricCard extends StatelessWidget {
  const _CharityMetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.tone,
    this.compact = false,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final _CharityMetricTone tone;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final accent = switch (tone) {
      _CharityMetricTone.success => AppColors.green,
      _CharityMetricTone.warning => const Color(0xFFE2C64A),
      _CharityMetricTone.info => const Color(0xFF6EC4FF),
    };
    final iconBg = switch (tone) {
      _CharityMetricTone.success => const Color(0xFF0F4A35),
      _CharityMetricTone.warning => const Color(0xFF4A431D),
      _CharityMetricTone.info => const Color(0xFF153F58),
    };
    return Container(
      padding: EdgeInsets.all(compact ? 14 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFF12392A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF7E9E92),
                    fontSize: compact ? 11 : 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .7,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  value,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: compact ? 34 : 46,
                    fontWeight: FontWeight.w700,
                    height: .95,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: accent,
                    fontSize: compact ? 12 : 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: compact ? 36 : 42,
            height: compact ? 36 : 42,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accent, size: compact ? 18 : 20),
          ),
        ],
      ),
    );
  }
}

class _CharityRequestsPanel extends StatelessWidget {
  const _CharityRequestsPanel({
    required this.requests,
    this.compact = false,
    this.mobile = false,
  });

  final List<CharityRequest> requests;
  final bool compact;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF12392A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              compact || mobile ? 14 : 18,
              compact || mobile ? 14 : 16,
              compact || mobile ? 14 : 18,
              12,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pending Charity Requests',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: compact || mobile ? 20 : 38,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Review and verify upcoming donation campaigns',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: compact || mobile ? 12 : 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!mobile) ...[
                  const _SubtleOutlineButton(label: 'Filter'),
                  const SizedBox(width: 8),
                  const _SubtleOutlineButton(label: 'Sort'),
                ],
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.stroke),
          if (mobile || compact)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: requests.isEmpty
                  ? const Padding(
                      key: ValueKey('charity-empty-cards'),
                      padding: EdgeInsets.fromLTRB(12, 20, 12, 20),
                      child: Text(
                        'All charity requests are resolved.',
                        style: TextStyle(color: AppColors.muted, fontSize: 13),
                      ),
                    )
                  : Padding(
                      key: ValueKey('charity-cards'),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          for (final request in requests) ...[
                            _CharityRequestCard(request: request, compact: compact),
                            const SizedBox(height: 10),
                          ],
                        ],
                      ),
                    ),
            )
          else
            Expanded(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(18, 14, 18, 10),
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: Text('REQUEST NAME', style: tableHeadStyle)),
                        Expanded(flex: 2, child: Text('SOLICITOR', style: tableHeadStyle)),
                        Expanded(flex: 3, child: Text('TARGET AMOUNT', style: tableHeadStyle)),
                        Expanded(flex: 2, child: Text('DATE SUBMITTED', style: tableHeadStyle)),
                        Expanded(flex: 2, child: Text('VERIFICATION STATUS', style: tableHeadStyle)),
                        Expanded(flex: 2, child: Align(alignment: Alignment.centerRight, child: Text('ACTIONS', style: tableHeadStyle))),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.stroke),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      child: requests.isEmpty
                          ? const Center(
                              key: ValueKey('charity-empty-table'),
                              child: Text(
                                'All charity requests are resolved.',
                                style: TextStyle(color: AppColors.muted, fontSize: 14),
                              ),
                            )
                          : ListView.separated(
                              key: const ValueKey('charity-table'),
                              itemBuilder: (context, index) => _CharityRequestTableRow(
                                request: requests[index],
                              ),
                              separatorBuilder: (_, _) =>
                                  const Divider(height: 1, color: AppColors.stroke),
                              itemCount: requests.length,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              compact || mobile ? 14 : 18,
              6,
              compact || mobile ? 14 : 18,
              12,
            ),
            child: Row(
              children: [
                Text(
                  'Showing ${requests.length} pending requests',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: compact || mobile ? 11 : 13,
                  ),
                ),
                const Spacer(),
                const _PaginationArrow(icon: Icons.chevron_left),
                const SizedBox(width: 6),
                const _PaginationChip(text: '1', active: true),
                const SizedBox(width: 6),
                const _PaginationChip(text: '2'),
                const SizedBox(width: 6),
                const _PaginationChip(text: '3'),
                const SizedBox(width: 6),
                const _PaginationArrow(icon: Icons.chevron_right),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CharityRequestTableRow extends StatelessWidget {
  const _CharityRequestTableRow({required this.request});

  final CharityRequest request;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.read<DashboardCubit>().openCharityRequestDetail(request.id),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
        child: Row(
          children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: request.iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(request.icon, color: request.iconColor, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.name,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        request.category,
                        style: const TextStyle(color: AppColors.muted, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              request.solicitor,
              style: const TextStyle(color: AppColors.item, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.amount,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: request.progress,
                    minHeight: 8,
                    backgroundColor: const Color(0xFF2A4B3F),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.green),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              request.submittedOn,
              style: const TextStyle(color: AppColors.muted, fontSize: 14),
            ),
          ),
          Expanded(flex: 2, child: _CharityStatusPill(request: request)),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ActionButton(
                    label: 'Approve',
                    background: AppColors.green,
                    foreground: const Color(0xFF032519),
                    onPressed: () => context.read<DashboardCubit>().approveCharityRequest(request.id),
                  ),
                  const SizedBox(width: 8),
                  _ActionButton(
                    label: 'Reject',
                    outlined: true,
                    foreground: Color(0xFFFF7373),
                    onPressed: () => context.read<DashboardCubit>().rejectCharityRequest(request.id),
                  ),
                ],
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}

class _CharityRequestCard extends StatelessWidget {
  const _CharityRequestCard({required this.request, this.compact = false});

  final CharityRequest request;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final titleSize = compact ? 16.0 : 18.0;
    return InkWell(
      onTap: () => context.read<DashboardCubit>().openCharityRequestDetail(request.id),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF0F3427),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.stroke),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: request.iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(request.icon, color: request.iconColor, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  request.name,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: titleSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            request.category,
            style: const TextStyle(color: AppColors.muted, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Text(
            request.solicitor,
            style: const TextStyle(color: AppColors.item, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                request.amount,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                request.submittedOn,
                style: const TextStyle(color: AppColors.muted, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: request.progress,
              minHeight: 7,
              backgroundColor: const Color(0xFF2A4B3F),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.green),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _CharityStatusPill(request: request),
              const Spacer(),
              _ActionButton(
                label: 'Approve',
                compact: true,
                background: AppColors.green,
                foreground: const Color(0xFF032519),
                onPressed: () => context.read<DashboardCubit>().approveCharityRequest(request.id),
              ),
              const SizedBox(width: 6),
              _ActionButton(
                label: 'Reject',
                compact: true,
                outlined: true,
                foreground: Color(0xFFFF7373),
                onPressed: () => context.read<DashboardCubit>().rejectCharityRequest(request.id),
              ),
            ],
          ),
          ],
        ),
      ),
    );
  }
}

class _CharityStatusPill extends StatelessWidget {
  const _CharityStatusPill({required this.request});

  final CharityRequest request;

  @override
  Widget build(BuildContext context) {
    final color = switch (request.statusTone) {
      CharityStatusTone.warning => const Color(0xFFE2C64A),
      CharityStatusTone.info => const Color(0xFF6EC4FF),
      CharityStatusTone.neutral => const Color(0xFFAFC1B9),
      CharityStatusTone.success => AppColors.green,
      CharityStatusTone.danger => const Color(0xFFFF7373),
    };
    final bg = switch (request.statusTone) {
      CharityStatusTone.warning => const Color(0xFF4A431D),
      CharityStatusTone.info => const Color(0xFF153F58),
      CharityStatusTone.neutral => const Color(0xFF24453B),
      CharityStatusTone.success => const Color(0xFF0F4A35),
      CharityStatusTone.danger => const Color(0xFF4A2020),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Text(
        request.status,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _CharityBottomCards extends StatelessWidget {
  const _CharityBottomCards({this.compact = false, this.mobile = false});

  final bool compact;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    if (compact || mobile) {
      return const Column(
        children: [
          _InfoCard(
            title: 'Verification Guidelines',
            description:
                'Run identity checks, funding audit, and compliance review before campaign approval.',
          ),
          SizedBox(height: 12),
          _InfoCard(
            title: 'Verification Performance',
            description:
                'Median review time: 7h 20m. 91% requests are completed in under 24 hours.',
          ),
        ],
      );
    }
    return const Row(
      children: [
        Expanded(
          child: _InfoCard(
            title: 'Verification Guidelines',
            description:
                'Run identity checks, funding audit, and compliance review before campaign approval.',
          ),
        ),
        SizedBox(width: 14),
        Expanded(
          child: _InfoCard(
            title: 'Verification Performance',
            description:
                'Median review time: 7h 20m. 91% requests are completed in under 24 hours.',
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF12392A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(color: AppColors.muted, fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.foreground,
    required this.onPressed,
    this.background,
    this.outlined = false,
    this.compact = false,
  });

  final String label;
  final Color foreground;
  final VoidCallback onPressed;
  final Color? background;
  final bool outlined;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: compact ? 30 : 34,
      child: outlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: foreground),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: compact ? 10 : 14),
                textStyle: TextStyle(
                  fontSize: compact ? 12 : 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: Text(label, style: TextStyle(color: foreground)),
            )
          : FilledButton(
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: background ?? AppColors.green,
                foregroundColor: foreground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: compact ? 10 : 14),
                textStyle: TextStyle(
                  fontSize: compact ? 12 : 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: Text(label),
            ),
    );
  }
}

class _SubtleOutlineButton extends StatelessWidget {
  const _SubtleOutlineButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.white,
        side: const BorderSide(color: AppColors.stroke),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      child: Text(label),
    );
  }
}

class _PaginationArrow extends StatelessWidget {
  const _PaginationArrow({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Icon(icon, size: 18, color: AppColors.item),
    );
  }
}

enum _CharityMetricTone { success, warning, info }

class _SystemSettingsBody extends StatefulWidget {
  const _SystemSettingsBody({this.compact = false, this.mobile = false});

  final bool compact;
  final bool mobile;

  @override
  State<_SystemSettingsBody> createState() => _SystemSettingsBodyState();
}

class _SystemSettingsBodyState extends State<_SystemSettingsBody> {
  String selectedSection = 'General';
  String selectedSourceCategory = 'All Sources';
  int contentSourcesPage = 1;
  bool lightMode = AppThemeController.isLightMode;
  bool maintenanceMode = false;
  bool locationServicesEnabled = true;
  String defaultCity = 'Makkah, Saudi Arabia (Masjid al-Haram)';
  String defaultCalendar = 'Hijri (Islamic)';
  String searchSensitivity = 'Balanced (Standard)';
  String calculationMethod = 'MWL - Muslim World League';
  String asrMethod = 'Standard';
  String highLatitudeRule = 'Angle Based (Recommended)';
  bool broadcastsEnabled = true;
  String firebaseServerKey = '*****************************';
  String fcmProjectId = 'ask-islam-prod-772';
  String sendgridApiKey = '***********************';
  String verifiedSenderEmail = 'no-reply@askislam.org';
  String twilioAccountSid = 'AC77e5c92849405d...';
  String twilioAuthToken = '****************';
  Map<String, int> prayerOffsets = const {
    'Fajr': 0,
    'Dhuhr': 2,
    'Asr': 0,
    'Maghrib': -3,
    'Isha': 1,
  };
  List<_SourceRecord> contentSources = const [
    _SourceRecord(
      id: 'src-alquran-cloud',
      name: 'Al Quran Cloud',
      host: 'api.alquran.cloud',
      category: 'Quran',
      status: 'Online',
      syncFrequency: 'Every 24h',
      lastSync: 'Oct 24, 08:00 AM',
    ),
    _SourceRecord(
      id: 'src-sunnah-api',
      name: 'Sunnah.com API',
      host: 'sunnah.com/api',
      category: 'Hadith',
      status: 'Online',
      syncFrequency: 'Every 12h',
      lastSync: 'Oct 24, 12:30 PM',
    ),
    _SourceRecord(
      id: 'src-tafsir',
      name: 'Tafsir.com',
      host: 'tafsir.com/internal',
      category: 'Tafseer',
      status: 'Offline',
      syncFrequency: 'Weekly',
      lastSync: 'Oct 18, 03:00 PM',
    ),
    _SourceRecord(
      id: 'src-global-quran',
      name: 'Global Quran API',
      host: 'globalquran.com',
      category: 'Quran',
      status: 'Online',
      syncFrequency: 'Monthly',
      lastSync: 'Oct 01, 10:00 AM',
    ),
  ];

  late _SettingsSnapshot _saved;

  @override
  void initState() {
    super.initState();
    _saved = _snapshot;
  }

  _SettingsSnapshot get _snapshot => _SettingsSnapshot(
        lightMode: lightMode,
        maintenanceMode: maintenanceMode,
        locationServicesEnabled: locationServicesEnabled,
        defaultCity: defaultCity,
        defaultCalendar: defaultCalendar,
        searchSensitivity: searchSensitivity,
        calculationMethod: calculationMethod,
        asrMethod: asrMethod,
        highLatitudeRule: highLatitudeRule,
        broadcastsEnabled: broadcastsEnabled,
        firebaseServerKey: firebaseServerKey,
        fcmProjectId: fcmProjectId,
        sendgridApiKey: sendgridApiKey,
        verifiedSenderEmail: verifiedSenderEmail,
        twilioAccountSid: twilioAccountSid,
        twilioAuthToken: twilioAuthToken,
        prayerOffsets: prayerOffsets,
      );

  bool get _hasChanges => _snapshot != _saved;

  void _saveChanges() {
    setState(() {
      _saved = _snapshot;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('System settings saved successfully.')),
    );
  }

  void _discardChanges() {
    setState(() {
      lightMode = _saved.lightMode;
      maintenanceMode = _saved.maintenanceMode;
      locationServicesEnabled = _saved.locationServicesEnabled;
      defaultCity = _saved.defaultCity;
      defaultCalendar = _saved.defaultCalendar;
      searchSensitivity = _saved.searchSensitivity;
      calculationMethod = _saved.calculationMethod;
      asrMethod = _saved.asrMethod;
      highLatitudeRule = _saved.highLatitudeRule;
      broadcastsEnabled = _saved.broadcastsEnabled;
      firebaseServerKey = _saved.firebaseServerKey;
      fcmProjectId = _saved.fcmProjectId;
      sendgridApiKey = _saved.sendgridApiKey;
      verifiedSenderEmail = _saved.verifiedSenderEmail;
      twilioAccountSid = _saved.twilioAccountSid;
      twilioAuthToken = _saved.twilioAuthToken;
      prayerOffsets = Map<String, int>.from(_saved.prayerOffsets);
    });
    AppThemeController.setLightMode(lightMode);
  }

  @override
  Widget build(BuildContext context) {
    final compact = widget.compact || widget.mobile;
    final titleSize = widget.mobile ? 22.0 : (widget.compact ? 28.0 : 40.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'System Global Settings',
              style: TextStyle(color: AppColors.white, fontSize: titleSize, fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            const Icon(Icons.help_outline, color: AppColors.muted, size: 20),
            const SizedBox(width: 14),
            const Text(
              'System Status: Operational',
              style: TextStyle(color: AppColors.item, fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: compact
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      _SettingsSectionsRail(
                        selectedSection: selectedSection,
                        onSelect: (section) => setState(() => selectedSection = section),
                        compact: true,
                      ),
                      const SizedBox(height: 12),
                      _SettingsFormPanel(
                        selectedSection: selectedSection,
                        selectedSourceCategory: selectedSourceCategory,
                        lightMode: lightMode,
                        maintenanceMode: maintenanceMode,
                        locationServicesEnabled: locationServicesEnabled,
                        defaultCity: defaultCity,
                        defaultCalendar: defaultCalendar,
                        searchSensitivity: searchSensitivity,
                        calculationMethod: calculationMethod,
                        asrMethod: asrMethod,
                        highLatitudeRule: highLatitudeRule,
                        broadcastsEnabled: broadcastsEnabled,
                        firebaseServerKey: firebaseServerKey,
                        fcmProjectId: fcmProjectId,
                        sendgridApiKey: sendgridApiKey,
                        verifiedSenderEmail: verifiedSenderEmail,
                        twilioAccountSid: twilioAccountSid,
                        twilioAuthToken: twilioAuthToken,
                        prayerOffsets: prayerOffsets,
                        onMaintenanceChanged: (value) => setState(() => maintenanceMode = value),
                        onLocationServicesChanged: (value) => setState(() => locationServicesEnabled = value),
                        onDefaultCityChanged: (value) => setState(() => defaultCity = value),
                        onCalendarChanged: (value) => setState(() => defaultCalendar = value),
                        onSearchChanged: (value) => setState(() => searchSensitivity = value),
                        onCalculationChanged: (value) => setState(() => calculationMethod = value),
                        onAsrChanged: (value) => setState(() => asrMethod = value),
                        onHighLatitudeChanged: (value) => setState(() => highLatitudeRule = value),
                        onBroadcastsChanged: (value) => setState(() => broadcastsEnabled = value),
                        onFirebaseServerKeyChanged: (value) => setState(() => firebaseServerKey = value),
                        onFcmProjectIdChanged: (value) => setState(() => fcmProjectId = value),
                        onSendgridApiKeyChanged: (value) => setState(() => sendgridApiKey = value),
                        onVerifiedSenderEmailChanged: (value) => setState(() => verifiedSenderEmail = value),
                        onTwilioAccountSidChanged: (value) => setState(() => twilioAccountSid = value),
                        onTwilioAuthTokenChanged: (value) => setState(() => twilioAuthToken = value),
                        onPrayerOffsetChanged: (name, value) => setState(() {
                          prayerOffsets = Map<String, int>.from(prayerOffsets)..[name] = value;
                        }),
                        onSourceCategoryChanged: (value) => setState(() {
                          selectedSourceCategory = value;
                          contentSourcesPage = 1;
                        }),
                        contentSources: contentSources,
                        contentSourcesPage: contentSourcesPage,
                        onContentSourcesPageChanged: (value) => setState(() => contentSourcesPage = value),
                        onAddContentSource: () => setState(() {
                          final next = contentSources.length + 1;
                          contentSources = [
                            _SourceRecord(
                              id: 'src-new-$next',
                              name: 'New Source $next',
                              host: 'newsource$next.api',
                              category: 'Translation',
                              status: 'Online',
                              syncFrequency: 'Every 24h',
                              lastSync: 'Just now',
                            ),
                            ...contentSources,
                          ];
                          contentSourcesPage = 1;
                        }),
                        onEditContentSource: (sourceId) => setState(() {
                          contentSources = contentSources
                              .map((source) => source.id == sourceId
                                  ? source.copyWith(
                                      status: source.status == 'Online' ? 'Offline' : 'Online',
                                      lastSync: 'Just now',
                                    )
                                  : source)
                              .toList(growable: false);
                        }),
                        onDeleteContentSource: (sourceId) => setState(() {
                          contentSources = contentSources.where((source) => source.id != sourceId).toList(growable: false);
                          final maxPage = ((contentSources.length - 1) ~/ 4) + 1;
                          if (contentSourcesPage > maxPage) {
                            contentSourcesPage = maxPage < 1 ? 1 : maxPage;
                          }
                        }),
                        onLightModeChanged: (value) {
                          setState(() => lightMode = value);
                          AppThemeController.setLightMode(value);
                        },
                        compact: true,
                      ),
                    ],
                  ),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 330,
                      child: _SettingsSectionsRail(
                        selectedSection: selectedSection,
                        onSelect: (section) => setState(() => selectedSection = section),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _SettingsFormPanel(
                        selectedSection: selectedSection,
                        selectedSourceCategory: selectedSourceCategory,
                        lightMode: lightMode,
                        maintenanceMode: maintenanceMode,
                        locationServicesEnabled: locationServicesEnabled,
                        defaultCity: defaultCity,
                        defaultCalendar: defaultCalendar,
                        searchSensitivity: searchSensitivity,
                        calculationMethod: calculationMethod,
                        asrMethod: asrMethod,
                        highLatitudeRule: highLatitudeRule,
                        broadcastsEnabled: broadcastsEnabled,
                        firebaseServerKey: firebaseServerKey,
                        fcmProjectId: fcmProjectId,
                        sendgridApiKey: sendgridApiKey,
                        verifiedSenderEmail: verifiedSenderEmail,
                        twilioAccountSid: twilioAccountSid,
                        twilioAuthToken: twilioAuthToken,
                        prayerOffsets: prayerOffsets,
                        onMaintenanceChanged: (value) => setState(() => maintenanceMode = value),
                        onLocationServicesChanged: (value) => setState(() => locationServicesEnabled = value),
                        onDefaultCityChanged: (value) => setState(() => defaultCity = value),
                        onCalendarChanged: (value) => setState(() => defaultCalendar = value),
                        onSearchChanged: (value) => setState(() => searchSensitivity = value),
                        onCalculationChanged: (value) => setState(() => calculationMethod = value),
                        onAsrChanged: (value) => setState(() => asrMethod = value),
                        onHighLatitudeChanged: (value) => setState(() => highLatitudeRule = value),
                        onBroadcastsChanged: (value) => setState(() => broadcastsEnabled = value),
                        onFirebaseServerKeyChanged: (value) => setState(() => firebaseServerKey = value),
                        onFcmProjectIdChanged: (value) => setState(() => fcmProjectId = value),
                        onSendgridApiKeyChanged: (value) => setState(() => sendgridApiKey = value),
                        onVerifiedSenderEmailChanged: (value) => setState(() => verifiedSenderEmail = value),
                        onTwilioAccountSidChanged: (value) => setState(() => twilioAccountSid = value),
                        onTwilioAuthTokenChanged: (value) => setState(() => twilioAuthToken = value),
                        onPrayerOffsetChanged: (name, value) => setState(() {
                          prayerOffsets = Map<String, int>.from(prayerOffsets)..[name] = value;
                        }),
                        onSourceCategoryChanged: (value) => setState(() {
                          selectedSourceCategory = value;
                          contentSourcesPage = 1;
                        }),
                        contentSources: contentSources,
                        contentSourcesPage: contentSourcesPage,
                        onContentSourcesPageChanged: (value) => setState(() => contentSourcesPage = value),
                        onAddContentSource: () => setState(() {
                          final next = contentSources.length + 1;
                          contentSources = [
                            _SourceRecord(
                              id: 'src-new-$next',
                              name: 'New Source $next',
                              host: 'newsource$next.api',
                              category: 'Translation',
                              status: 'Online',
                              syncFrequency: 'Every 24h',
                              lastSync: 'Just now',
                            ),
                            ...contentSources,
                          ];
                          contentSourcesPage = 1;
                        }),
                        onEditContentSource: (sourceId) => setState(() {
                          contentSources = contentSources
                              .map((source) => source.id == sourceId
                                  ? source.copyWith(
                                      status: source.status == 'Online' ? 'Offline' : 'Online',
                                      lastSync: 'Just now',
                                    )
                                  : source)
                              .toList(growable: false);
                        }),
                        onDeleteContentSource: (sourceId) => setState(() {
                          contentSources = contentSources.where((source) => source.id != sourceId).toList(growable: false);
                          final maxPage = ((contentSources.length - 1) ~/ 4) + 1;
                          if (contentSourcesPage > maxPage) {
                            contentSourcesPage = maxPage < 1 ? 1 : maxPage;
                          }
                        }),
                        onLightModeChanged: (value) {
                          setState(() => lightMode = value);
                          AppThemeController.setLightMode(value);
                        },
                      ),
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          decoration: BoxDecoration(
            color: const Color(0xFF12392A),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.stroke),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selectedSection == 'Prayer Times Calculation'
                      ? 'Last updated by Admin Zahid on Oct 12, 2023 at 14:30 GMT+3'
                      : 'Changes affect all active user sessions instantly.',
                  style: const TextStyle(color: AppColors.muted, fontSize: 13, fontStyle: FontStyle.italic),
                ),
              ),
              TextButton(
                onPressed: _hasChanges ? _discardChanges : null,
                child: Text(
                  selectedSection == 'Prayer Times Calculation'
                      ? 'Discard Changes'
                      : 'Discard Changes',
                ),
              ),
              const SizedBox(width: 10),
              FilledButton.icon(
                onPressed: _hasChanges ? _saveChanges : null,
                icon: const Icon(Icons.save),
                label: Text(
                  selectedSection == 'Prayer Times Calculation'
                      ? 'Save Calculation Rules'
                      : selectedSection == 'Notification API'
                      ? 'Save Configuration'
                      : selectedSection == 'Content Sources'
                      ? 'Save Source Config'
                      : 'Save Changes',
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: const Color(0xFF032519),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsSectionsRail extends StatelessWidget {
  const _SettingsSectionsRail({
    required this.selectedSection,
    required this.onSelect,
    this.compact = false,
  });

  final String selectedSection;
  final ValueChanged<String> onSelect;
  final bool compact;

  static const List<(IconData, String)> _items = [
    (Icons.tune, 'General'),
    (Icons.schedule, 'Prayer Times Calculation'),
    (Icons.folder_open, 'Content Sources'),
    (Icons.notifications_active, 'Notification API'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF12392A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        children: [
          for (final item in _items)
            _SettingsNavItem(
              icon: item.$1,
              title: item.$2,
              active: selectedSection == item.$2,
              onTap: () => onSelect(item.$2),
              compact: compact,
            ),
        ],
      ),
    );
  }
}

class _SettingsNavItem extends StatelessWidget {
  const _SettingsNavItem({
    required this.icon,
    required this.title,
    required this.active,
    required this.onTap,
    this.compact = false,
  });

  final IconData icon;
  final String title;
  final bool active;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: compact ? 12 : 14),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF0F4A35).withValues(alpha: 0.5) : Colors.transparent,
          border: Border(
            left: BorderSide(color: active ? AppColors.green : Colors.transparent, width: 3),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: active ? AppColors.green : AppColors.muted, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: active ? AppColors.green : AppColors.item,
                  fontSize: 15,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsFormPanel extends StatelessWidget {
  const _SettingsFormPanel({
    required this.selectedSection,
    required this.selectedSourceCategory,
    required this.lightMode,
    required this.maintenanceMode,
    required this.locationServicesEnabled,
    required this.defaultCity,
    required this.defaultCalendar,
    required this.searchSensitivity,
    required this.calculationMethod,
    required this.asrMethod,
    required this.highLatitudeRule,
    required this.broadcastsEnabled,
    required this.firebaseServerKey,
    required this.fcmProjectId,
    required this.sendgridApiKey,
    required this.verifiedSenderEmail,
    required this.twilioAccountSid,
    required this.twilioAuthToken,
    required this.prayerOffsets,
    required this.onMaintenanceChanged,
    required this.onLocationServicesChanged,
    required this.onDefaultCityChanged,
    required this.onCalendarChanged,
    required this.onSearchChanged,
    required this.onCalculationChanged,
    required this.onAsrChanged,
    required this.onHighLatitudeChanged,
    required this.onBroadcastsChanged,
    required this.onFirebaseServerKeyChanged,
    required this.onFcmProjectIdChanged,
    required this.onSendgridApiKeyChanged,
    required this.onVerifiedSenderEmailChanged,
    required this.onTwilioAccountSidChanged,
    required this.onTwilioAuthTokenChanged,
    required this.onPrayerOffsetChanged,
    required this.onSourceCategoryChanged,
    required this.contentSources,
    required this.contentSourcesPage,
    required this.onContentSourcesPageChanged,
    required this.onAddContentSource,
    required this.onEditContentSource,
    required this.onDeleteContentSource,
    required this.onLightModeChanged,
    this.compact = false,
  });

  final String selectedSection;
  final String selectedSourceCategory;
  final bool lightMode;
  final bool maintenanceMode;
  final bool locationServicesEnabled;
  final String defaultCity;
  final String defaultCalendar;
  final String searchSensitivity;
  final String calculationMethod;
  final String asrMethod;
  final String highLatitudeRule;
  final bool broadcastsEnabled;
  final String firebaseServerKey;
  final String fcmProjectId;
  final String sendgridApiKey;
  final String verifiedSenderEmail;
  final String twilioAccountSid;
  final String twilioAuthToken;
  final Map<String, int> prayerOffsets;
  final ValueChanged<bool> onMaintenanceChanged;
  final ValueChanged<bool> onLocationServicesChanged;
  final ValueChanged<String> onDefaultCityChanged;
  final ValueChanged<String> onCalendarChanged;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onCalculationChanged;
  final ValueChanged<String> onAsrChanged;
  final ValueChanged<String> onHighLatitudeChanged;
  final ValueChanged<bool> onBroadcastsChanged;
  final ValueChanged<String> onFirebaseServerKeyChanged;
  final ValueChanged<String> onFcmProjectIdChanged;
  final ValueChanged<String> onSendgridApiKeyChanged;
  final ValueChanged<String> onVerifiedSenderEmailChanged;
  final ValueChanged<String> onTwilioAccountSidChanged;
  final ValueChanged<String> onTwilioAuthTokenChanged;
  final void Function(String prayerName, int value) onPrayerOffsetChanged;
  final ValueChanged<String> onSourceCategoryChanged;
  final List<_SourceRecord> contentSources;
  final int contentSourcesPage;
  final ValueChanged<int> onContentSourcesPageChanged;
  final VoidCallback onAddContentSource;
  final ValueChanged<String> onEditContentSource;
  final ValueChanged<String> onDeleteContentSource;
  final ValueChanged<bool> onLightModeChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (selectedSection == 'Prayer Times Calculation') {
      return _PrayerTimesSettingsPanel(
        compact: compact,
        locationServicesEnabled: locationServicesEnabled,
        defaultCity: defaultCity,
        calculationMethod: calculationMethod,
        asrMethod: asrMethod,
        highLatitudeRule: highLatitudeRule,
        prayerOffsets: prayerOffsets,
        onLocationServicesChanged: onLocationServicesChanged,
        onDefaultCityChanged: onDefaultCityChanged,
        onCalculationChanged: onCalculationChanged,
        onAsrChanged: onAsrChanged,
        onHighLatitudeChanged: onHighLatitudeChanged,
        onPrayerOffsetChanged: onPrayerOffsetChanged,
      );
    }
    if (selectedSection == 'Notification API') {
      return _NotificationApiSettingsPanel(
        compact: compact,
        broadcastsEnabled: broadcastsEnabled,
        firebaseServerKey: firebaseServerKey,
        fcmProjectId: fcmProjectId,
        sendgridApiKey: sendgridApiKey,
        verifiedSenderEmail: verifiedSenderEmail,
        twilioAccountSid: twilioAccountSid,
        twilioAuthToken: twilioAuthToken,
        onBroadcastsChanged: onBroadcastsChanged,
        onFirebaseServerKeyChanged: onFirebaseServerKeyChanged,
        onFcmProjectIdChanged: onFcmProjectIdChanged,
        onSendgridApiKeyChanged: onSendgridApiKeyChanged,
        onVerifiedSenderEmailChanged: onVerifiedSenderEmailChanged,
        onTwilioAccountSidChanged: onTwilioAccountSidChanged,
        onTwilioAuthTokenChanged: onTwilioAuthTokenChanged,
      );
    }
    if (selectedSection == 'Content Sources') {
      return _ContentSourcesSettingsPanel(
        compact: compact,
        selectedCategory: selectedSourceCategory,
        onCategoryChanged: onSourceCategoryChanged,
        sources: contentSources,
        page: contentSourcesPage,
        onPageChanged: onContentSourcesPageChanged,
        onAddSource: onAddContentSource,
        onEditSource: onEditContentSource,
        onDeleteSource: onDeleteContentSource,
      );
    }
    return Container(
      padding: EdgeInsets.all(compact ? 14 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFF12392A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('General Settings', style: TextStyle(color: AppColors.white, fontSize: compact ? 26 : 40, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const Text(
            'Configure core system behaviors and default displays.',
            style: TextStyle(color: AppColors.muted, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F3427),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.stroke),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Light Mode', style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                      SizedBox(height: 2),
                      Text('Enable a light visual mode for the full admin interface.', style: TextStyle(color: AppColors.muted, fontSize: 14)),
                    ],
                  ),
                ),
                Switch(
                  value: lightMode,
                  onChanged: onLightModeChanged,
                  activeThumbColor: AppColors.green,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F3427),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.stroke),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Maintenance Mode', style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                      SizedBox(height: 2),
                      Text('Temporarily disable public access to the platform.', style: TextStyle(color: AppColors.muted, fontSize: 14)),
                    ],
                  ),
                ),
                Switch(
                  value: maintenanceMode,
                  onChanged: onMaintenanceChanged,
                  activeThumbColor: AppColors.green,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _SettingsDropdown(
                label: 'DEFAULT CALENDAR',
                value: defaultCalendar,
                options: const ['Hijri (Islamic)', 'Gregorian'],
                onChanged: onCalendarChanged,
              ),
              _SettingsDropdown(
                label: 'GLOBAL SEARCH SENSITIVITY',
                value: searchSensitivity,
                options: const ['Balanced (Standard)', 'Strict', 'Relaxed'],
                onChanged: onSearchChanged,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Choose "Prayer Times Calculation" from the left menu to configure geo-based calculation rules and advanced offsets.',
            style: TextStyle(color: AppColors.muted, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _PrayerTimesSettingsPanel extends StatelessWidget {
  const _PrayerTimesSettingsPanel({
    required this.locationServicesEnabled,
    required this.defaultCity,
    required this.calculationMethod,
    required this.asrMethod,
    required this.highLatitudeRule,
    required this.prayerOffsets,
    required this.onLocationServicesChanged,
    required this.onDefaultCityChanged,
    required this.onCalculationChanged,
    required this.onAsrChanged,
    required this.onHighLatitudeChanged,
    required this.onPrayerOffsetChanged,
    this.compact = false,
  });

  final bool compact;
  final bool locationServicesEnabled;
  final String defaultCity;
  final String calculationMethod;
  final String asrMethod;
  final String highLatitudeRule;
  final Map<String, int> prayerOffsets;
  final ValueChanged<bool> onLocationServicesChanged;
  final ValueChanged<String> onDefaultCityChanged;
  final ValueChanged<String> onCalculationChanged;
  final ValueChanged<String> onAsrChanged;
  final ValueChanged<String> onHighLatitudeChanged;
  final void Function(String prayerName, int value) onPrayerOffsetChanged;

  static const List<(String, String, IconData, Color)> _offsetMeta = [
    ('Fajr', 'Astronomical dawn', Icons.wb_twilight, Color(0xFF1FF08D)),
    ('Dhuhr', 'Zenith', Icons.wb_sunny_outlined, Color(0xFFE2C64A)),
    ('Asr', 'Shadow length', Icons.cloud_outlined, Color(0xFF9EB2BD)),
    ('Maghrib', 'Sunset', Icons.nights_stay_outlined, Color(0xFFFFA14A)),
    ('Isha', 'Nightfall', Icons.dark_mode_outlined, Color(0xFF8FA0FF)),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? 14 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFF12392A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Geographic & Calculation Settings',
            style: TextStyle(color: AppColors.white, fontSize: compact ? 28 : 40, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          const Text(
            'Define location parameters and prayer calculation logic.',
            style: TextStyle(color: AppColors.muted, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F3427),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.stroke),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(color: const Color(0xFF0F4A35), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.location_on, color: AppColors.green),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Location Services', style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                      SizedBox(height: 2),
                      Text(
                        'Auto-detect prayer times based on user\'s current GPS coordinates.',
                        style: TextStyle(color: AppColors.muted, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: locationServicesEnabled,
                  onChanged: onLocationServicesChanged,
                  activeThumbColor: AppColors.green,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F3427),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.stroke),
            ),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _SettingsDropdown(
                  label: 'DEFAULT CITY / MOSQUE',
                  value: defaultCity,
                  options: const [
                    'Makkah, Saudi Arabia (Masjid al-Haram)',
                    'Madinah, Saudi Arabia (Masjid an-Nabawi)',
                    'Karachi, Pakistan (Masjid e Tooba)',
                    'Istanbul, Turkey (Blue Mosque)',
                  ],
                  onChanged: onDefaultCityChanged,
                  prefixIcon: Icons.search,
                ),
                _AsrSelector(value: asrMethod, onChanged: onAsrChanged, label: 'ASR CALCULATION METHOD'),
                _SettingsDropdown(
                  label: 'CALCULATION METHOD',
                  value: calculationMethod,
                  options: const ['MWL - Muslim World League', 'Umm al-Qura', 'ISNA', 'Egyptian General Authority'],
                  onChanged: onCalculationChanged,
                ),
                _SettingsDropdown(
                  label: 'HIGH LATITUDE RULE',
                  value: highLatitudeRule,
                  options: const ['Angle Based (Recommended)', 'Middle of the Night', 'Seventh of Night'],
                  onChanged: onHighLatitudeChanged,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Advanced Time Offsets',
            style: TextStyle(color: AppColors.white, fontSize: compact ? 26 : 38, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          const Text(
            'Fine-tune individual prayer times by adding or subtracting minutes.',
            style: TextStyle(color: AppColors.muted, fontSize: 14),
          ),
          const SizedBox(height: 10),
          if (compact)
            SizedBox(height: 420, child: _offsetTable())
          else
            Expanded(child: _offsetTable()),
        ],
      ),
    );
  }

  Widget _offsetTable() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F3427),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Row(
              children: [
                Expanded(flex: 3, child: Text('PRAYER NAME', style: tableHeadStyle)),
                Expanded(flex: 3, child: Text('DEFAULT TIMING', style: tableHeadStyle)),
                Expanded(flex: 3, child: Text('OFFSET ADJUSTMENT (MIN)', style: tableHeadStyle)),
                Expanded(flex: 2, child: Align(alignment: Alignment.centerRight, child: Text('STATUS', style: tableHeadStyle))),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.stroke),
          Expanded(
            child: ListView.separated(
              itemCount: _offsetMeta.length,
              separatorBuilder: (_, _) => const Divider(height: 1, color: AppColors.stroke),
              itemBuilder: (context, index) {
                final item = _offsetMeta[index];
                final offset = prayerOffsets[item.$1] ?? 0;
                return _PrayerOffsetRow(
                  prayerName: item.$1,
                  defaultTiming: item.$2,
                  icon: item.$3,
                  iconColor: item.$4,
                  offset: offset,
                  onChanged: (value) => onPrayerOffsetChanged(item.$1, value),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentSourcesSettingsPanel extends StatelessWidget {
  const _ContentSourcesSettingsPanel({
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.sources,
    required this.page,
    required this.onPageChanged,
    required this.onAddSource,
    required this.onEditSource,
    required this.onDeleteSource,
    this.compact = false,
  });

  final bool compact;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;
  final List<_SourceRecord> sources;
  final int page;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onAddSource;
  final ValueChanged<String> onEditSource;
  final ValueChanged<String> onDeleteSource;

  static const List<String> _categories = [
    'All Sources',
    'Quran',
    'Hadith',
    'Tafseer',
    'Translation',
  ];

  @override
  Widget build(BuildContext context) {
    const pageSize = 4;
    final filtered = selectedCategory == 'All Sources'
        ? sources
        : sources
            .where((source) => source.category.toLowerCase() == selectedCategory.toLowerCase())
            .toList(growable: false);
    final onlineCount = sources.where((source) => source.status == 'Online').length;
    final errorsCount = sources.where((source) => source.status != 'Online').length;
    final totalPages = filtered.isEmpty ? 1 : ((filtered.length - 1) ~/ pageSize) + 1;
    final safePage = page > totalPages ? totalPages : (page < 1 ? 1 : page);
    final start = (safePage - 1) * pageSize;
    final end = (start + pageSize) > filtered.length ? filtered.length : (start + pageSize);
    final visible = filtered.sublist(start, end);

    return Container(
      padding: EdgeInsets.all(compact ? 14 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFF12392A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Content Sources',
                      style: TextStyle(color: AppColors.white, fontSize: compact ? 28 : 40, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Integrate and manage external data providers for sacred texts. Configure sync intervals and monitor API health status.',
                      style: TextStyle(color: AppColors.green, fontSize: 14),
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: onAddSource,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: const Color(0xFF032519),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Add New Source', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _MetricChip(title: 'Total Sources', value: '${sources.length}', tone: AppColors.green),
              _MetricChip(title: 'Online Status', value: '$onlineCount', tone: AppColors.green),
              _MetricChip(title: 'Sync Errors (24h)', value: '$errorsCount', tone: const Color(0xFFFF7373)),
              const _MetricChip(title: 'Next Global Sync', value: '42m 10s', tone: Color(0xFFE2C64A)),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final category in _categories)
                _CategoryTab(
                  label: category,
                  active: selectedCategory == category,
                  onTap: () => onCategoryChanged(category),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0F3427),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.stroke),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(14, 12, 14, 10),
                    child: Row(
                      children: [
                        Expanded(flex: 4, child: Text('SOURCE NAME', style: tableHeadStyle)),
                        Expanded(flex: 2, child: Text('CATEGORY', style: tableHeadStyle)),
                        Expanded(flex: 2, child: Text('STATUS', style: tableHeadStyle)),
                        Expanded(flex: 3, child: Text('SYNC FREQUENCY', style: tableHeadStyle)),
                        Expanded(flex: 3, child: Text('LAST SYNC', style: tableHeadStyle)),
                        Expanded(flex: 2, child: Align(alignment: Alignment.centerRight, child: Text('ACTIONS', style: tableHeadStyle))),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.stroke),
                  Expanded(
                    child: ListView.separated(
                      itemCount: visible.length,
                      separatorBuilder: (_, _) => const Divider(height: 1, color: AppColors.stroke),
                      itemBuilder: (context, index) => _SourceRow(
                        source: visible[index],
                        onEdit: () => onEditSource(visible[index].id),
                        onDelete: () => onDeleteSource(visible[index].id),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
                    child: Row(
                      children: [
                        Text(
                          'Showing ${filtered.isEmpty ? 0 : (start + 1)} to $end of ${filtered.length} results',
                          style: const TextStyle(color: AppColors.muted, fontSize: 13),
                        ),
                        const Spacer(),
                        for (int i = 1; i <= totalPages; i++) ...[
                          InkWell(
                            onTap: () => onPageChanged(i),
                            child: _PaginationChip(text: '$i', active: i == safePage),
                          ),
                          if (i != totalPages) const SizedBox(width: 6),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F4A35).withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.stroke),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: const Color(0xFF0F5A41), borderRadius: BorderRadius.circular(999)),
                  child: const Icon(Icons.info, color: AppColors.green),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Source Integration Guide', style: TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                      SizedBox(height: 3),
                      Text(
                        'Need help adding a new data provider? Review our API integration standards to ensure compatibility with the system\'s indexing engine.',
                        style: TextStyle(color: AppColors.muted, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.green,
                    side: const BorderSide(color: AppColors.green),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Documentation'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.title,
    required this.value,
    required this.tone,
  });

  final String title;
  final String value;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F3427),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: tone, fontSize: 38, fontWeight: FontWeight.w700, height: .95)),
        ],
      ),
    );
  }
}

class _CategoryTab extends StatelessWidget {
  const _CategoryTab({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(2, 0, 2, 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: active ? AppColors.green : Colors.transparent, width: 2),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? AppColors.green : AppColors.item,
            fontSize: 16,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _SourceRow extends StatelessWidget {
  const _SourceRow({
    required this.source,
    required this.onEdit,
    required this.onDelete,
  });

  final _SourceRecord source;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final online = source.status == 'Online';
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F4A35),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.cloud, color: AppColors.green, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(source.name, style: const TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                      Text(source.host, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(flex: 2, child: _CategoryPill(text: source.category)),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Icon(
                  online ? Icons.check_circle : Icons.error,
                  color: online ? AppColors.green : const Color(0xFFFF7373),
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  source.status,
                  style: TextStyle(
                    color: online ? AppColors.green : const Color(0xFFFF7373),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(flex: 3, child: Text(source.syncFrequency, style: const TextStyle(color: AppColors.white, fontSize: 15))),
          Expanded(flex: 3, child: Text(source.lastSync, style: const TextStyle(color: AppColors.muted, fontSize: 15))),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(onPressed: onEdit, icon: const Icon(Icons.edit_outlined, color: AppColors.item, size: 20)),
                IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline, color: AppColors.item, size: 20)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final color = switch (text) {
      'Quran' => const Color(0xFF1FD58A),
      'Hadith' => const Color(0xFF7AB8FF),
      'Tafseer' => const Color(0xFFE2C64A),
      _ => AppColors.item,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _SourceRecord {
  const _SourceRecord({
    required this.id,
    required this.name,
    required this.host,
    required this.category,
    required this.status,
    required this.syncFrequency,
    required this.lastSync,
  });

  final String id;
  final String name;
  final String host;
  final String category;
  final String status;
  final String syncFrequency;
  final String lastSync;

  _SourceRecord copyWith({
    String? status,
    String? lastSync,
  }) {
    return _SourceRecord(
      id: id,
      name: name,
      host: host,
      category: category,
      status: status ?? this.status,
      syncFrequency: syncFrequency,
      lastSync: lastSync ?? this.lastSync,
    );
  }
}

class _NotificationApiSettingsPanel extends StatelessWidget {
  const _NotificationApiSettingsPanel({
    required this.broadcastsEnabled,
    required this.firebaseServerKey,
    required this.fcmProjectId,
    required this.sendgridApiKey,
    required this.verifiedSenderEmail,
    required this.twilioAccountSid,
    required this.twilioAuthToken,
    required this.onBroadcastsChanged,
    required this.onFirebaseServerKeyChanged,
    required this.onFcmProjectIdChanged,
    required this.onSendgridApiKeyChanged,
    required this.onVerifiedSenderEmailChanged,
    required this.onTwilioAccountSidChanged,
    required this.onTwilioAuthTokenChanged,
    this.compact = false,
  });

  final bool compact;
  final bool broadcastsEnabled;
  final String firebaseServerKey;
  final String fcmProjectId;
  final String sendgridApiKey;
  final String verifiedSenderEmail;
  final String twilioAccountSid;
  final String twilioAuthToken;
  final ValueChanged<bool> onBroadcastsChanged;
  final ValueChanged<String> onFirebaseServerKeyChanged;
  final ValueChanged<String> onFcmProjectIdChanged;
  final ValueChanged<String> onSendgridApiKeyChanged;
  final ValueChanged<String> onVerifiedSenderEmailChanged;
  final ValueChanged<String> onTwilioAccountSidChanged;
  final ValueChanged<String> onTwilioAuthTokenChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? 14 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFF12392A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notification API & Alert Settings',
            style: TextStyle(color: AppColors.white, fontSize: compact ? 28 : 40, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          const Text(
            'Manage external messaging gateways and global broadcast permissions.',
            style: TextStyle(color: AppColors.muted, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F3427),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.stroke),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(color: const Color(0xFF0F4A35), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.campaign, color: AppColors.green),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Enable System-wide Broadcasts', style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                      SizedBox(height: 2),
                      Text(
                        'Allow administrative emergency alerts to all active users.',
                        style: TextStyle(color: AppColors.muted, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: broadcastsEnabled,
                  onChanged: onBroadcastsChanged,
                  activeThumbColor: AppColors.green,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.count(
              crossAxisCount: compact ? 1 : 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: compact ? 2.2 : 1.5,
              children: [
                _ApiCard(
                  title: 'PUSH NOTIFICATIONS',
                  icon: Icons.notifications_active,
                  children: [
                    _ConfigField(
                      label: 'FIREBASE SERVER KEY',
                      value: firebaseServerKey,
                      onChanged: onFirebaseServerKeyChanged,
                    ),
                    _ConfigField(
                      label: 'FCM PROJECT ID',
                      value: fcmProjectId,
                      onChanged: onFcmProjectIdChanged,
                    ),
                  ],
                ),
                _ApiCard(
                  title: 'EMAIL GATEWAY',
                  icon: Icons.alternate_email,
                  children: [
                    _ConfigField(
                      label: 'SENDGRID API KEY',
                      value: sendgridApiKey,
                      onChanged: onSendgridApiKeyChanged,
                    ),
                    _ConfigField(
                      label: 'VERIFIED SENDER EMAIL',
                      value: verifiedSenderEmail,
                      onChanged: onVerifiedSenderEmailChanged,
                    ),
                  ],
                ),
                _ApiCard(
                  title: 'SMS GATEWAY',
                  icon: Icons.sms_outlined,
                  children: [
                    _ConfigField(
                      label: 'TWILIO ACCOUNT SID',
                      value: twilioAccountSid,
                      onChanged: onTwilioAccountSidChanged,
                    ),
                    _ConfigField(
                      label: 'TWILIO AUTH TOKEN',
                      value: twilioAuthToken,
                      onChanged: onTwilioAuthTokenChanged,
                    ),
                  ],
                ),
                _ApiCard(
                  title: 'CONNECTIVITY HEALTH',
                  icon: Icons.health_and_safety_outlined,
                  children: const [
                    _HealthLine(name: 'FCM Service', status: 'ONLINE', statusColor: AppColors.green),
                    _HealthLine(name: 'SendGrid Service', status: 'ONLINE', statusColor: AppColors.green),
                    _HealthLine(name: 'Twilio Service', status: 'LATENCY HIGH', statusColor: Color(0xFFE2C64A)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Notification Templates', style: TextStyle(color: AppColors.white, fontSize: 36, fontWeight: FontWeight.w700)),
                    SizedBox(height: 2),
                    Text('Customize the content of automatic system alerts.', style: TextStyle(color: AppColors.muted, fontSize: 14)),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.green,
                  side: const BorderSide(color: AppColors.green),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.add),
                label: const Text('New Template'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ApiCard extends StatelessWidget {
  const _ApiCard({required this.title, required this.icon, required this.children});

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F3427),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFE2C64A), size: 18),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: AppColors.item, fontSize: 18, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _ConfigField extends StatelessWidget {
  const _ConfigField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 11, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: value,
            style: const TextStyle(color: AppColors.white),
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF08281D),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.stroke),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.green),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HealthLine extends StatelessWidget {
  const _HealthLine({
    required this.name,
    required this.status,
    required this.statusColor,
  });

  final String name;
  final String status;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(name, style: const TextStyle(color: AppColors.white, fontSize: 16)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              status,
              style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerOffsetRow extends StatelessWidget {
  const _PrayerOffsetRow({
    required this.prayerName,
    required this.defaultTiming,
    required this.icon,
    required this.iconColor,
    required this.offset,
    required this.onChanged,
  });

  final String prayerName;
  final String defaultTiming;
  final IconData icon;
  final Color iconColor;
  final int offset;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final bool neutral = offset == 0;
    final bool positive = offset > 0;
    final statusText = neutral ? 'NEUTRAL' : (positive ? '+${offset} MIN' : '${offset} MIN');
    final statusColor = neutral
        ? const Color(0xFF8CA0AE)
        : positive
        ? AppColors.green
        : const Color(0xFFFF8E73);
    final statusBg = neutral
        ? const Color(0xFF273D46)
        : positive
        ? const Color(0xFF0F4A35)
        : const Color(0xFF4A2A23);

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 17),
                const SizedBox(width: 10),
                Text(prayerName, style: const TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(defaultTiming, style: const TextStyle(color: AppColors.muted, fontSize: 16)),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                _OffsetButton(icon: Icons.remove, onTap: () => onChanged(offset - 1)),
                const SizedBox(width: 6),
                Container(
                  width: 80,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A2B20),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.stroke),
                  ),
                  child: Text('$offset', style: const TextStyle(color: AppColors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 6),
                _OffsetButton(icon: Icons.add, onTap: () => onChanged(offset + 1)),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: statusBg.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OffsetButton extends StatelessWidget {
  const _OffsetButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          side: const BorderSide(color: AppColors.stroke),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Icon(icon, size: 16, color: AppColors.item),
      ),
    );
  }
}

class _SettingsDropdown extends StatelessWidget {
  const _SettingsDropdown({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.fullWidth = false,
    this.prefixIcon,
  });

  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final bool fullWidth;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: fullWidth ? double.infinity : 360,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: .7)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: value,
            dropdownColor: const Color(0xFF0F3427),
            style: const TextStyle(color: AppColors.white, fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF0F3427),
              prefixIcon: prefixIcon == null ? null : Icon(prefixIcon, color: AppColors.muted, size: 18),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.stroke)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.green)),
            ),
            items: options
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    ))
                .toList(growable: false),
            onChanged: (next) {
              if (next != null) onChanged(next);
            },
          ),
        ],
      ),
    );
  }
}

class _AsrSelector extends StatelessWidget {
  const _AsrSelector({
    required this.value,
    required this.onChanged,
    this.label = 'ASR CALCULATION',
  });

  final String value;
  final ValueChanged<String> onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: .7)),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: _AsrOption(
                  label: 'Standard (Shafi\'i, Maliki, Hanbali)',
                  active: value == 'Standard',
                  onTap: () => onChanged('Standard'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _AsrOption(
                  label: 'Hanafi',
                  active: value == 'Hanafi',
                  onTap: () => onChanged('Hanafi'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AsrOption extends StatelessWidget {
  const _AsrOption({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF0F4A35).withValues(alpha: 0.45) : const Color(0xFF0F3427),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: active ? AppColors.green : AppColors.stroke),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? AppColors.green : AppColors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsSnapshot {
  const _SettingsSnapshot({
    required this.lightMode,
    required this.maintenanceMode,
    required this.locationServicesEnabled,
    required this.defaultCity,
    required this.defaultCalendar,
    required this.searchSensitivity,
    required this.calculationMethod,
    required this.asrMethod,
    required this.highLatitudeRule,
    required this.broadcastsEnabled,
    required this.firebaseServerKey,
    required this.fcmProjectId,
    required this.sendgridApiKey,
    required this.verifiedSenderEmail,
    required this.twilioAccountSid,
    required this.twilioAuthToken,
    required this.prayerOffsets,
  });

  final bool lightMode;
  final bool maintenanceMode;
  final bool locationServicesEnabled;
  final String defaultCity;
  final String defaultCalendar;
  final String searchSensitivity;
  final String calculationMethod;
  final String asrMethod;
  final String highLatitudeRule;
  final bool broadcastsEnabled;
  final String firebaseServerKey;
  final String fcmProjectId;
  final String sendgridApiKey;
  final String verifiedSenderEmail;
  final String twilioAccountSid;
  final String twilioAuthToken;
  final Map<String, int> prayerOffsets;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _SettingsSnapshot &&
        other.lightMode == lightMode &&
        other.maintenanceMode == maintenanceMode &&
        other.locationServicesEnabled == locationServicesEnabled &&
        other.defaultCity == defaultCity &&
        other.defaultCalendar == defaultCalendar &&
        other.searchSensitivity == searchSensitivity &&
        other.calculationMethod == calculationMethod &&
        other.asrMethod == asrMethod &&
        other.highLatitudeRule == highLatitudeRule &&
        other.broadcastsEnabled == broadcastsEnabled &&
        other.firebaseServerKey == firebaseServerKey &&
        other.fcmProjectId == fcmProjectId &&
        other.sendgridApiKey == sendgridApiKey &&
        other.verifiedSenderEmail == verifiedSenderEmail &&
        other.twilioAccountSid == twilioAccountSid &&
        other.twilioAuthToken == twilioAuthToken &&
        _sameOffsets(other.prayerOffsets, prayerOffsets);
  }

  @override
  int get hashCode => Object.hash(
        lightMode,
        maintenanceMode,
        locationServicesEnabled,
        defaultCity,
        defaultCalendar,
        searchSensitivity,
        calculationMethod,
        asrMethod,
        highLatitudeRule,
        broadcastsEnabled,
        firebaseServerKey,
        fcmProjectId,
        sendgridApiKey,
        verifiedSenderEmail,
        twilioAccountSid,
        twilioAuthToken,
        Object.hashAll(
          prayerOffsets.entries.map((entry) => Object.hash(entry.key, entry.value)),
        ),
      );

  static bool _sameOffsets(Map<String, int> a, Map<String, int> b) {
    if (a.length != b.length) return false;
    for (final entry in a.entries) {
      if (b[entry.key] != entry.value) return false;
    }
    return true;
  }
}

class _AbuseReportsBody extends StatefulWidget {
  const _AbuseReportsBody({this.compact = false, this.mobile = false});

  final bool compact;
  final bool mobile;

  @override
  State<_AbuseReportsBody> createState() => _AbuseReportsBodyState();
}

class _AbuseReportsBodyState extends State<_AbuseReportsBody> {
  String selectedDecision = 'timeout';

  static const List<_AbuseLogEntry> _entries = [
    _AbuseLogEntry(
      author: 'Abdullah Al-Farsi',
      time: '14:20',
      message: 'The explanation of Ayah 5 was very clear, Jazakallah Khair.',
      flagged: false,
    ),
    _AbuseLogEntry(
      author: 'Hamza Ibrahim',
      time: '14:22',
      message: "I don't think you know what you're talking about. This is completely wrong and you're wasting everyone's time. Stop talking.",
      flagged: true,
    ),
    _AbuseLogEntry(
      author: 'Sara Uthman',
      time: '14:22',
      message: 'Please stay respectful brothers, we are here to learn.',
      flagged: false,
    ),
    _AbuseLogEntry(
      author: 'Hamza Ibrahim',
      time: '14:23',
      message: "Stay out of this Sara. You're just as clueless. This platform is a joke.",
      flagged: true,
    ),
    _AbuseLogEntry(
      author: 'Hamza Ibrahim',
      time: '14:25',
      message: '[Deleted Message - Contains inappropriate language]',
      flagged: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final compact = widget.compact;
    final mobile = widget.mobile;
    final titleSize = mobile ? 24.0 : (compact ? 30.0 : 40.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            InkWell(
              onTap: () => context.read<DashboardCubit>().openOverview(),
              child: const Text(
                'Back to Reports',
                style: TextStyle(color: AppColors.muted, fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              'Investigation: Case #AR-8824',
              style: TextStyle(color: AppColors.white, fontSize: titleSize, fontWeight: FontWeight.w700),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF5A1F1D).withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFF5C5C).withValues(alpha: 0.5)),
              ),
              child: const Text(
                'HIGH PRIORITY',
                style: TextStyle(color: Color(0xFFFF5C5C), fontSize: 11, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            _AbuseSummaryCard(
              title: 'REPORTER',
              name: 'Sara Uthman',
              detail: 'Student • 4 reports made',
              icon: Icons.person,
              iconBg: Color(0xFFF3F0E3),
            ),
            _AbuseSummaryCard(
              title: 'REPORTED USER',
              name: 'Hamza Ibrahim',
              detail: 'Student • 2 previous warnings',
              icon: Icons.person_off,
              iconBg: Color(0xFFB6B5A8),
              warning: true,
            ),
            _AbuseSummaryCard(
              title: 'REASON',
              name: 'HARASSMENT',
              detail: 'Reported 2 hours ago',
              body: '"User keeps posting disrespectful comments during the Tafseer live session."',
              reasonPill: true,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF12392A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.stroke),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 14, 16, 12),
                  child: Row(
                    children: [
                      Icon(Icons.history, color: AppColors.green, size: 20),
                      SizedBox(width: 8),
                      Text('Reported Activity Log', style: TextStyle(color: AppColors.white, fontSize: 30, fontWeight: FontWeight.w700)),
                      Spacer(),
                      Text('Showing last 20 messages', style: TextStyle(color: AppColors.muted, fontSize: 14)),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AppColors.stroke),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                    itemBuilder: (context, index) {
                      final entry = _entries[index];
                      return _AbuseLogTile(entry: entry);
                    },
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemCount: _entries.length,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF12392A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.stroke),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Administrative Decision', style: TextStyle(color: AppColors.white, fontSize: 30, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _DecisionChip(
                    label: 'Issue Warning',
                    active: selectedDecision == 'warning',
                    onTap: () => setState(() => selectedDecision = 'warning'),
                  ),
                  _DecisionChip(
                    label: 'Temporary Timeout',
                    active: selectedDecision == 'timeout',
                    onTap: () => setState(() => selectedDecision = 'timeout'),
                  ),
                  _DecisionChip(
                    label: 'Suspend Account',
                    active: selectedDecision == 'suspend',
                    onTap: () => setState(() => selectedDecision = 'suspend'),
                    danger: true,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.item,
                        side: const BorderSide(color: AppColors.stroke),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Dismiss Report'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: const Color(0xFF032519),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Apply Decision', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AbuseSummaryCard extends StatelessWidget {
  const _AbuseSummaryCard({
    required this.title,
    required this.name,
    required this.detail,
    this.body,
    this.icon,
    this.iconBg,
    this.warning = false,
    this.reasonPill = false,
  });

  final String title;
  final String name;
  final String detail;
  final String? body;
  final IconData? icon;
  final Color? iconBg;
  final bool warning;
  final bool reasonPill;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 390),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF12392A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.stroke),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: AppColors.muted, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: .8)),
            const SizedBox(height: 8),
            Row(
              children: [
                if (!reasonPill)
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: iconBg ?? const Color(0xFF274C3F),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon ?? Icons.person, color: const Color(0xFF3A5E4F)),
                  ),
                if (!reasonPill) const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (reasonPill)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF5A1F1D).withValues(alpha: 0.45),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: const Text('HARASSMENT', style: TextStyle(color: Color(0xFFFF5C5C), fontSize: 11, fontWeight: FontWeight.w700)),
                            )
                          else
                            Text(name, style: const TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                          const SizedBox(width: 8),
                          if (!reasonPill)
                            if (warning) const Icon(Icons.warning_amber_rounded, color: Color(0xFFFF5C5C), size: 22),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(detail, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
            if (body != null) ...[
              const SizedBox(height: 8),
              Text(body!, style: const TextStyle(color: AppColors.item, fontSize: 14, fontStyle: FontStyle.italic, height: 1.35)),
            ],
          ],
        ),
      ),
    );
  }
}

class _AbuseLogTile extends StatelessWidget {
  const _AbuseLogTile({required this.entry});

  final _AbuseLogEntry entry;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F3427),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: entry.flagged ? const Color(0xFFFF5C5C).withValues(alpha: 0.45) : AppColors.stroke,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                entry.author,
                style: TextStyle(color: entry.flagged ? const Color(0xFFFF7373) : AppColors.green, fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 8),
              Text(entry.time, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 8),
          Text(entry.message, style: const TextStyle(color: AppColors.white, fontSize: 16, height: 1.45)),
        ],
      ),
    );
  }
}

class _DecisionChip extends StatelessWidget {
  const _DecisionChip({
    required this.label,
    required this.active,
    required this.onTap,
    this.danger = false,
  });

  final String label;
  final bool active;
  final bool danger;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = danger ? const Color(0xFFFF7373) : AppColors.green;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: active ? activeColor.withValues(alpha: 0.14) : const Color(0xFF0F3427),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: active ? activeColor.withValues(alpha: 0.45) : AppColors.stroke),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? activeColor : AppColors.item,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _AbuseLogEntry {
  const _AbuseLogEntry({
    required this.author,
    required this.time,
    required this.message,
    required this.flagged,
  });

  final String author;
  final String time;
  final String message;
  final bool flagged;
}


class _VerificationRequestsBody extends StatelessWidget {
  const _VerificationRequestsBody({
    required this.onBackToDashboard,
    this.compact = false,
    this.mobile = false,
  });

  final VoidCallback onBackToDashboard;
  final bool compact;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DashboardCubit>().state;
    final selected = state.selectedVerification;
    if (selected != null) {
      return _VerificationDocumentViewer(application: selected, compact: compact, mobile: mobile);
    }
    final apps = state.filteredVerificationApplications;
    final titleSize = compact ? 28.0 : 40.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Scholar Verification',
          style: TextStyle(color: AppColors.white, fontSize: titleSize, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        const Text(
          'Review and validate professional credentials for scholar applicants.',
          style: TextStyle(color: AppColors.muted, fontSize: 16),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _VerificationStat(icon: Icons.description, label: 'TOTAL APPLICATIONS', value: '1,248', compact: compact),
            _VerificationStat(icon: Icons.pending_actions, label: 'PENDING REVIEW', value: '4', compact: compact, color: const Color(0xFFE2C64A)),
            _VerificationStat(icon: Icons.verified, label: 'VERIFIED SCHOLARS', value: '312', compact: compact, color: const Color(0xFF7AB8FF)),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Text(
              'PENDING APPLICATIONS',
              style: TextStyle(color: const Color(0xFFA2B9AF), fontSize: compact ? 18 : 30, fontWeight: FontWeight.w700, letterSpacing: .8),
            ),
            const Spacer(),
            InkWell(
              onTap: () => context.read<DashboardCubit>().markAllVerificationViewed(),
              child: const Text('Mark all as viewed', style: TextStyle(color: AppColors.green, fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView(
            children: [
              for (final app in apps) ...[
                _VerificationRequestRow(
                  application: app,
                  compact: compact,
                ),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 18),
              Center(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.muted,
                    side: const BorderSide(color: AppColors.stroke),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {},
                  child: const Text('Load More Applications'),
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ],
    );
  }
}

class _VerificationRequestRow extends StatelessWidget {
  const _VerificationRequestRow({
    required this.application,
    this.compact = false,
  });

  final VerificationApplication application;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DashboardCubit>();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF12392A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xFF2D4E67),
            child: Icon(Icons.person, size: 28, color: Color(0xFFB7D0E0)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(application.name, style: TextStyle(color: AppColors.white, fontSize: compact ? 18 : 22, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4C4620).withValues(alpha: .4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'PENDING VERIFICATION',
                        style: TextStyle(color: Color(0xFFE2C64A), fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(application.appliedAt.toUpperCase(), style: const TextStyle(color: AppColors.muted, fontSize: 12, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '"${application.title}, ${application.summary}"',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: const Color(0xFF8BA79C), fontSize: compact ? 14 : 16, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFA3B9B0),
                  side: const BorderSide(color: AppColors.stroke),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => cubit.openVerificationDocument(application.id),
                child: const Text('View Documents'),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFF7A7A),
                  side: const BorderSide(color: Color(0xFF6A2E2E)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => cubit.rejectVerification(application.id),
                child: const Text('Reject'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: const Color(0xFF032519),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => cubit.approveVerification(application.id),
                child: const Text('Approve'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VerificationDocumentViewer extends StatelessWidget {
  const _VerificationDocumentViewer({
    required this.application,
    this.compact = false,
    this.mobile = false,
  });

  final VerificationApplication application;
  final bool compact;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DashboardCubit>();
    return Column(
      children: [
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF0E3529),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.stroke),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              TextButton.icon(
                onPressed: cubit.closeVerificationDocument,
                icon: const Icon(Icons.arrow_back, color: AppColors.muted, size: 18),
                label: const Text('BACK TO LIST', style: TextStyle(color: AppColors.muted, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 12),
              const Text('Scholar Document Verification Viewer', style: TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.w700)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFF4C4620).withValues(alpha: .4), borderRadius: BorderRadius.circular(14)),
                child: Text('APPLICATION ID: ${application.id.toUpperCase()}', style: const TextStyle(color: Color(0xFFE2C64A), fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 7,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF082B20),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.stroke),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 520,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(color: const Color(0xFF1D3A33), borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.stroke)),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.zoom_out_map, color: AppColors.white, size: 18),
                            Text('100%', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w700)),
                            Icon(Icons.restart_alt, color: AppColors.white, size: 18),
                            Text('Page 1 of 2', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w700)),
                            Icon(Icons.chevron_right, color: AppColors.white, size: 18),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.all(36),
                          child: Column(
                            children: [
                              const SizedBox(height: 32),
                              const Text('Al-Azhar University', style: TextStyle(color: Color(0xFF1D2435), fontSize: 34, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic)),
                              const SizedBox(height: 26),
                              const Text('This is to certify that', style: TextStyle(color: Color(0xFF334155), fontSize: 18)),
                              const SizedBox(height: 8),
                              Text(application.name, style: const TextStyle(color: Color(0xFF0F172A), fontSize: 48, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 18),
                              Text(application.title, style: const TextStyle(color: Color(0xFF0F172A), fontSize: 40, fontWeight: FontWeight.w700, fontStyle: FontStyle.italic), textAlign: TextAlign.center),
                              const Spacer(),
                              const Text('ACADEMIC DEAN', style: TextStyle(color: Color(0xFF64748B), letterSpacing: 1)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: const Color(0xFF12392A), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.stroke)),
                              child: Text('FILE NAME\n${application.fileName}', style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w700)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: const Color(0xFF12392A), borderRadius: const BorderRadius.all(Radius.circular(12)), border: Border.all(color: AppColors.stroke)),
                              child: const Text('STATUS\nAuthenticity Checked (AI Scan)', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: const Color(0xFF12392A), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.stroke)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(application.name, style: const TextStyle(color: AppColors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                      Text(application.title, style: const TextStyle(color: Color(0xFFE2C64A), fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      Text('VERIFICATION CHECKLIST', style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w700, letterSpacing: .7)),
                      const SizedBox(height: 10),
                      _VerificationToggleItem(
                        label: 'ID Match',
                        subtitle: 'Document matches government ID',
                        value: application.idMatch,
                        onChanged: (v) => cubit.toggleVerificationChecklist(idMatch: v),
                      ),
                      const SizedBox(height: 8),
                      _VerificationToggleItem(
                        label: 'Degree Authenticity',
                        subtitle: 'Validated with University database',
                        value: application.degreeAuthenticity,
                        onChanged: (v) => cubit.toggleVerificationChecklist(degreeAuthenticity: v),
                      ),
                      const SizedBox(height: 8),
                      _VerificationToggleItem(
                        label: 'Background Check',
                        subtitle: 'Security and criminal record review',
                        value: application.backgroundCheck,
                        onChanged: (v) => cubit.toggleVerificationChecklist(backgroundCheck: v),
                      ),
                      const SizedBox(height: 12),
                      const Text('ADMIN NOTES', style: TextStyle(color: AppColors.muted, fontWeight: FontWeight.w700, letterSpacing: .7)),
                      const SizedBox(height: 8),
                      Expanded(
                        child: TextField(
                          controller: TextEditingController(text: application.notes),
                          onChanged: cubit.updateVerificationNotes,
                          maxLines: null,
                          expands: true,
                          style: const TextStyle(color: AppColors.white),
                          decoration: InputDecoration(
                            hintText: 'Enter notes for this application...',
                            hintStyle: const TextStyle(color: AppColors.muted),
                            filled: true,
                            fillColor: const Color(0xFF0F3427),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          style: FilledButton.styleFrom(backgroundColor: AppColors.green, foregroundColor: const Color(0xFF032519), padding: const EdgeInsets.symmetric(vertical: 14)),
                          onPressed: cubit.approveVerification,
                          child: const Text('Approve & Verify Scholar'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: cubit.requestMoreInfo,
                              style: OutlinedButton.styleFrom(foregroundColor: AppColors.muted, side: const BorderSide(color: AppColors.stroke), padding: const EdgeInsets.symmetric(vertical: 12)),
                              child: const Text('Request More Info'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: cubit.rejectVerification,
                              style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFFF7A7A), side: const BorderSide(color: Color(0xFF6A2E2E)), padding: const EdgeInsets.symmetric(vertical: 12)),
                              child: const Text('Reject'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VerificationToggleItem extends StatelessWidget {
  const _VerificationToggleItem({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFF0F3427), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.stroke)),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: (v) => onChanged(v ?? false),
            activeColor: AppColors.green,
            checkColor: const Color(0xFF032519),
            side: const BorderSide(color: AppColors.strokeBright),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w700)),
                Text(subtitle, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VerificationStat extends StatelessWidget {
  const _VerificationStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.compact,
    this.color = AppColors.green,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool compact;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DashboardCubit>().state;
    final dynamicValue = switch (label) {
      'TOTAL APPLICATIONS' => state.verificationTotalCount.toString(),
      'PENDING REVIEW' => state.verificationPendingCount.toString(),
      'VERIFIED SCHOLARS' => state.verificationApprovedCount.toString(),
      _ => value,
    };
    return Container(
      width: compact ? 260 : 350,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF12392A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: .7)),
              Text(dynamicValue, style: TextStyle(color: AppColors.white, fontSize: compact ? 24 : 42, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}
