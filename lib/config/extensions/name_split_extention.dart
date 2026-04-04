extension NameSplitExtention on String {
  (String first, String last) get splitName {
    final parts = split(' ');

    return (
      parts.isNotEmpty ? '${parts[0]} ' : '',
      parts.length > 1 ? parts.sublist(1).join(' ') : '',
    );
  }
}
