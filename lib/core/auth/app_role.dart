enum AppRole {
  superAdmin('super_admin'),
  admin('admin'),
  scholar('scholar');

  const AppRole(this.value);
  final String value;

  static AppRole? fromString(String? value) {
    if (value == null) return null;
    for (final role in AppRole.values) {
      if (role.value == value) return role;
    }
    return null;
  }
}
