import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum DashboardView {
  overview,
  userManagement,
  media,
  weeklyGoals,
  verificationRequests,
  charityApprovals,
  abuseReports,
  systemSettings,
}

enum UserFilter { all, scholar, teacher, student, verified }

enum CharityStatusTone { warning, info, neutral, success, danger }
enum OverviewRange { last24h, weekly, monthly }

class OverviewQueueItem extends Equatable {
  const OverviewQueueItem({
    required this.id,
    required this.initials,
    required this.name,
    required this.subtitle,
    required this.type,
    required this.date,
    required this.typePurple,
  });

  final String id;
  final String initials;
  final String name;
  final String subtitle;
  final String type;
  final String date;
  final bool typePurple;

  @override
  List<Object?> get props => [id, initials, name, subtitle, type, date, typePurple];
}

class CharityRequest extends Equatable {
  const CharityRequest({
    required this.id,
    required this.name,
    required this.category,
    required this.solicitor,
    required this.amount,
    required this.progress,
    required this.submittedOn,
    required this.status,
    required this.statusTone,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });

  final String id;
  final String name;
  final String category;
  final String solicitor;
  final String amount;
  final double progress;
  final String submittedOn;
  final String status;
  final CharityStatusTone statusTone;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  CharityRequest copyWith({
    String? status,
    CharityStatusTone? statusTone,
  }) {
    return CharityRequest(
      id: id,
      name: name,
      category: category,
      solicitor: solicitor,
      amount: amount,
      progress: progress,
      submittedOn: submittedOn,
      status: status ?? this.status,
      statusTone: statusTone ?? this.statusTone,
      icon: icon,
      iconColor: iconColor,
      iconBg: iconBg,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        solicitor,
        amount,
        progress,
        submittedOn,
        status,
        statusTone,
        icon,
        iconColor,
        iconBg,
      ];
}

class ManagedUser extends Equatable {
  const ManagedUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.lastActivity,
    required this.detail,
    required this.location,
    required this.joinDate,
    required this.phone,
    required this.accountId,
    required this.mfaEnabled,
    required this.moderatorEnabled,
    required this.coursesCompleted,
    required this.currentStreakDays,
    required this.personalBestDays,
    required this.activity30Days,
    required this.verified,
  });

  final String id;
  final String name;
  final String email;
  final String role;
  final String status;
  final String lastActivity;
  final String detail;
  final String location;
  final String joinDate;
  final String phone;
  final String accountId;
  final bool mfaEnabled;
  final bool moderatorEnabled;
  final int coursesCompleted;
  final int currentStreakDays;
  final int personalBestDays;
  final List<int> activity30Days;
  final bool verified;

  ManagedUser copyWith({
    String? role,
    String? status,
    String? detail,
    bool? mfaEnabled,
    bool? moderatorEnabled,
  }) {
    return ManagedUser(
      id: id,
      name: name,
      email: email,
      role: role ?? this.role,
      status: status ?? this.status,
      lastActivity: lastActivity,
      detail: detail ?? this.detail,
      location: location,
      joinDate: joinDate,
      phone: phone,
      accountId: accountId,
      mfaEnabled: mfaEnabled ?? this.mfaEnabled,
      moderatorEnabled: moderatorEnabled ?? this.moderatorEnabled,
      coursesCompleted: coursesCompleted,
      currentStreakDays: currentStreakDays,
      personalBestDays: personalBestDays,
      activity30Days: activity30Days,
      verified: verified,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        role,
        status,
        lastActivity,
        detail,
        location,
        joinDate,
        phone,
        accountId,
        mfaEnabled,
        moderatorEnabled,
        coursesCompleted,
        currentStreakDays,
        personalBestDays,
        activity30Days,
        verified,
      ];
}

class VerificationApplication extends Equatable {
  const VerificationApplication({
    required this.id,
    required this.name,
    required this.title,
    required this.summary,
    required this.appliedAt,
    required this.fileName,
    required this.status,
    required this.gender,
    required this.code,
    this.viewed = false,
    this.idMatch = true,
    this.degreeAuthenticity = false,
    this.backgroundCheck = false,
    this.notes = '',
  });

  final String id;
  final String name;
  final String title;
  final String summary;
  final String appliedAt;
  final String fileName;
  final String status;
  final String gender;
  final String code;
  final bool viewed;
  final bool idMatch;
  final bool degreeAuthenticity;
  final bool backgroundCheck;
  final String notes;

  VerificationApplication copyWith({
    String? status,
    bool? viewed,
    bool? idMatch,
    bool? degreeAuthenticity,
    bool? backgroundCheck,
    String? notes,
  }) {
    return VerificationApplication(
      id: id,
      name: name,
      title: title,
      summary: summary,
      appliedAt: appliedAt,
      fileName: fileName,
      status: status ?? this.status,
      gender: gender,
      code: code,
      viewed: viewed ?? this.viewed,
      idMatch: idMatch ?? this.idMatch,
      degreeAuthenticity: degreeAuthenticity ?? this.degreeAuthenticity,
      backgroundCheck: backgroundCheck ?? this.backgroundCheck,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        title,
        summary,
        appliedAt,
        fileName,
        status,
        gender,
        code,
        viewed,
        idMatch,
        degreeAuthenticity,
        backgroundCheck,
        notes,
      ];
}

class DashboardState extends Equatable {
  const DashboardState({
    this.view = DashboardView.overview,
    this.selectedUserId,
    this.selectedVerificationId,
    this.selectedCharityRequestId,
    this.searchQuery = '',
    this.userFilter = UserFilter.all,
    this.overviewRange = OverviewRange.last24h,
    this.users = const [],
    this.verificationApplications = const [],
    this.charityRequests = const [],
    this.overviewQueue = const [],
    this.hasUnsavedUserChanges = false,
  });

  final DashboardView view;
  final String? selectedUserId;
  final String? selectedVerificationId;
  final String? selectedCharityRequestId;
  final String searchQuery;
  final UserFilter userFilter;
  final OverviewRange overviewRange;
  final List<ManagedUser> users;
  final List<VerificationApplication> verificationApplications;
  final List<CharityRequest> charityRequests;
  final List<OverviewQueueItem> overviewQueue;
  final bool hasUnsavedUserChanges;

  bool get showMediaScreen => view == DashboardView.media;
  bool get showUserManagementScreen => view == DashboardView.userManagement;
  bool get showCharityApprovalsScreen => view == DashboardView.charityApprovals;
  bool get showUserManagementDetail => showUserManagementScreen && selectedUserId != null;
  bool get showVerificationDocument => view == DashboardView.verificationRequests && selectedVerificationId != null;
  bool get showCharityRequestDetail => showCharityApprovalsScreen && selectedCharityRequestId != null;

  ManagedUser? get selectedUser {
    if (selectedUserId == null) return null;
    for (final user in users) {
      if (user.id == selectedUserId) return user;
    }
    return null;
  }

  VerificationApplication? get selectedVerification {
    if (selectedVerificationId == null) return null;
    for (final app in verificationApplications) {
      if (app.id == selectedVerificationId) return app;
    }
    return null;
  }

  CharityRequest? get selectedCharityRequest {
    if (selectedCharityRequestId == null) return null;
    for (final request in charityRequests) {
      if (request.id == selectedCharityRequestId) return request;
    }
    return null;
  }

  List<VerificationApplication> get filteredVerificationApplications {
    final query = searchQuery.trim().toLowerCase();
    return verificationApplications.where((app) {
      final isPending = app.status == 'pending' || app.status == 'more_info';
      if (!isPending) return false;
      if (query.isEmpty) return true;
      return app.name.toLowerCase().contains(query) ||
          app.title.toLowerCase().contains(query) ||
          app.summary.toLowerCase().contains(query) ||
          app.code.toLowerCase().contains(query);
    }).toList(growable: false);
  }

  int get verificationTotalCount => verificationApplications.length;
  int get verificationPendingCount => verificationApplications.where((app) => app.status == 'pending' || app.status == 'more_info').length;
  int get verificationApprovedCount => verificationApplications.where((app) => app.status == 'approved').length;
  List<CharityRequest> get pendingCharityRequests {
    return charityRequests
        .where((request) => request.status != 'APPROVED' && request.status != 'REJECTED')
        .toList(growable: false);
  }

  int get charityPendingCount => pendingCharityRequests.length;
  int get overviewQueueCount => overviewQueue.length;

  int get overviewTotalUsers {
    final base = 42581;
    return switch (overviewRange) {
      OverviewRange.last24h => base,
      OverviewRange.weekly => base - 219,
      OverviewRange.monthly => base - 900,
    };
  }

  int get overviewVerifiedScholars {
    final base = 128;
    return switch (overviewRange) {
      OverviewRange.last24h => base,
      OverviewRange.weekly => base - 3,
      OverviewRange.monthly => base - 9,
    };
  }

  int get overviewPendingCharity {
    final base = charityPendingCount;
    return switch (overviewRange) {
      OverviewRange.last24h => base,
      OverviewRange.weekly => base + 4,
      OverviewRange.monthly => base + 10,
    };
  }

  int get overviewActiveReports {
    const base = 5;
    return switch (overviewRange) {
      OverviewRange.last24h => base,
      OverviewRange.weekly => base + 2,
      OverviewRange.monthly => base + 4,
    };
  }

  String get overviewUserGrowthTag {
    return switch (overviewRange) {
      OverviewRange.last24h => '+12%',
      OverviewRange.weekly => '+8%',
      OverviewRange.monthly => '+19%',
    };
  }

  String get overviewScholarGrowthTag {
    return switch (overviewRange) {
      OverviewRange.last24h => '+5',
      OverviewRange.weekly => '+11',
      OverviewRange.monthly => '+17',
    };
  }

  List<ManagedUser> get filteredUsers {
    final query = searchQuery.trim().toLowerCase();
    return users.where((user) {
      final matchesRole = switch (userFilter) {
        UserFilter.all => true,
        UserFilter.scholar => user.role.toLowerCase() == 'scholar',
        UserFilter.teacher => user.role.toLowerCase() == 'teacher',
        UserFilter.student => user.role.toLowerCase() == 'student',
        UserFilter.verified => user.verified,
      };
      if (!matchesRole) return false;
      if (query.isEmpty) return true;
      return user.name.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query) ||
          user.accountId.toLowerCase().contains(query);
    }).toList(growable: false);
  }

  DashboardState copyWith({
    DashboardView? view,
    String? selectedUserId,
    String? selectedVerificationId,
    String? selectedCharityRequestId,
    bool clearSelectedUser = false,
    bool clearSelectedVerification = false,
    bool clearSelectedCharityRequest = false,
    String? searchQuery,
    UserFilter? userFilter,
    OverviewRange? overviewRange,
    List<ManagedUser>? users,
    List<VerificationApplication>? verificationApplications,
    List<CharityRequest>? charityRequests,
    List<OverviewQueueItem>? overviewQueue,
    bool? hasUnsavedUserChanges,
  }) {
    return DashboardState(
      view: view ?? this.view,
      selectedUserId: clearSelectedUser ? null : (selectedUserId ?? this.selectedUserId),
      selectedVerificationId: clearSelectedVerification ? null : (selectedVerificationId ?? this.selectedVerificationId),
      selectedCharityRequestId: clearSelectedCharityRequest ? null : (selectedCharityRequestId ?? this.selectedCharityRequestId),
      searchQuery: searchQuery ?? this.searchQuery,
      userFilter: userFilter ?? this.userFilter,
      overviewRange: overviewRange ?? this.overviewRange,
      users: users ?? this.users,
      verificationApplications: verificationApplications ?? this.verificationApplications,
      charityRequests: charityRequests ?? this.charityRequests,
      overviewQueue: overviewQueue ?? this.overviewQueue,
      hasUnsavedUserChanges: hasUnsavedUserChanges ?? this.hasUnsavedUserChanges,
    );
  }

  @override
  List<Object?> get props => [view, selectedUserId, selectedVerificationId, selectedCharityRequestId, searchQuery, userFilter, overviewRange, users, verificationApplications, charityRequests, overviewQueue, hasUnsavedUserChanges];
}

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit()
      : super(DashboardState(
          users: const [
            ManagedUser(
              id: 'abdullah',
              name: 'Abdullah Al-Farsi',
              email: 'abdullah.farsi@email.com',
              role: 'Scholar',
              status: 'Active',
              lastActivity: '2 minutes ago',
              detail: 'Viewed Tafseer EP 4',
              location: 'Dubai, UAE',
              joinDate: 'Oct 12, 2023 (14 months ago)',
              phone: '+971 50 123 4567',
              accountId: 'USR-7829-AF',
              mfaEnabled: true,
              moderatorEnabled: false,
              coursesCompleted: 156,
              currentStreakDays: 12,
              personalBestDays: 24,
              activity30Days: [8, 12, 17, 10, 21, 13, 19, 11, 16, 9, 14, 18],
              verified: true,
            ),
            ManagedUser(
              id: 'maryam',
              name: 'Maryam Saleh',
              email: 'maryam.s@academy.edu',
              role: 'Teacher',
              status: 'Active',
              lastActivity: '1 hour ago',
              detail: 'Uploaded quiz',
              location: 'Cairo, Egypt',
              joinDate: 'Jan 09, 2024 (10 months ago)',
              phone: '+20 102 334 1190',
              accountId: 'USR-4632-MS',
              mfaEnabled: true,
              moderatorEnabled: true,
              coursesCompleted: 83,
              currentStreakDays: 8,
              personalBestDays: 14,
              activity30Days: [6, 14, 9, 18, 16, 8, 13, 11, 15, 7, 9, 12],
              verified: true,
            ),
            ManagedUser(
              id: 'omar',
              name: 'Omar Zaid',
              email: 'omar.zaid@gmail.com',
              role: 'Student',
              status: 'Pending',
              lastActivity: 'Yesterday, 4:30 PM',
              detail: 'Registration submitted',
              location: 'Amman, Jordan',
              joinDate: 'Nov 01, 2024 (3 weeks ago)',
              phone: '+962 77 555 0189',
              accountId: 'USR-1193-OZ',
              mfaEnabled: false,
              moderatorEnabled: false,
              coursesCompleted: 9,
              currentStreakDays: 2,
              personalBestDays: 3,
              activity30Days: [0, 0, 4, 0, 5, 0, 2, 1, 0, 0, 3, 0],
              verified: false,
            ),
            ManagedUser(
              id: 'hamza',
              name: 'Hamza Ibrahim',
              email: 'hamza.ib@outlook.com',
              role: 'Student',
              status: 'Banned',
              lastActivity: 'Oct 20, 2023',
              detail: 'Account restricted',
              location: 'London, UK',
              joinDate: 'Apr 15, 2023 (19 months ago)',
              phone: '+44 7700 900321',
              accountId: 'USR-0402-HI',
              mfaEnabled: false,
              moderatorEnabled: false,
              coursesCompleted: 41,
              currentStreakDays: 0,
              personalBestDays: 11,
              activity30Days: [0, 1, 0, 0, 0, 2, 0, 0, 0, 0, 1, 0],
              verified: false,
            ),
            ManagedUser(
              id: 'sara',
              name: 'Sara Uthman',
              email: 'sara.uthman@web.me',
              role: 'Teacher',
              status: 'Active',
              lastActivity: '3 hours ago',
              detail: 'Graded assignments',
              location: 'Riyadh, Saudi Arabia',
              joinDate: 'Jun 11, 2023 (17 months ago)',
              phone: '+966 55 112 7788',
              accountId: 'USR-6201-SU',
              mfaEnabled: true,
              moderatorEnabled: false,
              coursesCompleted: 132,
              currentStreakDays: 10,
              personalBestDays: 18,
              activity30Days: [9, 15, 11, 17, 12, 16, 13, 14, 9, 12, 15, 16],
              verified: true,
            ),
          ],
          verificationApplications: const [
            VerificationApplication(
              id: 'sch-9942',
              name: 'Dr. Ahmad Rashid',
              title: 'PhD in Islamic Studies',
              summary: 'Al-Azhar University. Specializing in Fiqh and Hadith.',
              appliedAt: 'Applied 2h ago',
              fileName: 'PhD_Degree_AlAzhar_Rashid.pdf',
              status: 'pending',
              gender: 'Male',
              code: 'EG-00412',
            ),
            VerificationApplication(
              id: 'sch-8824',
              name: 'Sheikh Hamza Al-Faruq',
              title: 'Masters in Theology',
              summary: 'Madinah University. Certifications in Advanced Tafseer.',
              appliedAt: 'Applied 5h ago',
              fileName: 'Masters_Theology_Hamza.pdf',
              status: 'pending',
              gender: 'Male',
              code: 'SA-11220',
            ),
            VerificationApplication(
              id: 'sch-7711',
              name: 'Ustadha Fatima Zafar',
              title: 'Ijazah in Quranic Studies',
              summary: '15 years experience in teaching Seerah.',
              appliedAt: 'Applied yesterday',
              fileName: 'Ijazah_Fatima_Zafar.pdf',
              status: 'pending',
              gender: 'Female',
              code: 'PK-29031',
            ),
            VerificationApplication(
              id: 'sch-6603',
              name: 'Dr. Salman Khan',
              title: 'PhD in Comparative Religion',
              summary: 'Published author of Islamic History series.',
              appliedAt: 'Applied 2 days ago',
              fileName: 'PhD_ComparativeReligion_Salman.pdf',
              status: 'pending',
              gender: 'Male',
              code: 'AE-12550',
            ),
          ],
          charityRequests: const [
            CharityRequest(
              id: 'charity-gaza-relief',
              name: 'Gaza Emergency Relief',
              category: 'Global Medical Aid',
              solicitor: 'Al-Khidmat Foundation',
              amount: '\$250,000',
              progress: 0.40,
              submittedOn: 'Oct 26, 2023',
              status: 'PENDING DOCS',
              statusTone: CharityStatusTone.warning,
              icon: Icons.medical_services_outlined,
              iconColor: Color(0xFF1FF08D),
              iconBg: Color(0xFF0F4A35),
            ),
            CharityRequest(
              id: 'charity-orphan-edu',
              name: 'Orphan Education Support',
              category: 'Local Community Dev',
              solicitor: 'Islamic Relief UK',
              amount: '\$85,000',
              progress: 0.65,
              submittedOn: 'Oct 25, 2023',
              status: 'BACKGROUND CHECK',
              statusTone: CharityStatusTone.info,
              icon: Icons.school_outlined,
              iconColor: Color(0xFF6EC4FF),
              iconBg: Color(0xFF133E58),
            ),
            CharityRequest(
              id: 'charity-water-well',
              name: 'Water Well Project (Chad)',
              category: 'Essential Infrastructure',
              solicitor: 'Dr. Omar Suleiman (Indiv)',
              amount: '\$12,000',
              progress: 0.18,
              submittedOn: 'Oct 24, 2023',
              status: 'INITIAL REVIEW',
              statusTone: CharityStatusTone.neutral,
              icon: Icons.water_drop_outlined,
              iconColor: Color(0xFFE2C64A),
              iconBg: Color(0xFF51471D),
            ),
            CharityRequest(
              id: 'charity-winter-packs',
              name: 'Winter Food Packs',
              category: 'Syrian Refugee Support',
              solicitor: 'Human Appeal Intl.',
              amount: '\$500,000',
              progress: 0.88,
              submittedOn: 'Oct 22, 2023',
              status: 'PENDING DOCS',
              statusTone: CharityStatusTone.warning,
              icon: Icons.volunteer_activism_outlined,
              iconColor: Color(0xFFD6A8FF),
              iconBg: Color(0xFF49325F),
            ),
          ],
          overviewQueue: const [
            OverviewQueueItem(
              id: 'queue-sa',
              initials: 'SA',
              name: 'Sheikh Ahmed Al-Farsi',
              subtitle: 'PhD Islamic Jurisprudence',
              type: 'Scholar',
              date: 'Oct 24, 14:20',
              typePurple: false,
            ),
            OverviewQueueItem(
              id: 'queue-wr',
              initials: 'WR',
              name: 'Winter Relief Drive',
              subtitle: 'Human Appeal Intl.',
              type: 'Charity',
              date: 'Oct 24, 12:05',
              typePurple: true,
            ),
            OverviewQueueItem(
              id: 'queue-mk',
              initials: 'MK',
              name: 'Mufti Khalid Hussain',
              subtitle: 'Fatwa Department',
              type: 'Scholar',
              date: 'Oct 23, 18:45',
              typePurple: false,
            ),
          ],
        ));

  void openOverview() => emit(state.copyWith(view: DashboardView.overview, clearSelectedUser: true, clearSelectedVerification: true, clearSelectedCharityRequest: true));

  void openUserManagement() => emit(state.copyWith(view: DashboardView.userManagement, clearSelectedUser: true, clearSelectedVerification: true, clearSelectedCharityRequest: true, hasUnsavedUserChanges: false));

  void openUserDetails(String userId) => emit(state.copyWith(view: DashboardView.userManagement, selectedUserId: userId));

  void backToUsers() => emit(state.copyWith(view: DashboardView.userManagement, clearSelectedUser: true, clearSelectedVerification: true, clearSelectedCharityRequest: true, hasUnsavedUserChanges: false));

  void openMedia() => emit(state.copyWith(view: DashboardView.media, clearSelectedUser: true, clearSelectedVerification: true, clearSelectedCharityRequest: true));

  void openWeeklyGoals() => emit(state.copyWith(view: DashboardView.weeklyGoals, clearSelectedUser: true, clearSelectedVerification: true, clearSelectedCharityRequest: true));

  void openVerificationRequests() => emit(state.copyWith(view: DashboardView.verificationRequests, clearSelectedUser: true, clearSelectedVerification: true, clearSelectedCharityRequest: true));

  void openCharityApprovals() => emit(state.copyWith(view: DashboardView.charityApprovals, clearSelectedUser: true, clearSelectedVerification: true, clearSelectedCharityRequest: true));

  void openAbuseReports() => emit(state.copyWith(view: DashboardView.abuseReports, clearSelectedUser: true, clearSelectedVerification: true, clearSelectedCharityRequest: true));

  void openSystemSettings() => emit(state.copyWith(view: DashboardView.systemSettings, clearSelectedUser: true, clearSelectedVerification: true, clearSelectedCharityRequest: true));

  void openVerificationDocument(String applicationId) {
    emit(state.copyWith(view: DashboardView.verificationRequests, selectedVerificationId: applicationId));
  }

  void closeVerificationDocument() {
    emit(state.copyWith(view: DashboardView.verificationRequests, clearSelectedVerification: true));
  }

  void openCharityRequestDetail(String requestId) {
    emit(state.copyWith(view: DashboardView.charityApprovals, selectedCharityRequestId: requestId));
  }

  void closeCharityRequestDetail() {
    emit(state.copyWith(view: DashboardView.charityApprovals, clearSelectedCharityRequest: true));
  }

  void approveVerification([String? applicationId]) {
    _patchVerification(applicationId ?? state.selectedVerificationId, (app) => app.copyWith(status: 'approved', viewed: true));
    closeVerificationDocument();
  }

  void rejectVerification([String? applicationId]) {
    _patchVerification(applicationId ?? state.selectedVerificationId, (app) => app.copyWith(status: 'rejected', viewed: true));
    closeVerificationDocument();
  }

  void requestMoreInfo() {
    _patchVerification(state.selectedVerificationId, (app) => app.copyWith(status: 'more_info', viewed: true));
    closeVerificationDocument();
  }

  void markAllVerificationViewed() {
    final updated = state.verificationApplications.map((app) => app.copyWith(viewed: true)).toList(growable: false);
    emit(state.copyWith(verificationApplications: updated));
  }

  void toggleVerificationChecklist({
    bool? idMatch,
    bool? degreeAuthenticity,
    bool? backgroundCheck,
  }) {
    _patchVerification(
      state.selectedVerificationId,
      (app) => app.copyWith(
        idMatch: idMatch,
        degreeAuthenticity: degreeAuthenticity,
        backgroundCheck: backgroundCheck,
      ),
    );
  }

  void updateVerificationNotes(String notes) {
    _patchVerification(state.selectedVerificationId, (app) => app.copyWith(notes: notes));
  }

  void setSearchQuery(String query) => emit(state.copyWith(searchQuery: query));

  void setUserFilter(UserFilter filter) => emit(state.copyWith(userFilter: filter));
  void setOverviewRange(OverviewRange range) => emit(state.copyWith(overviewRange: range));

  void approveOverviewQueueItem(String itemId) {
    final updated = state.overviewQueue.where((item) => item.id != itemId).toList(growable: false);
    emit(state.copyWith(overviewQueue: updated));
  }

  void rejectOverviewQueueItem(String itemId) {
    final updated = state.overviewQueue.where((item) => item.id != itemId).toList(growable: false);
    emit(state.copyWith(overviewQueue: updated));
  }

  void createNewContent() {
    final newId = 'queue-new-${DateTime.now().microsecondsSinceEpoch}';
    final updated = [
      OverviewQueueItem(
        id: newId,
        initials: 'NC',
        name: 'New Content Submission',
        subtitle: 'Editorial Desk',
        type: 'Scholar',
        date: 'Just now',
        typePurple: false,
      ),
      ...state.overviewQueue,
    ];
    emit(state.copyWith(overviewQueue: updated));
  }

  void updateSelectedRole(String role) => _patchSelectedUser((user) => user.copyWith(role: role));

  void toggleSelectedMfa(bool enabled) => _patchSelectedUser((user) => user.copyWith(mfaEnabled: enabled));

  void toggleSelectedModerator(bool enabled) => _patchSelectedUser((user) => user.copyWith(moderatorEnabled: enabled));

  void banSelectedUser() => _patchSelectedUser((user) => user.copyWith(status: 'Banned', detail: 'Account restricted'));

  void resetSelectedPassword() => _patchSelectedUser((user) => user.copyWith(detail: 'Password reset requested'));

  void saveSelectedUserChanges() => emit(state.copyWith(hasUnsavedUserChanges: false));

  void approveCharityRequest(String requestId) {
    _patchCharityRequest(
      requestId,
      (request) => request.copyWith(
        status: 'APPROVED',
        statusTone: CharityStatusTone.success,
      ),
    );
    if (state.selectedCharityRequestId == requestId) {
      closeCharityRequestDetail();
    }
  }

  void rejectCharityRequest(String requestId) {
    _patchCharityRequest(
      requestId,
      (request) => request.copyWith(
        status: 'REJECTED',
        statusTone: CharityStatusTone.danger,
      ),
    );
    if (state.selectedCharityRequestId == requestId) {
      closeCharityRequestDetail();
    }
  }

  void _patchSelectedUser(ManagedUser Function(ManagedUser user) transform) {
    final selectedId = state.selectedUserId;
    if (selectedId == null) return;
    final updatedUsers = state.users
        .map((user) => user.id == selectedId ? transform(user) : user)
        .toList(growable: false);
    emit(state.copyWith(users: updatedUsers, hasUnsavedUserChanges: true));
  }

  void _patchVerification(
    String? applicationId,
    VerificationApplication Function(VerificationApplication app) transform,
  ) {
    if (applicationId == null) return;
    final updated = state.verificationApplications
        .map((app) => app.id == applicationId ? transform(app) : app)
        .toList(growable: false);
    emit(state.copyWith(verificationApplications: updated));
  }

  void _patchCharityRequest(
    String requestId,
    CharityRequest Function(CharityRequest request) transform,
  ) {
    final updated = state.charityRequests
        .map((request) => request.id == requestId ? transform(request) : request)
        .toList(growable: false);
    emit(state.copyWith(charityRequests: updated));
  }
}
