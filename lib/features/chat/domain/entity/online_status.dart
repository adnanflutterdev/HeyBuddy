abstract class OnlineStatus {
  final bool isOnline;
  final DateTime? lastSeen;

  OnlineStatus({required this.isOnline, required this.lastSeen});
}
