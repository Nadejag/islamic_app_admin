import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/providers.dart';
import '../../core/routing/app_routes.dart';

class AdminScaffold extends ConsumerWidget {
  const AdminScaffold({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final location = GoRouterState.of(context).uri.path;
    final navItems = _itemsForSuperAdmin();
    final selectedIndex = navItems.indexWhere((i) => i.route == location);
    final isDesktop = MediaQuery.of(context).size.width >= 1100;
    final nav = _SideNav(
      items: navItems,
      selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
    );

    return Scaffold(
      drawer: isDesktop ? null : Drawer(child: nav),
      body: Row(
        children: [
          if (isDesktop) SizedBox(width: 280, child: nav),
          Expanded(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withAlpha(
                      theme.brightness == Brightness.dark ? 220 : 235,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x12000000),
                        blurRadius: 14,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: AppBar(
                    title: Text(title),
                    leading: isDesktop
                        ? null
                        : Builder(
                            builder: (context) {
                              return IconButton(
                                icon: const Icon(Icons.menu),
                                onPressed: () =>
                                    Scaffold.of(context).openDrawer(),
                              );
                            },
                          ),
                    actions: [
                      if (isDesktop)
                        SizedBox(
                          width: 260,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search modules',
                                isDense: true,
                                prefixIcon: const Icon(Icons.search, size: 18),
                                hintStyle: theme.textTheme.bodySmall,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: theme.colorScheme.primaryContainer.withAlpha(
                              theme.brightness == Brightness.dark ? 80 : 170),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.verified,
                              size: 16,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Super Admin',
                              style: TextStyle(
                                  color: theme.colorScheme.onPrimaryContainer),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: () async {
                          await ref.read(authServiceProvider).signOut();
                        },
                        icon: const Icon(Icons.logout, size: 18),
                        label: const Text('Logout'),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: body,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<_NavItem> _itemsForSuperAdmin() {
    return const [
      _NavItem('Dashboard', Icons.dashboard_outlined, AppRoutes.dashboard),
      _NavItem('Users', Icons.group_outlined, AppRoutes.users),
      _NavItem('Scholar Verify', Icons.workspace_premium_outlined,
          AppRoutes.scholars),
      _NavItem('Charity', Icons.volunteer_activism_outlined, AppRoutes.charity),
      _NavItem('Content Control', Icons.menu_book_outlined, AppRoutes.cms),
      _NavItem('Events', Icons.event_outlined, AppRoutes.events),
      _NavItem(
          'Teaching', Icons.cast_for_education_outlined, AppRoutes.teaching),
      _NavItem('Ask Scholar Q&A', Icons.question_answer_outlined,
          AppRoutes.askScholar),
      _NavItem('Reports & Safety', Icons.report_outlined, AppRoutes.reports),
      _NavItem('Audit Logs', Icons.fact_check_outlined, AppRoutes.logs),
      _NavItem('Settings', Icons.settings_outlined, AppRoutes.settings),
    ];
  }
}

class _SideNav extends StatelessWidget {
  const _SideNav({
    required this.items,
    required this.selectedIndex,
  });

  final List<_NavItem> items;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A241C), Color(0xFF123B2D), Color(0xFF0E2A21)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 16, 18, 12),
              child: Text(
                'ASK ISLAM\nSuper Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  height: 1.3,
                ),
              ),
            ),
            const Divider(color: Colors.white24, height: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final selected = index == selectedIndex;
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: selected
                            ? const Color(0x263FB779)
                            : Colors.transparent,
                      ),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        leading: AnimatedScale(
                          duration: const Duration(milliseconds: 220),
                          scale: selected ? 1.08 : 1,
                          child: Icon(item.icon,
                              color: selected ? Colors.white : Colors.white70),
                        ),
                        title: Text(
                          item.label,
                          style: TextStyle(
                            color: selected ? Colors.white : Colors.white70,
                            fontWeight:
                                selected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                        onTap: () => context.go(item.route),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.icon, this.route);
  final String label;
  final IconData icon;
  final String route;
}
