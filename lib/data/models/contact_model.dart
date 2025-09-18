class Contact {
  final String name;
  final String phone;
  final DateTime lastSeen;
  final String? avatarUrl;
  final bool isMuted;

  Contact({
    required this.name,
    required this.phone,
    required this.lastSeen,
    this.avatarUrl,
    required this.isMuted,
  });
}
