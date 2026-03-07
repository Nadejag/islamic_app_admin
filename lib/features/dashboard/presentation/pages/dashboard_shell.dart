part of 'dashboard_page.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit(),
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              if (width >= 1200) {
                return Scaffold(
                  body: _DashboardCanvas(
                    currentView: state.view,
                    selectedUserId: state.selectedUserId,
                    onOpenMediaScreen: () =>
                        context.read<DashboardCubit>().openMedia(),
                    onOpenUserManagement: () =>
                        context.read<DashboardCubit>().openUserManagement(),
                    onOpenUserDetails: (userId) =>
                        context.read<DashboardCubit>().openUserDetails(userId),
                    onBackToUsers: () =>
                        context.read<DashboardCubit>().backToUsers(),
                    onBackToDashboard: () =>
                        context.read<DashboardCubit>().openOverview(),
                    onOpenVerificationRequests: () =>
                        context.read<DashboardCubit>().openVerificationRequests(),
                    onOpenCharityApprovals: () =>
                        context.read<DashboardCubit>().openCharityApprovals(),
                    onOpenAbuseReports: () =>
                        context.read<DashboardCubit>().openAbuseReports(),
                    onOpenSystemSettings: () =>
                        context.read<DashboardCubit>().openSystemSettings(),
                  ),
                );
              }
              if (width >= 768) {
                return Scaffold(
                  body: _TabletDashboard(
                    currentView: state.view,
                    selectedUserId: state.selectedUserId,
                    onOpenMediaScreen: () =>
                        context.read<DashboardCubit>().openMedia(),
                    onOpenUserManagement: () =>
                        context.read<DashboardCubit>().openUserManagement(),
                    onOpenUserDetails: (userId) =>
                        context.read<DashboardCubit>().openUserDetails(userId),
                    onBackToUsers: () =>
                        context.read<DashboardCubit>().backToUsers(),
                    onBackToDashboard: () =>
                        context.read<DashboardCubit>().openOverview(),
                    onOpenVerificationRequests: () =>
                        context.read<DashboardCubit>().openVerificationRequests(),
                    onOpenCharityApprovals: () =>
                        context.read<DashboardCubit>().openCharityApprovals(),
                    onOpenAbuseReports: () =>
                        context.read<DashboardCubit>().openAbuseReports(),
                    onOpenSystemSettings: () =>
                        context.read<DashboardCubit>().openSystemSettings(),
                  ),
                );
              }
              return _MobileDashboard(
                currentView: state.view,
                selectedUserId: state.selectedUserId,
                onOpenMediaScreen: () =>
                    context.read<DashboardCubit>().openMedia(),
                onOpenUserManagement: () =>
                    context.read<DashboardCubit>().openUserManagement(),
                onOpenUserDetails: (userId) =>
                    context.read<DashboardCubit>().openUserDetails(userId),
                onBackToUsers: () =>
                    context.read<DashboardCubit>().backToUsers(),
                onBackToDashboard: () =>
                    context.read<DashboardCubit>().openOverview(),
                onOpenVerificationRequests: () =>
                    context.read<DashboardCubit>().openVerificationRequests(),
                onOpenCharityApprovals: () =>
                    context.read<DashboardCubit>().openCharityApprovals(),
                onOpenAbuseReports: () =>
                    context.read<DashboardCubit>().openAbuseReports(),
                onOpenSystemSettings: () =>
                    context.read<DashboardCubit>().openSystemSettings(),
              );
            },
          );
        },
      ),
    );
  }
}

class _DashboardCanvas extends StatelessWidget {
  const _DashboardCanvas({
    required this.currentView,
    required this.selectedUserId,
    required this.onOpenMediaScreen,
    required this.onOpenUserManagement,
    required this.onOpenUserDetails,
    required this.onBackToUsers,
    required this.onBackToDashboard,
    required this.onOpenVerificationRequests,
    required this.onOpenCharityApprovals,
    required this.onOpenAbuseReports,
    required this.onOpenSystemSettings,
  });

  final DashboardView currentView;
  final String? selectedUserId;
  final VoidCallback onOpenMediaScreen;
  final VoidCallback onOpenUserManagement;
  final ValueChanged<String> onOpenUserDetails;
  final VoidCallback onBackToUsers;
  final VoidCallback onBackToDashboard;
  final VoidCallback onOpenVerificationRequests;
  final VoidCallback onOpenCharityApprovals;
  final VoidCallback onOpenAbuseReports;
  final VoidCallback onOpenSystemSettings;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF062A1F), AppColors.bg],
        ),
      ),
      child: Row(
        children: [
          _Sidebar(
            currentView: currentView,
            onOpenDashboard: onBackToDashboard,
            onOpenUserManagement: onOpenUserManagement,
            onOpenMediaScreen: onOpenMediaScreen,
            onOpenVerificationRequests: onOpenVerificationRequests,
            onOpenCharityApprovals: onOpenCharityApprovals,
            onOpenAbuseReports: onOpenAbuseReports,
            onOpenSystemSettings: onOpenSystemSettings,
          ),
          Expanded(
            child: _MainArea(
              currentView: currentView,
              selectedUserId: selectedUserId,
              onOpenMediaScreen: onOpenMediaScreen,
              onOpenUserManagement: onOpenUserManagement,
              onOpenUserDetails: onOpenUserDetails,
              onBackToUsers: onBackToUsers,
              onBackToDashboard: onBackToDashboard,
              onOpenVerificationRequests: onOpenVerificationRequests,
              onOpenCharityApprovals: onOpenCharityApprovals,
              onOpenAbuseReports: onOpenAbuseReports,
              onOpenSystemSettings: onOpenSystemSettings,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabletDashboard extends StatelessWidget {
  const _TabletDashboard({
    required this.currentView,
    required this.selectedUserId,
    required this.onOpenMediaScreen,
    required this.onOpenUserManagement,
    required this.onOpenUserDetails,
    required this.onBackToUsers,
    required this.onBackToDashboard,
    required this.onOpenVerificationRequests,
    required this.onOpenCharityApprovals,
    required this.onOpenAbuseReports,
    required this.onOpenSystemSettings,
  });

  final DashboardView currentView;
  final String? selectedUserId;
  final VoidCallback onOpenMediaScreen;
  final VoidCallback onOpenUserManagement;
  final ValueChanged<String> onOpenUserDetails;
  final VoidCallback onBackToUsers;
  final VoidCallback onBackToDashboard;
  final VoidCallback onOpenVerificationRequests;
  final VoidCallback onOpenCharityApprovals;
  final VoidCallback onOpenAbuseReports;
  final VoidCallback onOpenSystemSettings;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF062A1F), AppColors.bg],
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: _SidebarCompact(
              currentView: currentView,
              onOpenDashboard: onBackToDashboard,
              onOpenUserManagement: onOpenUserManagement,
              onOpenMediaScreen: onOpenMediaScreen,
              onOpenVerificationRequests: onOpenVerificationRequests,
              onOpenCharityApprovals: onOpenCharityApprovals,
              onOpenAbuseReports: onOpenAbuseReports,
              onOpenSystemSettings: onOpenSystemSettings,
            ),
          ),
          Expanded(
            child: _MainAreaTablet(
              currentView: currentView,
              selectedUserId: selectedUserId,
              onOpenMediaScreen: onOpenMediaScreen,
              onOpenUserManagement: onOpenUserManagement,
              onOpenUserDetails: onOpenUserDetails,
              onBackToUsers: onBackToUsers,
              onBackToDashboard: onBackToDashboard,
              onOpenVerificationRequests: onOpenVerificationRequests,
              onOpenCharityApprovals: onOpenCharityApprovals,
              onOpenAbuseReports: onOpenAbuseReports,
              onOpenSystemSettings: onOpenSystemSettings,
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileDashboard extends StatelessWidget {
  const _MobileDashboard({
    required this.currentView,
    required this.selectedUserId,
    required this.onOpenMediaScreen,
    required this.onOpenUserManagement,
    required this.onOpenUserDetails,
    required this.onBackToUsers,
    required this.onBackToDashboard,
    required this.onOpenVerificationRequests,
    required this.onOpenCharityApprovals,
    required this.onOpenAbuseReports,
    required this.onOpenSystemSettings,
  });

  final DashboardView currentView;
  final String? selectedUserId;
  final VoidCallback onOpenMediaScreen;
  final VoidCallback onOpenUserManagement;
  final ValueChanged<String> onOpenUserDetails;
  final VoidCallback onBackToUsers;
  final VoidCallback onBackToDashboard;
  final VoidCallback onOpenVerificationRequests;
  final VoidCallback onOpenCharityApprovals;
  final VoidCallback onOpenAbuseReports;
  final VoidCallback onOpenSystemSettings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        width: 276,
        backgroundColor: Colors.transparent,
        child: _Sidebar(
          currentView: currentView,
          onOpenDashboard: onBackToDashboard,
          onOpenUserManagement: onOpenUserManagement,
          onOpenMediaScreen: onOpenMediaScreen,
          onOpenVerificationRequests: onOpenVerificationRequests,
          onOpenCharityApprovals: onOpenCharityApprovals,
          onOpenAbuseReports: onOpenAbuseReports,
          onOpenSystemSettings: onOpenSystemSettings,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF062A1F), AppColors.bg],
          ),
        ),
        child: SafeArea(
          child: _MainAreaMobile(
            currentView: currentView,
            selectedUserId: selectedUserId,
            onOpenMediaScreen: onOpenMediaScreen,
            onOpenUserManagement: onOpenUserManagement,
            onOpenUserDetails: onOpenUserDetails,
            onBackToUsers: onBackToUsers,
            onBackToDashboard: onBackToDashboard,
            onOpenVerificationRequests: onOpenVerificationRequests,
            onOpenCharityApprovals: onOpenCharityApprovals,
            onOpenAbuseReports: onOpenAbuseReports,
            onOpenSystemSettings: onOpenSystemSettings,
          ),
        ),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.currentView,
    required this.onOpenDashboard,
    required this.onOpenUserManagement,
    required this.onOpenMediaScreen,
    required this.onOpenVerificationRequests,
    required this.onOpenCharityApprovals,
    required this.onOpenAbuseReports,
    required this.onOpenSystemSettings,
  });

  final DashboardView currentView;
  final VoidCallback onOpenDashboard;
  final VoidCallback onOpenUserManagement;
  final VoidCallback onOpenMediaScreen;
  final VoidCallback onOpenVerificationRequests;
  final VoidCallback onOpenCharityApprovals;
  final VoidCallback onOpenAbuseReports;
  final VoidCallback onOpenSystemSettings;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: AppColors.sidebar,
        border: Border(right: BorderSide(color: AppColors.stroke)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 22),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                _BrandIcon(),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'ASK Islam',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const _MenuLabel('MAIN MENU'),
          const SizedBox(height: 8),
          _MenuItem(
            icon: Icons.grid_view_rounded,
            title: 'Dashboard',
            active: currentView == DashboardView.overview,
            onTap: onOpenDashboard,
          ),
          _MenuItem(
            icon: Icons.group_outlined,
            title: 'User Management',
            active: currentView == DashboardView.userManagement,
            onTap: onOpenUserManagement,
          ),
          _MenuItem(
            icon: Icons.verified_user_outlined,
            title: 'Scholar Verification',
            badge: '4',
            active: currentView == DashboardView.verificationRequests,
            onTap: onOpenVerificationRequests,
          ),
          _MenuItem(
            icon: Icons.volunteer_activism_outlined,
            title: 'Charity Approvals',
            active: currentView == DashboardView.charityApprovals,
            onTap: onOpenCharityApprovals,
          ),
          const SizedBox(height: 12),
          const _MenuLabel('CONTENT & SAFETY'),
          const SizedBox(height: 8),
          _MenuItem(
            icon: Icons.menu_book_outlined,
            title: 'Content Control',
            active: currentView == DashboardView.media,
            onTap: onOpenMediaScreen,
          ),
          _MenuItem(
            icon: Icons.report_gmailerrorred_outlined,
            title: 'Abuse Reports',
            badge: '12',
            badgeRed: true,
            active: currentView == DashboardView.abuseReports,
            onTap: onOpenAbuseReports,
          ),
          _MenuItem(
            icon: Icons.settings_outlined,
            title: 'System Settings',
            active: currentView == DashboardView.systemSettings,
            onTap: onOpenSystemSettings,
          ),
          const Spacer(),
          Container(height: 1, color: AppColors.stroke),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFF3D2B8),
                    border: Border.all(
                      color: const Color(0xFF2A6F57),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFF2F4A3E),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Admin Zahid',
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Super Admin',
                        style: TextStyle(color: AppColors.muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => context.read<AuthBloc>().add(
                    const AuthSignOutRequested(),
                  ),
                  child: const Icon(
                    Icons.logout,
                    color: AppColors.muted,
                    size: 19,
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

class _SidebarCompact extends StatelessWidget {
  const _SidebarCompact({
    required this.currentView,
    required this.onOpenDashboard,
    required this.onOpenUserManagement,
    required this.onOpenMediaScreen,
    required this.onOpenVerificationRequests,
    required this.onOpenCharityApprovals,
    required this.onOpenAbuseReports,
    required this.onOpenSystemSettings,
  });

  final DashboardView currentView;
  final VoidCallback onOpenDashboard;
  final VoidCallback onOpenUserManagement;
  final VoidCallback onOpenMediaScreen;
  final VoidCallback onOpenVerificationRequests;
  final VoidCallback onOpenCharityApprovals;
  final VoidCallback onOpenAbuseReports;
  final VoidCallback onOpenSystemSettings;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.sidebar,
        border: Border(right: BorderSide(color: AppColors.stroke)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 18),
          const _BrandIcon(),
          const SizedBox(height: 18),
          _CompactMenuIcon(
            Icons.grid_view_rounded,
            currentView == DashboardView.overview,
            onTap: onOpenDashboard,
          ),
          _CompactMenuIcon(
            Icons.group_outlined,
            currentView == DashboardView.userManagement,
            onTap: onOpenUserManagement,
          ),
          _CompactMenuIcon(
            Icons.verified_user_outlined,
            currentView == DashboardView.verificationRequests,
            onTap: onOpenVerificationRequests,
          ),
          _CompactMenuIcon(
            Icons.volunteer_activism_outlined,
            currentView == DashboardView.charityApprovals,
            onTap: onOpenCharityApprovals,
          ),
          const SizedBox(height: 8),
          _CompactMenuIcon(
            Icons.menu_book_outlined,
            currentView == DashboardView.media,
            onTap: onOpenMediaScreen,
          ),
          _CompactMenuIcon(
            Icons.report_gmailerrorred_outlined,
            currentView == DashboardView.abuseReports,
            onTap: onOpenAbuseReports,
          ),
          _CompactMenuIcon(
            Icons.settings_outlined,
            currentView == DashboardView.systemSettings,
            onTap: onOpenSystemSettings,
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFF3D2B8),
              child: Icon(Icons.person, size: 16, color: Color(0xFF2F4A3E)),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactMenuIcon extends StatelessWidget {
  const _CompactMenuIcon(this.icon, this.active, {this.onTap});
  final IconData icon;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        height: 40,
        decoration: BoxDecoration(
          color: active ? const Color(0xFF0E3B2C) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 18,
          color: active ? AppColors.green : AppColors.iconMuted,
        ),
      ),
    );
  }
}

class _BrandIcon extends StatelessWidget {
  const _BrandIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.mosque_rounded,
        color: Color(0xFF053121),
        size: 24,
      ),
    );
  }
}

class _MenuLabel extends StatelessWidget {
  const _MenuLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF628074),
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: .8,
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.title,
    this.active = false,
    this.badge,
    this.badgeRed = false,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final bool active;
  final String? badge;
  final bool badgeRed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        height: 46,
        decoration: BoxDecoration(
          color: active ? const Color(0xFF0E3B2C) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Icon(
              icon,
              size: 18,
              color: active ? AppColors.green : AppColors.iconMuted,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: active ? AppColors.green : AppColors.item,
                  fontSize: 16,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeRed
                      ? const Color(0xFF5A1F1D)
                      : const Color(0xFF414722),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  badge!,
                  style: TextStyle(
                    color: badgeRed
                        ? const Color(0xFFFF5C5C)
                        : const Color(0xFFD2C85D),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}

class _MainArea extends StatelessWidget {
  const _MainArea({
    required this.currentView,
    required this.selectedUserId,
    required this.onOpenMediaScreen,
    required this.onOpenUserManagement,
    required this.onOpenUserDetails,
    required this.onBackToUsers,
    required this.onBackToDashboard,
    required this.onOpenVerificationRequests,
    required this.onOpenCharityApprovals,
    required this.onOpenAbuseReports,
    required this.onOpenSystemSettings,
  });

  final DashboardView currentView;
  final String? selectedUserId;
  final VoidCallback onOpenMediaScreen;
  final VoidCallback onOpenUserManagement;
  final ValueChanged<String> onOpenUserDetails;
  final VoidCallback onBackToUsers;
  final VoidCallback onBackToDashboard;
  final VoidCallback onOpenVerificationRequests;
  final VoidCallback onOpenCharityApprovals;
  final VoidCallback onOpenAbuseReports;
  final VoidCallback onOpenSystemSettings;

  @override
  Widget build(BuildContext context) {
    final dashboardCubit = context.read<DashboardCubit>();
    final selectedUser = context.select(
      (DashboardCubit cubit) => cubit.state.selectedUser,
    );
    final hasUnsavedChanges = context.select(
      (DashboardCubit cubit) => cubit.state.hasUnsavedUserChanges,
    );
    final isMedia = currentView == DashboardView.media;
    final isUserManagement = currentView == DashboardView.userManagement;
    final isVerificationRequests = currentView == DashboardView.verificationRequests;
    final isCharityApprovals = currentView == DashboardView.charityApprovals;
    final isAbuseReports = currentView == DashboardView.abuseReports;
    final isSystemSettings = currentView == DashboardView.systemSettings;
    final isUserDetails = isUserManagement && selectedUserId != null;
    return Column(
      children: [
        isUserDetails
            ? _UserDetailsTopBar(
                onBackToUsers: onBackToUsers,
                onBanAccount: dashboardCubit.banSelectedUser,
                onResetPassword: dashboardCubit.resetSelectedPassword,
                onSaveChanges: dashboardCubit.saveSelectedUserChanges,
                canSave: hasUnsavedChanges,
              )
            : _TopBar(
                searchHint: isMedia
                    ? 'Search for files, titles, or metadata...'
                    : isUserManagement
                    ? 'Search by name, email or ID...'
                    : isVerificationRequests
                    ? 'Search verification requests...'
                    : isCharityApprovals
                    ? 'Search requests...'
                    : isAbuseReports
                    ? 'Search abuse cases...'
                    : isSystemSettings
                    ? 'Search settings...'
                    : 'Search for users, scholars, or donations...',
                primaryButtonLabel: isMedia
                    ? 'Upload New Media'
                    : isUserManagement
                    ? 'Add New User'
                    : isVerificationRequests
                    ? 'Manual Verify'
                    : isCharityApprovals
                    ? 'Export Report'
                    : isAbuseReports
                    ? 'Assign Moderator'
                    : isSystemSettings
                    ? 'Save Changes'
                    : 'New Content',
                primaryButtonIcon: isMedia
                    ? Icons.cloud_upload
                    : isUserManagement
                    ? Icons.person_add_alt_1
                    : isVerificationRequests
                    ? Icons.verified
                    : isCharityApprovals
                    ? Icons.download
                    : isAbuseReports
                    ? Icons.gavel
                    : isSystemSettings
                    ? Icons.save
                    : Icons.add,
                onSearchChanged: dashboardCubit.setSearchQuery,
                onPrimaryAction: !isMedia &&
                        !isUserManagement &&
                        !isVerificationRequests &&
                        !isCharityApprovals &&
                        !isAbuseReports &&
                        !isSystemSettings
                    ? dashboardCubit.createNewContent
                    : null,
              ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final horizontalPadding = width > 2000 ? 40.0 : width > 1600 ? 32.0 : width > 1200 ? 24.0 : 18.0;
              final verticalPadding = 18.0;
              return Padding(
                padding: EdgeInsets.fromLTRB(horizontalPadding, verticalPadding, horizontalPadding, 16),
                child: isMedia
                    ? _MediaManagementBody(onBackToDashboard: onBackToDashboard)
                    : isVerificationRequests
                    ? _VerificationRequestsBody(onBackToDashboard: onBackToDashboard)
                    : isCharityApprovals
                    ? const _CharityApprovalsBody()
                    : isAbuseReports
                    ? const _AbuseReportsBody()
                    : isSystemSettings
                    ? const _SystemSettingsBody()
                    : isUserManagement
                    ? isUserDetails
                          ? _UserDetailsBody(user: selectedUser)
                          : _UserManagementBody(
                              onOpenUserDetails: onOpenUserDetails,
                            )
                    : _DashboardBody(onOpenMediaScreen: onOpenMediaScreen),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MainAreaTablet extends StatelessWidget {
  const _MainAreaTablet({
    required this.currentView,
    required this.selectedUserId,
    required this.onOpenMediaScreen,
    required this.onOpenUserManagement,
    required this.onOpenUserDetails,
    required this.onBackToUsers,
    required this.onBackToDashboard,
    required this.onOpenVerificationRequests,
    required this.onOpenCharityApprovals,
    required this.onOpenAbuseReports,
    required this.onOpenSystemSettings,
  });

  final DashboardView currentView;
  final String? selectedUserId;
  final VoidCallback onOpenMediaScreen;
  final VoidCallback onOpenUserManagement;
  final ValueChanged<String> onOpenUserDetails;
  final VoidCallback onBackToUsers;
  final VoidCallback onBackToDashboard;
  final VoidCallback onOpenVerificationRequests;
  final VoidCallback onOpenCharityApprovals;
  final VoidCallback onOpenAbuseReports;
  final VoidCallback onOpenSystemSettings;

  @override
  Widget build(BuildContext context) {
    final dashboardCubit = context.read<DashboardCubit>();
    final selectedUser = context.select(
      (DashboardCubit cubit) => cubit.state.selectedUser,
    );
    final hasUnsavedChanges = context.select(
      (DashboardCubit cubit) => cubit.state.hasUnsavedUserChanges,
    );
    final isMedia = currentView == DashboardView.media;
    final isUserManagement = currentView == DashboardView.userManagement;
    final isVerificationRequests = currentView == DashboardView.verificationRequests;
    final isCharityApprovals = currentView == DashboardView.charityApprovals;
    final isAbuseReports = currentView == DashboardView.abuseReports;
    final isSystemSettings = currentView == DashboardView.systemSettings;
    final isUserDetails = isUserManagement && selectedUserId != null;
    return Column(
      children: [
        isUserDetails
            ? _UserDetailsTopBar(
                onBackToUsers: onBackToUsers,
                compact: true,
                onBanAccount: dashboardCubit.banSelectedUser,
                onResetPassword: dashboardCubit.resetSelectedPassword,
                onSaveChanges: dashboardCubit.saveSelectedUserChanges,
                canSave: hasUnsavedChanges,
              )
            : _TopBar(
                compact: true,
                searchHint: isMedia
                    ? 'Search for files, titles, or metadata...'
                    : isUserManagement
                    ? 'Search by name, email or ID...'
                    : isVerificationRequests
                    ? 'Search applications...'
                    : isCharityApprovals
                    ? 'Search requests...'
                    : isAbuseReports
                    ? 'Search abuse cases...'
                    : isSystemSettings
                    ? 'Search settings...'
                    : 'Search for users, scholars, or donations...',
                primaryButtonLabel: isMedia
                    ? 'Upload Media'
                    : isUserManagement
                    ? 'Add User'
                    : isVerificationRequests
                    ? 'Verification Logs'
                    : isCharityApprovals
                    ? 'Export Report'
                    : isAbuseReports
                    ? 'Assign'
                    : isSystemSettings
                    ? 'Save'
                    : 'New Content',
                primaryButtonIcon: isMedia
                    ? Icons.cloud_upload
                    : isUserManagement
                    ? Icons.person_add_alt_1
                    : isVerificationRequests
                    ? Icons.history
                    : isCharityApprovals
                    ? Icons.download
                    : isAbuseReports
                    ? Icons.gavel
                    : isSystemSettings
                    ? Icons.save
                    : Icons.add,
                onSearchChanged: dashboardCubit.setSearchQuery,
                onPrimaryAction: !isMedia &&
                        !isUserManagement &&
                        !isVerificationRequests &&
                        !isCharityApprovals &&
                        !isAbuseReports &&
                        !isSystemSettings
                    ? dashboardCubit.createNewContent
                    : null,
              ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final horizontalPadding = width > 1000 ? 20.0 : width > 800 ? 16.0 : 14.0;
              final verticalPadding = 14.0;
              return isMedia
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(horizontalPadding, verticalPadding, horizontalPadding, 14),
                      child: _MediaManagementBody(
                        compact: true,
                        onBackToDashboard: onBackToDashboard,
                      ),
                    )
                  : isVerificationRequests
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(horizontalPadding, verticalPadding, horizontalPadding, 14),
                      child: _VerificationRequestsBody(
                        onBackToDashboard: onBackToDashboard,
                        compact: true,
                      ),
                    )
                  : isCharityApprovals
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(horizontalPadding, verticalPadding, horizontalPadding, 14),
                      child: const _CharityApprovalsBody(compact: true),
                    )
                  : isAbuseReports
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(horizontalPadding, verticalPadding, horizontalPadding, 14),
                      child: const _AbuseReportsBody(compact: true),
                    )
                  : isSystemSettings
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(horizontalPadding, verticalPadding, horizontalPadding, 14),
                      child: const _SystemSettingsBody(compact: true),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(horizontalPadding, verticalPadding, horizontalPadding, 14),
                      child: isUserManagement
                          ? isUserDetails
                                ? _UserDetailsBodyCompact(user: selectedUser)
                                : _UserManagementBodyCompact(
                                    onOpenUserDetails: onOpenUserDetails,
                                  )
                          : _ResponsiveBody(
                              crossAxisCount: 2,
                              onOpenMediaScreen: onOpenMediaScreen,
                            ),
                    );
            },
          ),
        ),
      ],
    );
  }
}

class _MainAreaMobile extends StatelessWidget {
  const _MainAreaMobile({
    required this.currentView,
    required this.selectedUserId,
    required this.onOpenMediaScreen,
    required this.onOpenUserManagement,
    required this.onOpenUserDetails,
    required this.onBackToUsers,
    required this.onBackToDashboard,
    required this.onOpenVerificationRequests,
    required this.onOpenCharityApprovals,
    required this.onOpenAbuseReports,
    required this.onOpenSystemSettings,
  });

  final DashboardView currentView;
  final String? selectedUserId;
  final VoidCallback onOpenMediaScreen;
  final VoidCallback onOpenUserManagement;
  final ValueChanged<String> onOpenUserDetails;
  final VoidCallback onBackToUsers;
  final VoidCallback onBackToDashboard;
  final VoidCallback onOpenVerificationRequests;
  final VoidCallback onOpenCharityApprovals;
  final VoidCallback onOpenAbuseReports;
  final VoidCallback onOpenSystemSettings;

  @override
  Widget build(BuildContext context) {
    final dashboardCubit = context.read<DashboardCubit>();
    final selectedUser = context.select(
      (DashboardCubit cubit) => cubit.state.selectedUser,
    );
    final hasUnsavedChanges = context.select(
      (DashboardCubit cubit) => cubit.state.hasUnsavedUserChanges,
    );
    final isMedia = currentView == DashboardView.media;
    final isUserManagement = currentView == DashboardView.userManagement;
    final isVerificationRequests = currentView == DashboardView.verificationRequests;
    final isCharityApprovals = currentView == DashboardView.charityApprovals;
    final isAbuseReports = currentView == DashboardView.abuseReports;
    final isSystemSettings = currentView == DashboardView.systemSettings;
    final isUserDetails = isUserManagement && selectedUserId != null;
    return Column(
      children: [
        isUserDetails
            ? _UserDetailsTopBar(
                onBackToUsers: onBackToUsers,
                mobile: true,
                onBanAccount: dashboardCubit.banSelectedUser,
                onResetPassword: dashboardCubit.resetSelectedPassword,
                onSaveChanges: dashboardCubit.saveSelectedUserChanges,
                canSave: hasUnsavedChanges,
              )
            : _TopBar(
                mobile: true,
                searchHint: isMedia
                    ? 'Search files...'
                    : isUserManagement
                    ? 'Search users...'
                    : isVerificationRequests
                    ? 'Search apps...'
                    : isCharityApprovals
                    ? 'Search requests...'
                    : isAbuseReports
                    ? 'Search cases...'
                    : isSystemSettings
                    ? 'Search settings...'
                    : 'Search users...',
                primaryButtonLabel: isMedia
                    ? 'Upload'
                    : isUserManagement
                    ? 'Add'
                    : isVerificationRequests
                    ? 'Logs'
                    : isCharityApprovals
                    ? 'Export'
                    : isAbuseReports
                    ? 'Assign'
                    : isSystemSettings
                    ? 'Save'
                    : 'New',
                primaryButtonIcon: isMedia
                    ? Icons.cloud_upload
                    : isUserManagement
                    ? Icons.person_add_alt_1
                    : isVerificationRequests
                    ? Icons.history
                    : isCharityApprovals
                    ? Icons.download
                    : isAbuseReports
                    ? Icons.gavel
                    : isSystemSettings
                    ? Icons.save
                    : Icons.add,
                onSearchChanged: dashboardCubit.setSearchQuery,
                onPrimaryAction: !isMedia &&
                        !isUserManagement &&
                        !isVerificationRequests &&
                        !isCharityApprovals &&
                        !isAbuseReports &&
                        !isSystemSettings
                    ? dashboardCubit.createNewContent
                    : null,
              ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final horizontalPadding = width > 600 ? 16.0 : width > 400 ? 12.0 : 8.0;
              final verticalPadding = 12.0;
              return isMedia
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(horizontalPadding, verticalPadding, horizontalPadding, 12),
                      child: _MediaManagementBody(
                        compact: true,
                        onBackToDashboard: onBackToDashboard,
                      ),
                    )
                  : isVerificationRequests
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(horizontalPadding, verticalPadding, horizontalPadding, 12),
                      child: _VerificationRequestsBody(
                        onBackToDashboard: onBackToDashboard,
                        compact: true,
                        mobile: true,
                      ),
                    )
                  : isCharityApprovals
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(horizontalPadding, verticalPadding, horizontalPadding, 12),
                      child: const _CharityApprovalsBody(compact: true, mobile: true),
                    )
                  : isAbuseReports
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(horizontalPadding, verticalPadding, horizontalPadding, 12),
                      child: const _AbuseReportsBody(compact: true, mobile: true),
                    )
                  : isSystemSettings
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(horizontalPadding, verticalPadding, horizontalPadding, 12),
                      child: const _SystemSettingsBody(compact: true, mobile: true),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(horizontalPadding, verticalPadding, horizontalPadding, 12),
                      child: isUserManagement
                          ? isUserDetails
                                ? _UserDetailsBodyCompact(
                                    mobile: true,
                                    user: selectedUser,
                                  )
                                : _UserManagementBodyCompact(
                                    mobile: true,
                                    onOpenUserDetails: onOpenUserDetails,
                                  )
                          : _ResponsiveBody(
                              crossAxisCount: 1,
                              mobile: true,
                              onOpenMediaScreen: onOpenMediaScreen,
                            ),
                    );
            },
          ),
        ),
      ],
    );
  }
}

class _ResponsiveBody extends StatelessWidget {
  const _ResponsiveBody({
    required this.crossAxisCount,
    required this.onOpenMediaScreen,
    this.mobile = false,
  });

  final int crossAxisCount;
  final VoidCallback onOpenMediaScreen;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final state = context.select((DashboardCubit cubit) => cubit.state);
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Admin Overview',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: mobile ? 24 : 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Monitor the ASK Islam ecosystem performance and alerts.',
                    style: TextStyle(color: AppColors.muted, fontSize: 12),
                  ),
                ],
              ),
            ),
            if (!mobile) const _RangeToggle(),
          ],
        ),
        if (mobile) ...[
          const SizedBox(height: 10),
          const Align(alignment: Alignment.centerLeft, child: _RangeToggle()),
        ],
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: crossAxisCount == 1 ? 2.6 : 2.0,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _StatCard(
              icon: Icons.groups_2,
              title: 'TOTAL USERS',
              value: state.overviewTotalUsers,
              rightTag: state.overviewUserGrowthTag,
              iconBoxColor: Color(0xFF113B5A),
            ),
            _StatCard(
              icon: Icons.verified_rounded,
              title: 'VERIFIED SCHOLARS',
              value: state.overviewVerifiedScholars,
              rightTag: state.overviewScholarGrowthTag,
              iconBoxColor: Color(0xFF4A5A1E),
            ),
            _StatCard(
              icon: Icons.volunteer_activism,
              title: 'PENDING CHARITY',
              value: state.overviewPendingCharity,
              rightTag: 'Reviewing',
              iconBoxColor: Color(0xFF114B38),
            ),
            _StatCard(
              icon: Icons.shield,
              title: 'ACTIVE REPORTS',
              value: state.overviewActiveReports,
              rightTag: 'Critical',
              iconBoxColor: Color(0xFF4E2A2B),
              critical: true,
            ),
          ],
        ),
        const SizedBox(height: 12),
        const _PendingQueuePanelCompact(),
        const SizedBox(height: 12),
        _RightPanelsCompact(onOpenMediaScreen: onOpenMediaScreen),
      ],
    );
  }
}

class _UserManagementBody extends StatelessWidget {
  const _UserManagementBody({required this.onOpenUserDetails});

  final ValueChanged<String> onOpenUserDetails;

  @override
  Widget build(BuildContext context) {
    final users = context.select(
      (DashboardCubit cubit) => cubit.state.filteredUsers,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              const _UserTypeTabs(),
              const SizedBox(height: 14),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF12392A),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.stroke),
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(18, 16, 18, 14),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                'USER PROFILE',
                                style: tableHeadStyle,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text('ROLE', style: tableHeadStyle),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text('STATUS', style: tableHeadStyle),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'LAST ACTIVITY',
                                style: tableHeadStyle,
                              ),
                            ),
                            SizedBox(
                              width: 30,
                              child: Text('ACTIONS', style: tableHeadStyle),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: AppColors.stroke),
                      for (final user in users)
                        _UserTableRow(
                          user: user,
                          onTap: () => onOpenUserDetails(user.id),
                        ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.fromLTRB(18, 10, 18, 12),
                        child: Row(
                          children: [
                            Text(
                              'Showing 1 to ${users.length} of ${context.read<DashboardCubit>().state.users.length} users',
                              style: TextStyle(
                                color: AppColors.muted,
                                fontSize: 12,
                              ),
                            ),
                            Spacer(),
                            _PaginationChip(text: '1', active: true),
                            SizedBox(width: 6),
                            _PaginationChip(text: '2'),
                            SizedBox(width: 6),
                            _PaginationChip(text: '3'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(flex: 3, child: _UserInsightsRail()),
      ],
    );
  }
}

class _UserManagementBodyCompact extends StatelessWidget {
  const _UserManagementBodyCompact({
    this.mobile = false,
    required this.onOpenUserDetails,
  });

  final bool mobile;
  final ValueChanged<String> onOpenUserDetails;

  @override
  Widget build(BuildContext context) {
    final users = context.select(
      (DashboardCubit cubit) => cubit.state.filteredUsers,
    );
    return Column(
      children: [
        const _UserTypeTabs(compact: true),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF12392A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.stroke),
          ),
          child: Column(
            children: users
                .map(
                  (user) => _UserListCard(
                    userId: user.id,
                    name: user.name,
                    email: user.email,
                    role: user.role,
                    status: user.status,
                    onTap: onOpenUserDetails,
                  ),
                )
                .toList(growable: false),
          ),
        ),
        const SizedBox(height: 12),
        _UserInsightsRail(compact: true, mobile: mobile),
      ],
    );
  }
}

class _UserTypeTabs extends StatelessWidget {
  const _UserTypeTabs({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final activeFilter = context.select(
      (DashboardCubit cubit) => cubit.state.userFilter,
    );
    final cubit = context.read<DashboardCubit>();
    final textStyle = TextStyle(
      color: AppColors.item,
      fontSize: compact ? 12 : 14,
      fontWeight: FontWeight.w600,
    );
    return Container(
      padding: EdgeInsets.all(compact ? 4 : 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0E3529),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          _FilterTab(
            label: 'All Users',
            active: activeFilter == UserFilter.all,
            compact: compact,
            onTap: () => cubit.setUserFilter(UserFilter.all),
          ),
          _RoleTab(
            icon: Icons.school_outlined,
            label: 'Scholars',
            style: textStyle,
            active: activeFilter == UserFilter.scholar,
            onTap: () => cubit.setUserFilter(UserFilter.scholar),
          ),
          _RoleTab(
            icon: Icons.menu_book_rounded,
            label: 'Teachers',
            style: textStyle,
            active: activeFilter == UserFilter.teacher,
            onTap: () => cubit.setUserFilter(UserFilter.teacher),
          ),
          _RoleTab(
            icon: Icons.groups_2_outlined,
            label: 'Students',
            style: textStyle,
            active: activeFilter == UserFilter.student,
            onTap: () => cubit.setUserFilter(UserFilter.student),
          ),
          _RoleTab(
            icon: Icons.verified_rounded,
            label: 'Verified',
            style: textStyle,
            active: activeFilter == UserFilter.verified,
            onTap: () => cubit.setUserFilter(UserFilter.verified),
          ),
        ],
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  const _FilterTab({
    required this.label,
    required this.active,
    required this.compact,
    required this.onTap,
  });

  final String label;
  final bool active;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 12 : 16,
          vertical: compact ? 8 : 10,
        ),
        decoration: BoxDecoration(
          color: active ? AppColors.green : const Color(0xFF133D2D),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? const Color(0xFF062E1F) : AppColors.item,
            fontSize: compact ? 12 : 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _RoleTab extends StatelessWidget {
  const _RoleTab({
    required this.icon,
    required this.label,
    required this.style,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final TextStyle style;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF1D4A36) : const Color(0xFF133D2D),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: active ? AppColors.green : AppColors.iconMuted,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: style.copyWith(
                color: active ? AppColors.white : style.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserTableRow extends StatelessWidget {
  const _UserTableRow({required this.user, required this.onTap});

  final ManagedUser user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0x1FFFFFFF))),
        ),
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFFD6D8D2),
                    child: Icon(
                      Icons.person,
                      size: 16,
                      color: Color(0xFF6B6E65),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user.email,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(flex: 2, child: _RoleBadge(role: user.role)),
            Expanded(flex: 2, child: _StatusBadge(status: user.status)),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.lastActivity,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.detail.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 11,
                      letterSpacing: .3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 30,
              child: Icon(
                Icons.more_vert,
                color: AppColors.iconMuted,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.role});

  final String role;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    switch (role.toLowerCase()) {
      case 'scholar':
        bg = const Color(0xFF4C4620);
        fg = const Color(0xFFE2C64A);
        break;
      case 'teacher':
        bg = const Color(0xFF1A5138);
        fg = const Color(0xFF1FF08D);
        break;
      default:
        bg = const Color(0xFF28473F);
        fg = const Color(0xFFAEC4BA);
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bg.withValues(alpha: .5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          role.toUpperCase(),
          style: TextStyle(
            color: fg,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color dot;
    switch (status.toLowerCase()) {
      case 'pending':
        dot = const Color(0xFFE2C64A);
        break;
      case 'banned':
        dot = const Color(0xFFFF5A5A);
        break;
      default:
        dot = AppColors.green;
    }
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: dot,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          status,
          style: const TextStyle(color: AppColors.white, fontSize: 15),
        ),
      ],
    );
  }
}

class _UserListCard extends StatelessWidget {
  const _UserListCard({
    required this.userId,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.onTap,
  });

  final String userId;
  final String name;
  final String email;
  final String role;
  final String status;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(userId),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0x1FFFFFFF))),
        ),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFD6D8D2),
              child: Icon(Icons.person, size: 14, color: Color(0xFF6B6E65)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    email,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            _RoleBadge(role: role),
            const SizedBox(width: 10),
            _StatusBadge(status: status),
          ],
        ),
      ),
    );
  }
}

class _UserInsightsRail extends StatelessWidget {
  const _UserInsightsRail({this.compact = false, this.mobile = false});

  final bool compact;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(compact ? 14 : 16),
          decoration: BoxDecoration(
            color: const Color(0xFF12392A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.stroke),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'User Demographics',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F3427),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.stroke),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VERIFIED SCHOLARS',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '482',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          '/ 1.2k',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '40%',
                          style: TextStyle(
                            color: Color(0xFFE2C64A),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const LinearProgressIndicator(
                  value: .4,
                  minHeight: 8,
                  backgroundColor: Color(0xFF315045),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE2C64A)),
                ),
              ),
              const SizedBox(height: 12),
              const Row(
                children: [
                  Expanded(
                    child: _MiniMetricCard(label: 'ACTIVE TODAY', value: '856'),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _MiniMetricCard(label: 'NEW SIGNUPS', value: '12'),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: compact ? 10 : 14),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(compact ? 14 : 16),
          decoration: BoxDecoration(
            color: const Color(0xFF12392A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.stroke),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Verification Queue',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F3427),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.stroke),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFF2D4E67),
                      child: Icon(
                        Icons.person,
                        size: 16,
                        color: Color(0xFFB7D0E0),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sheikh Mansour',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Applied 2h ago',
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Review',
                      style: TextStyle(
                        color: AppColors.green,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.muted,
                    side: const BorderSide(color: AppColors.stroke),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: mobile ? 10 : 12),
                  ),
                  onPressed: context.read<DashboardCubit>().openVerificationRequests,
                  child: const Text('View Verification Requests'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniMetricCard extends StatelessWidget {
  const _MiniMetricCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF0F3427),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaginationChip extends StatelessWidget {
  const _PaginationChip({required this.text, this.active = false});

  final String text;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: active ? AppColors.green : const Color(0xFF0F3427),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: active ? AppColors.green : AppColors.stroke),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: active ? const Color(0xFF062E1F) : AppColors.item,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _UserDetailsTopBar extends StatelessWidget {
  const _UserDetailsTopBar({
    required this.onBackToUsers,
    required this.onBanAccount,
    required this.onResetPassword,
    required this.onSaveChanges,
    required this.canSave,
    this.compact = false,
    this.mobile = false,
  });

  final VoidCallback onBackToUsers;
  final VoidCallback onBanAccount;
  final VoidCallback onResetPassword;
  final VoidCallback onSaveChanges;
  final bool canSave;
  final bool compact;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mobile ? 64 : 70,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.stroke)),
      ),
      padding: EdgeInsets.symmetric(horizontal: mobile ? 12 : 24),
      child: Row(
        children: [
          if (mobile)
            Builder(
              builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(Icons.menu, color: AppColors.white),
              ),
            ),
          TextButton.icon(
            onPressed: onBackToUsers,
            icon: const Icon(
              Icons.arrow_back,
              size: 18,
              color: AppColors.muted,
            ),
            label: const Text(
              'Back to Users',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Spacer(),
          if (!mobile) ...[
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFFF5C5C),
                side: const BorderSide(color: Color(0xFF5A1F1D)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: compact ? 12 : 18,
                  vertical: 14,
                ),
              ),
              onPressed: onBanAccount,
              child: const Text('Ban Account'),
            ),
            const SizedBox(width: 10),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.white,
                side: const BorderSide(color: AppColors.stroke),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: compact ? 12 : 18,
                  vertical: 14,
                ),
              ),
              onPressed: onResetPassword,
              child: const Text('Reset Password'),
            ),
            const SizedBox(width: 10),
          ],
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.green,
              foregroundColor: const Color(0xFF032519),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: mobile ? 12 : 18,
                vertical: 14,
              ),
            ),
            onPressed: canSave ? onSaveChanges : null,
            child: Text(mobile ? 'Save' : 'Save Changes'),
          ),
        ],
      ),
    );
  }
}

class _UserDetailsBody extends StatelessWidget {
  const _UserDetailsBody({required this.user});

  final ManagedUser? user;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Center(
        child: Text('User not found', style: TextStyle(color: AppColors.muted)),
      );
    }
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 7,
            child: Column(
              children: [
                _UserProfileHero(user: user!),
                const SizedBox(height: 14),
                _UserOverviewCard(user: user!),
                const SizedBox(height: 14),
                _UserMetricsCard(user: user!),
                const SizedBox(height: 14),
                _UserTimelineCard(user: user!),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(flex: 3, child: _UserSecurityRail(user: user!)),
        ],
      ),
    );
  }
}

class _UserDetailsBodyCompact extends StatelessWidget {
  const _UserDetailsBodyCompact({required this.user, this.mobile = false});

  final bool mobile;
  final ManagedUser? user;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Center(
        child: Text('User not found', style: TextStyle(color: AppColors.muted)),
      );
    }
    return Column(
      children: [
        _UserProfileHero(user: user!, compact: true),
        const SizedBox(height: 12),
        _UserOverviewCard(user: user!, compact: true),
        const SizedBox(height: 12),
        _UserMetricsCard(user: user!, compact: true),
        const SizedBox(height: 12),
        _UserSecurityRail(user: user!, compact: true),
        const SizedBox(height: 12),
        _UserTimelineCard(user: user!, compact: true),
      ],
    );
  }
}

class _UserProfileHero extends StatelessWidget {
  const _UserProfileHero({required this.user, this.compact = false});

  final ManagedUser user;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 14 : 22),
      decoration: BoxDecoration(
        color: const Color(0xFF12392A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: compact ? 64 : 86,
                height: compact ? 64 : 86,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.green.withValues(alpha: .35),
                    width: 6,
                  ),
                  color: const Color(0xFFE5E7E0),
                ),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFFA9ACA2),
                  size: 34,
                ),
              ),
              Positioned(
                right: -4,
                bottom: -2,
                child: Container(
                  width: compact ? 28 : 36,
                  height: compact ? 28 : 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD2B53C),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF12392A),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.edit,
                    size: compact ? 14 : 16,
                    color: const Color(0xFF3A3210),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: compact ? 24 : 42,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _RoleBadge(role: user.role),
                    _StatusBadge(
                      status: user.status == 'Active'
                          ? 'Active Now'
                          : user.status,
                    ),
                    const Text('|', style: TextStyle(color: AppColors.muted)),
                    Text(
                      user.location,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UserOverviewCard extends StatelessWidget {
  const _UserOverviewCard({required this.user, this.compact = false});

  final ManagedUser user;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return _DetailCard(
      title: 'Account Overview',
      icon: Icons.badge_outlined,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _InfoField(
                  label: 'EMAIL ADDRESS',
                  value: user.email,
                  trailing: user.verified
                      ? const Icon(
                          Icons.verified,
                          color: AppColors.green,
                          size: 18,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _InfoField(label: 'JOIN DATE', value: user.joinDate),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _InfoField(label: 'PHONE NUMBER', value: user.phone),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _InfoField(label: 'ACCOUNT ID', value: user.accountId),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UserMetricsCard extends StatelessWidget {
  const _UserMetricsCard({required this.user, this.compact = false});

  final ManagedUser user;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return _DetailCard(
      title: 'Activity Metrics',
      icon: Icons.auto_graph_rounded,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF0F3427),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '30-DAY ACTIVITY',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(
                      user.activity30Days.length,
                      (i) => Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Container(
                          width: 6,
                          height: user.activity30Days[i].toDouble() + 8,
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _MetricTile(
              title: 'CURRENT STREAK',
              main: user.currentStreakDays.toString(),
              suffix: 'Days',
              sub: 'Personal Best: ${user.personalBestDays}',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _MetricTile(
              title: 'LESSONS COMPLETED',
              main: user.coursesCompleted.toString(),
              suffix: 'Courses',
              progress: (user.coursesCompleted / 200).clamp(0.0, 1.0),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserTimelineCard extends StatelessWidget {
  const _UserTimelineCard({required this.user, this.compact = false});

  final ManagedUser user;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return _DetailCard(
      title: 'Activity Timeline',
      icon: Icons.history_toggle_off_rounded,
      child: Column(
        children: [
          _TimelineItem(
            color: AppColors.green,
            title: user.detail,
            subtitle: '${user.lastActivity} • Platform: Web Dashboard',
          ),
          const SizedBox(height: 12),
          _TimelineItem(
            color: const Color(0xFFE2C64A),
            title: 'Completed Quiz: Basic Fiqh of Prayer',
            subtitle: '3 hours ago • Score: 95%',
          ),
          const SizedBox(height: 12),
          const _TimelineItem(
            color: Color(0xFF5D7B70),
            title: 'Password Changed Successfully',
            subtitle: 'Yesterday, 4:30 PM • IP: 192.168.1.45',
          ),
        ],
      ),
    );
  }
}

class _UserSecurityRail extends StatelessWidget {
  const _UserSecurityRail({required this.user, this.compact = false});

  final ManagedUser user;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DashboardCubit>();
    return Column(
      children: [
        _DetailCard(
          title: 'Security & Permissions',
          icon: Icons.shield_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'USER ROLE',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              _SelectStub(
                label: user.role,
                onChanged: cubit.updateSelectedRole,
              ),
              const SizedBox(height: 14),
              _SwitchRow(
                label: 'Multi-Factor Auth',
                sub: 'Enhanced account security',
                enabled: user.mfaEnabled,
                onChanged: cubit.toggleSelectedMfa,
              ),
              const SizedBox(height: 10),
              const Divider(height: 1, color: AppColors.stroke),
              const SizedBox(height: 10),
              _SwitchRow(
                label: 'Community Moderator',
                sub: 'Allow forum moderation',
                enabled: user.moderatorEnabled,
                onChanged: cubit.toggleSelectedModerator,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const _DetailCard(
          title: 'Active Sessions',
          icon: Icons.devices_outlined,
          child: Column(
            children: [
              _SessionRow(
                title: 'MacBook Pro - Chrome',
                sub: 'Current Session • UAE',
              ),
              SizedBox(height: 8),
              _SessionRow(
                title: 'iPhone 15 - Mobile App',
                sub: 'Last active: 2h ago',
                action: 'Revoke',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
              Icon(icon, size: 18, color: AppColors.green),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  const _InfoField({required this.label, required this.value, this.trailing});
  final String label;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            trailing ?? const SizedBox.shrink(),
          ],
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.title,
    required this.main,
    required this.suffix,
    this.sub,
    this.progress,
  });
  final String title;
  final String main;
  final String suffix;
  final String? sub;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F3427),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                main,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                suffix,
                style: const TextStyle(color: AppColors.muted, fontSize: 16),
              ),
            ],
          ),
          if (sub != null) ...[
            const SizedBox(height: 6),
            Text(
              sub!,
              style: const TextStyle(
                color: AppColors.green,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (progress != null) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: const Color(0xFF315045),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.green,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.color,
    required this.title,
    required this.subtitle,
  });
  final Color color;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            Container(width: 2, height: 28, color: const Color(0xFF1F4A3A)),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: AppColors.muted, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SelectStub extends StatelessWidget {
  const _SelectStub({required this.label, required this.onChanged});
  final String label;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F3427),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.stroke),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: label,
          isExpanded: true,
          dropdownColor: const Color(0xFF0F3427),
          style: const TextStyle(color: AppColors.white, fontSize: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.iconMuted,
          ),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
          items: const ['Scholar', 'Teacher', 'Student']
              .map(
                (role) =>
                    DropdownMenuItem<String>(value: role, child: Text(role)),
              )
              .toList(growable: false),
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.label,
    required this.sub,
    required this.enabled,
    required this.onChanged,
  });
  final String label;
  final String sub;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                sub,
                style: const TextStyle(color: AppColors.muted, fontSize: 14),
              ),
            ],
          ),
        ),
        Switch(
          value: enabled,
          onChanged: onChanged,
          activeThumbColor: AppColors.green,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: const Color(0xFF2B4A40),
        ),
      ],
    );
  }
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({required this.title, required this.sub, this.action});
  final String title;
  final String sub;
  final String? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF0F3427),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.devices,
            size: 16,
            color: AppColors.iconMuted,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                sub,
                style: const TextStyle(color: AppColors.muted, fontSize: 13),
              ),
            ],
          ),
        ),
        if (action != null)
          Text(
            action!,
            style: const TextStyle(
              color: Color(0xFFFF5C5C),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    this.compact = false,
    this.mobile = false,
    required this.searchHint,
    required this.primaryButtonLabel,
    required this.primaryButtonIcon,
    required this.onSearchChanged,
    this.onPrimaryAction,
  });

  final bool compact;
  final bool mobile;
  final String searchHint;
  final String primaryButtonLabel;
  final IconData primaryButtonIcon;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback? onPrimaryAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mobile ? 64 : 70,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.stroke)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          if (mobile)
            Builder(
              builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(Icons.menu, color: AppColors.white),
              ),
            ),
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: compact || mobile ? 360 : 420,
              ),
              child: TextField(
                style: const TextStyle(color: AppColors.white, fontSize: 16),
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  hintText: searchHint,
                  hintStyle: const TextStyle(
                    color: AppColors.searchHint,
                    fontSize: 16,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.searchHint,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF0D372A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const _PulsingDotIcon(),
          if (!mobile)
            Container(
              width: 1,
              height: 28,
              color: AppColors.strokeBright,
              margin: const EdgeInsets.symmetric(horizontal: 14),
            ),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.green,
              foregroundColor: const Color(0xFF032519),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: mobile ? 12 : 18,
                vertical: 14,
              ),
              textStyle: TextStyle(
                fontSize: mobile ? 13 : 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: onPrimaryAction,
            icon: Icon(primaryButtonIcon, size: mobile ? 14 : 18),
            label: Text(primaryButtonLabel),
          ),
        ],
      ),
    );
  }
}

class _PulsingDotIcon extends StatefulWidget {
  const _PulsingDotIcon();

  @override
  State<_PulsingDotIcon> createState() => _PulsingDotIconState();
}

class _PulsingDotIconState extends State<_PulsingDotIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(
          Icons.notifications_none_rounded,
          color: AppColors.iconMuted,
          size: 24,
        ),
        Positioned(
          right: -1,
          top: 0,
          child: FadeTransition(
            opacity: Tween<double>(begin: .4, end: 1).animate(_controller),
            child: ScaleTransition(
              scale: Tween<double>(begin: .85, end: 1.1).animate(_controller),
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.onOpenMediaScreen});

  final VoidCallback onOpenMediaScreen;

  @override
  Widget build(BuildContext context) {
    final state = context.select((DashboardCubit cubit) => cubit.state);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Admin Overview',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Monitor the ASK Islam ecosystem performance and alerts.',
                    style: TextStyle(color: AppColors.muted, fontSize: 14),
                  ),
                ],
              ),
            ),
            const _RangeToggle(),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.groups_2,
                title: 'TOTAL USERS',
                value: state.overviewTotalUsers,
                rightTag: state.overviewUserGrowthTag,
                iconBoxColor: Color(0xFF113B5A),
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: _StatCard(
                icon: Icons.verified_rounded,
                title: 'VERIFIED SCHOLARS',
                value: state.overviewVerifiedScholars,
                rightTag: state.overviewScholarGrowthTag,
                iconBoxColor: Color(0xFF4A5A1E),
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: _StatCard(
                icon: Icons.volunteer_activism,
                title: 'PENDING CHARITY',
                value: state.overviewPendingCharity,
                rightTag: 'Reviewing',
                iconBoxColor: Color(0xFF114B38),
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: _StatCard(
                icon: Icons.shield,
                title: 'ACTIVE REPORTS',
                value: state.overviewActiveReports,
                rightTag: 'Critical',
                iconBoxColor: Color(0xFF4E2A2B),
                critical: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(flex: 8, child: _PendingQueuePanel()),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: _RightPanels(onOpenMediaScreen: onOpenMediaScreen),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RangeToggle extends StatelessWidget {
  const _RangeToggle();

  @override
  Widget build(BuildContext context) {
    final active = context.select((DashboardCubit cubit) => cubit.state.overviewRange);
    final cubit = context.read<DashboardCubit>();
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0E3529),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.stroke),
      ),
      padding: const EdgeInsets.all(6),
      child: Row(
        children: [
          _RangeTab(
            'Last 24h',
            active: active == OverviewRange.last24h,
            onTap: () => cubit.setOverviewRange(OverviewRange.last24h),
          ),
          _RangeTab(
            'Weekly',
            active: active == OverviewRange.weekly,
            onTap: () => cubit.setOverviewRange(OverviewRange.weekly),
          ),
          _RangeTab(
            'Monthly',
            active: active == OverviewRange.monthly,
            onTap: () => cubit.setOverviewRange(OverviewRange.monthly),
          ),
        ],
      ),
    );
  }
}

class _RangeTab extends StatelessWidget {
  const _RangeTab(this.text, {this.active = false, this.onTap});
  final String text;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.green : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: active ? const Color(0xFF062E1F) : const Color(0xFF6F8C81),
            fontSize: 14,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.rightTag,
    required this.iconBoxColor,
    this.critical = false,
  });

  final IconData icon;
  final String title;
  final int value;
  final String rightTag;
  final Color iconBoxColor;
  final bool critical;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 150;
        return Container(
          padding: EdgeInsets.fromLTRB(
            18,
            compact ? 12 : 16,
            18,
            compact ? 10 : 14,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF12392A),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.stroke),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: compact ? 34 : 40,
                    height: compact ? 34 : 40,
                    decoration: BoxDecoration(
                      color: iconBoxColor,
                      borderRadius: BorderRadius.circular(compact ? 8 : 10),
                    ),
                    child: Icon(
                      icon,
                      color: AppColors.green,
                      size: compact ? 18 : 20,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    rightTag,
                    style: TextStyle(
                      color: critical
                          ? const Color(0xFFFF5A5A)
                          : AppColors.green,
                      fontSize: compact ? 14 : 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: compact ? 8 : 12),
              Text(
                title,
                style: TextStyle(
                  color: const Color(0xFF7F998E),
                  fontSize: compact ? 12 : 14,
                  letterSpacing: .5,
                ),
              ),
              SizedBox(height: compact ? 2 : 6),
              _AnimatedCounter(value: value, fontSize: compact ? 32 : 42),
            ],
          ),
        );
      },
    );
  }
}
