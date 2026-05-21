class Result<D> {
  final bool success;
  final String message;
  final D? data;

  Result({required this.success, required this.message, this.data});

  factory Result.success({required String message, D? data}) {
    return Result(success: true, message: message, data: data);
  }
  factory Result.failure(String message) {
    return Result(success: false, message: message);
  }
}
