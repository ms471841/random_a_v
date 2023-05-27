String generateUniqueUserId() {
  final DateTime now = DateTime.now();
  final String timestamp = now.microsecondsSinceEpoch.toString();
  return timestamp;
}
