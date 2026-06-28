List<String> getUserNameQueries(String name) {
  List<String> nameSearchQuery = [];
  int startPoint = 0;
  while (startPoint <= name.length - 3) {
    for (int x = startPoint; x < name.length; x++) {
      final result = name.substring(startPoint, x + 1).trim();
      if (result.isNotEmpty &&
          !nameSearchQuery.contains(result) &&
          result.length > 2) {
        nameSearchQuery.add(result);
      }
    }
    startPoint++;
  }
  return nameSearchQuery;
}
