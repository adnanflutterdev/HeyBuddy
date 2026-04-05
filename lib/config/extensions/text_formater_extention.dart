extension TextFormater on String {
  String get capitalizeFirst {
    if (length < 2) {
      return toUpperCase();
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
