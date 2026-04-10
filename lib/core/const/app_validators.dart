class AppValidators {
  AppValidators._();

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }

    final trimmed = value.trim();

    if (trimmed.length < 2) {
      return 'Name must be at least 2 characters';
    }

    if (trimmed.length > 50) {
      return 'Name must be less than 50 characters';
    }

    final regExp = RegExp(r'^[A-Z][a-zA-Z ]+$');

    if (!regExp.hasMatch(trimmed)) {
      return 'Name must start with a capital letter and contain only letters';
    }

    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final trimmed = value.trim();

    final regExp = RegExp(
      r"^[a-zA-Z0-9]+([._%+-]?[a-zA-Z0-9]+)*@"
      r"[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+$",
    );

    if (!regExp.hasMatch(trimmed)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    final trimmed = value.trim();

    if (trimmed.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (trimmed.length > 20) {
      return 'Password must not exceed 20 characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(trimmed)) {
      return 'Password must contain at least 1 uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(trimmed)) {
      return 'Password must contain at least 1 lowercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(trimmed)) {
      return 'Password must contain at least 1 number';
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(trimmed)) {
      return 'Password must contain at least 1 special character';
    }

    return null;
  }

  static String? address(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    if (value.trim().length < 5) {
      return 'Address must be at least 5 characters';
    }

    if (value.trim().length > 50) {
      return 'Address must be less than 50 characters';
    }

    return null;
  }

  static String? bio(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    if (value.trim().length < 5) {
      return 'Bio must be at least 5 characters';
    }

    if (value.trim().length > 200) {
      return 'Bio must be less than 200 characters';
    }

    return null;
  }

  static String? url(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final regExp = RegExp(
      r'^(https?:\/\/)([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}([\/^\s]*)?$',
    );
    if (!regExp.hasMatch(value)) {
      return 'Enter a valid url';
    }

    return null;
  }
}
