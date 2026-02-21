import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/providers/theme_mode_provider.dart';
import '../../../shared/widgets/admin_scaffold.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../../../shared/widgets/section_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminScaffold(title: 'Settings', body: _SettingsBody());
  }
}

class _SettingsBody extends ConsumerStatefulWidget {
  const _SettingsBody();

  @override
  ConsumerState<_SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends ConsumerState<_SettingsBody> {
  static const _storageKey = 'admin_settings_realtime_v1';
  static const _defaults = {
    'themePreset': 'System',
    'timezone': 'UTC',
    'language': 'English',
    'maintenanceMode': false,
    'forceMfaAdmins': true,
    'sessionTimeout': true,
    'publicSignup': false,
    'autoModeration': true,
    'profanityFilter': true,
    'abuseDetection': true,
    'pushNotifications': true,
    'emailNotifications': true,
    'webhookNotifications': false,
    'webhookUrl': '',
    'privacyPolicyUrl': '',
    'termsUrl': '',
  };

  bool _loading = true;
  Map<String, dynamic> _data = Map<String, dynamic>.from(_defaults);
  Map<String, dynamic> _previous = {};

  final _webhookCtl = TextEditingController();
  final _privacyCtl = TextEditingController();
  final _termsCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _previous = Map<String, dynamic>.from(_data);
    _hydrateControllers();
    _load();
  }

  @override
  void dispose() {
    _webhookCtl.dispose();
    _privacyCtl.dispose();
    _termsCtl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      _data = Map<String, dynamic>.from(jsonDecode(raw) as Map);
      _previous = Map<String, dynamic>.from(_data);
      _hydrateControllers();
    }
    await ref
        .read(themeModeProvider.notifier)
        .setThemeMode(_themeFromPreset(_data['themePreset'] as String));
    if (!mounted) return;
    setState(() => _loading = false);
  }

  void _hydrateControllers() {
    _webhookCtl.text = (_data['webhookUrl'] ?? '').toString();
    _privacyCtl.text = (_data['privacyPolicyUrl'] ?? '').toString();
    _termsCtl.text = (_data['termsUrl'] ?? '').toString();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(_data));
  }

  void _set(String key, dynamic value) {
    setState(() {
      _previous = Map<String, dynamic>.from(_data);
      _data[key] = value;
    });
    _persist();
  }

  ThemeMode _themeFromPreset(String preset) {
    return switch (preset) {
      'Light' => ThemeMode.light,
      'Dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> _setTheme(String preset) async {
    _set('themePreset', preset);
    await ref
        .read(themeModeProvider.notifier)
        .setThemeMode(_themeFromPreset(preset));
  }

  Future<void> _rollbackLatest() async {
    final ok = await showConfirmDialog(
      context,
      title: 'Rollback latest change?',
      message: 'This restores the previous settings snapshot.',
    );
    if (!ok) return;
    setState(() {
      _data = Map<String, dynamic>.from(_previous);
      _hydrateControllers();
    });
    await _persist();
    await ref
        .read(themeModeProvider.notifier)
        .setThemeMode(_themeFromPreset(_data['themePreset'] as String));
  }

  Future<void> _resetDefaults() async {
    final ok = await showConfirmDialog(
      context,
      title: 'Reset to defaults?',
      message: 'All settings will be replaced with default values.',
    );
    if (!ok) return;
    final defaults = Map<String, dynamic>.from(_defaults);
    setState(() {
      _previous = Map<String, dynamic>.from(_data);
      _data = Map<String, dynamic>.from(defaults);
      _hydrateControllers();
    });
    await _persist();
    await ref
        .read(themeModeProvider.notifier)
        .setThemeMode(_themeFromPreset(_data['themePreset'] as String));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    return ListView(
      children: [
        const SectionCard(
            title: 'Mode', child: Text('All settings are saved in realtime.')),
        const SizedBox(height: 12),
        SectionCard(
          title: 'General',
          child: Wrap(spacing: 10, runSpacing: 10, children: [
            SizedBox(
                width: 180,
                child: _Dropdown(
                    label: 'Theme',
                    value: _data['themePreset'],
                    items: const ['System', 'Light', 'Dark'],
                    onChanged: (v) => _setTheme(v!))),
            SizedBox(
                width: 180,
                child: _Dropdown(
                    label: 'Timezone',
                    value: _data['timezone'],
                    items: const ['UTC', 'Asia/Karachi', 'Europe/London'],
                    onChanged: (v) => _set('timezone', v))),
            SizedBox(
                width: 180,
                child: _Dropdown(
                    label: 'Language',
                    value: _data['language'],
                    items: const ['English', 'Arabic', 'Urdu'],
                    onChanged: (v) => _set('language', v))),
            _toggle('Maintenance Mode', 'maintenanceMode'),
          ]),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: 'Security',
          child: Column(children: [
            _toggle('Require MFA for Admin', 'forceMfaAdmins'),
            _toggle('Enable Session Timeout', 'sessionTimeout'),
            _toggle('Allow Public Signup', 'publicSignup'),
          ]),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: 'Moderation',
          child: Column(children: [
            _toggle('Auto Moderation', 'autoModeration'),
            _toggle('Profanity Filter', 'profanityFilter'),
            _toggle('Abuse Detection', 'abuseDetection'),
          ]),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: 'Notifications',
          child: Column(children: [
            _toggle('Push Notifications', 'pushNotifications'),
            _toggle('Email Notifications', 'emailNotifications'),
            _toggle('Webhook Notifications', 'webhookNotifications'),
            TextField(
                controller: _webhookCtl,
                decoration: const InputDecoration(labelText: 'Webhook URL'),
                onChanged: (v) => _set('webhookUrl', v)),
          ]),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: 'Legal URLs',
          child: Column(children: [
            TextField(
                controller: _privacyCtl,
                decoration:
                    const InputDecoration(labelText: 'Privacy Policy URL'),
                onChanged: (v) => _set('privacyPolicyUrl', v)),
            const SizedBox(height: 8),
            TextField(
                controller: _termsCtl,
                decoration: const InputDecoration(labelText: 'Terms URL'),
                onChanged: (v) => _set('termsUrl', v)),
          ]),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: 'Danger Zone',
          child: Wrap(spacing: 8, runSpacing: 8, children: [
            OutlinedButton.icon(
                onPressed: _rollbackLatest,
                icon: const Icon(Icons.restore),
                label: const Text('Rollback Latest')),
            FilledButton.tonalIcon(
                onPressed: _resetDefaults,
                icon: const Icon(Icons.warning_amber_outlined),
                label: const Text('Reset Defaults')),
          ]),
        ),
      ],
    );
  }

  Widget _toggle(String label, String key) {
    return SwitchListTile.adaptive(
      value: (_data[key] as bool?) ?? false,
      onChanged: (v) => _set(key, v),
      title: Text(label),
      contentPadding: EdgeInsets.zero,
    );
  }
}

class _Dropdown extends StatelessWidget {
  const _Dropdown(
      {required this.label,
      required this.value,
      required this.items,
      required this.onChanged});

  final String label;
  final dynamic value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value as String?,
      decoration: InputDecoration(labelText: label),
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }
}
