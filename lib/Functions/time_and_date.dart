List dateTime() {
  DateTime dt = DateTime.now();
  String meridian = dt.hour < 12 ? 'AM' : 'PM';
  int hr = dt.hour > 12 ? dt.hour - 12 : dt.hour;
  int min = dt.minute;
  String time = '${hr < 10 ? '0$hr' : hr}:${min < 10 ? '0$min' : min} $meridian';
  String date = '${dt.day < 10 ? '0${dt.day}' : dt.day}/${dt.month < 10 ? '0${dt.month}' : dt.month}/${dt.year}';
  return [dt.second, time, date];
}
