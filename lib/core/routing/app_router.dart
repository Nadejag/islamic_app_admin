import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/ask_scholar/presentation/ask_scholar_page.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/charity/presentation/charity_page.dart';
import '../../features/cms/presentation/cms_page.dart';
import '../../features/dashboard/presentation/dashboard_page.dart';
import '../../features/events/presentation/events_page.dart';
import '../../features/logs/presentation/system_logs_page.dart';
import '../../features/reports/presentation/reports_page.dart';
import '../../features/scholars/presentation/scholars_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/teaching/presentation/teaching_page.dart';
import '../../features/users/presentation/users_page.dart';
import '../../admin_home_control.dart';
import '../providers/providers.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authUserAsync = ref.watch(authUserProvider);

  return GoRouter(
    initialLocation: AppRoutes.dashboard,
    redirect: (context, state) {
      final authUser = authUserAsync.valueOrNull;
      final loggingIn = state.uri.path == AppRoutes.login;

      if (authUserAsync.isLoading) return null;

      if (authUser == null) {
        return loggingIn ? null : AppRoutes.login;
      }

      if (loggingIn) return AppRoutes.dashboard;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (_, __) => const DashboardPage(),
      ),
      GoRoute(
        path: AppRoutes.users,
        builder: (_, __) => const UsersPage(),
      ),
      GoRoute(
        path: AppRoutes.scholars,
        builder: (_, __) => const ScholarsPage(),
      ),
      GoRoute(
        path: AppRoutes.charity,
        builder: (_, __) => const CharityPage(),
      ),
      GoRoute(
        path: AppRoutes.cms,
        builder: (_, __) => const CmsPage(),
      ),
      GoRoute(
        path: AppRoutes.events,
        builder: (_, __) => const EventsPage(),
      ),
      GoRoute(
        path: AppRoutes.teaching,
        builder: (_, __) => const TeachingPage(),
      ),
      GoRoute(
        path: AppRoutes.askScholar,
        builder: (_, __) => const AskScholarPage(),
      ),
      GoRoute(
        path: AppRoutes.reports,
        builder: (_, __) => const ReportsPage(),
      ),
      GoRoute(
        path: AppRoutes.logs,
        builder: (_, __) => const SystemLogsPage(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (_, __) => const SettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.homeControl,
        builder: (_, __) => const AdminHomeControlScreen(),
      ),
    ],
  );
});
