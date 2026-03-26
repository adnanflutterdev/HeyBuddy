class AuthResponseEntity {
  final bool success;
  final String message;

  AuthResponseEntity({required this.success, required this.message});

  factory AuthResponseEntity.success(String message) {
    return AuthResponseEntity(success: true, message: message);
  }
  factory AuthResponseEntity.failure(String message) {
    return AuthResponseEntity(success: false, message: message);
  }
}
