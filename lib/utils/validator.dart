class Validators {
  static final RegExp _emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return 'اكتب الاسم';
    if (value.trim().length < 2) return 'الاسم قصير أوي';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'اكتب الإيميل';
    if (!_emailRegex.hasMatch(value.trim())) return 'الإيميل مش صحيح';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'اكتب الباسورد';
    if (value.length < 6) return 'الباسورد لازم 6 حروف على الأقل';
    return null;
  }

  static String? Function(String?) confirmPassword(String Function() original) {
    return (String? value) {
      if (value == null || value.isEmpty) return 'أكد الباسورد';
      if (value != original()) return 'الباسورد مش متطابق';
      return null;
    };
  }
}
