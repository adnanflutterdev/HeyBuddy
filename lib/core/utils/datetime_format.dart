import 'package:intl/intl.dart';

class DatetimeFormat {
  static String format(DateTime dateTime) {
    final now = DateTime.now();
    final time = DateFormat.jm().format(dateTime);

    final sameYear = now.year == dateTime.year;

    if (isSameDay(now, dateTime)) {
      return 'Today, $time';
    }
    if (isSameDay(now.subtract(const Duration(days: 1)), dateTime)) {
      return 'Yesterday, $time';
    }
    String? weekDay = _getWeekDayName(dateTime);

    if (weekDay != null) {
      return '$weekDay, $time';
    }
    if (sameYear) {
      return '${DateFormat.MMMd().format(dateTime)}, $time';
    }
    return DateFormat.yMMMd().format(dateTime);
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return (a.day == b.day) && (a.month == b.month) && (a.year == b.year);
  }

  static String? _getWeekDayName(DateTime dateTime) {
    final now = DateTime.now();
    for (int x = 2; x <= 6; x++) {
      final nDate = now.subtract(Duration(days: x));
      if (isSameDay(nDate, dateTime)) {
        return DateFormat.EEEE().format(nDate);
      }
    }
    return null;
  }
}
