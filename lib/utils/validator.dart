class Validators {
  static final RegExp _emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return 'required';
    if (value.trim().length < 2) return 'so short';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'required';
    if (!_emailRegex.hasMatch(value.trim())) return 'not correct';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'required';
    if (value.length < 6) return 'must long than 8 digits';
    return null;
  }

  static String? Function(String?) confirmPassword(String Function() original) {
    return (String? value) {
      if (value == null || value.isEmpty) return 'required';
      if (value != original()) return 'does not match';
      return null;
    };
  }
}
