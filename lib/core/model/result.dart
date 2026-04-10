class Result {
  final bool success;
  final String message;

  Result({required this.success, required this.message});

  factory Result.success(String message) {
    return Result(success: true, message: message);
  }
  factory Result.failure(String message) {
    return Result(success: false, message: message);
  }
}
