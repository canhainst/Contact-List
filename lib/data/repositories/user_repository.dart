import 'package:contact_list/data/models/call_model.dart';
import 'package:contact_list/data/models/contact_model.dart';
import 'package:contact_list/data/models/user_model.dart';

class UserRepository {
  // Mock login
  Future<User?> login(String username, String password) async {
    await Future.delayed(Duration(seconds: 1)); // simulate network delay
    if (username == "admin" && password == "1234") {
      return User(username: username, token: "fake_token_123");
    }
    return null;
  }

  // Mock contact list
  List<Contact> contacts = [
    Contact(
      name: "Alice",
      phone: "111-222-333",
      lastSeen: DateTime.now().subtract(const Duration(minutes: 40)),
      isMuted: false,
    ),
    Contact(
      name: "Bob",
      phone: "444-555-666",
      lastSeen: DateTime.now(),
      isMuted: false,

      avatarUrl:
          'https://img.tripi.vn/cdn-cgi/image/width=700,height=700/https://gcs.tripi.vn/public-tripi/tripi-feed/img/482812Fuv/anh-mo-ta.png',
    ),
    Contact(
      name: "Charlie",
      phone: "777-888-999",
      lastSeen: DateTime.now().subtract(const Duration(days: 40)),
      isMuted: false,
    ),
    Contact(
      name: "David",
      phone: "123-456-789",
      lastSeen: DateTime.now().subtract(const Duration(minutes: 5)),
      isMuted: false,
    ),
    Contact(
      name: "Eve",
      phone: "987-654-321",
      lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
      isMuted: false,
    ),
    Contact(
      name: "Frank",
      phone: "555-666-777",
      lastSeen: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      isMuted: true,
    ),
    Contact(
      name: "Grace",
      phone: "111-999-888",
      lastSeen: DateTime.now().subtract(const Duration(minutes: 90)),
      isMuted: true,
    ),
    Contact(
      name: "Hannah",
      phone: "222-333-444",
      lastSeen: DateTime.now().subtract(const Duration(days: 10)),
      isMuted: true,
    ),
    Contact(
      name: "Ian",
      phone: "333-444-555",
      lastSeen: DateTime.now().subtract(const Duration(hours: 5)),
      isMuted: false,
    ),
    Contact(
      name: "Jack",
      phone: "444-555-666",
      lastSeen: DateTime.now().subtract(const Duration(days: 20)),
      isMuted: false,
    ),
  ];

  Future<List<Contact>> fetchContacts({
    String sortBy = 'lastSeen',
    String query = '',
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    List<Contact> sorted = List<Contact>.from(contacts);

    if (sortBy == 'name') {
      sorted.sort((a, b) => a.name.compareTo(b.name));
    } else {
      sorted.sort((a, b) => b.lastSeen.compareTo(a.lastSeen));
    }

    if (query.isNotEmpty) {
      sorted = sorted
          .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    return sorted;
  }

  // Mock call history
  List<Call> calls = [];

  UserRepository() {
    // Tạo dữ liệu mock call
    final now = DateTime.now();
    calls = [
      Call(
        contact: contacts[0],
        isMissed: false,
        startTime: now.subtract(const Duration(minutes: 5)),
        duration: const Duration(minutes: 12),
      ),
      Call(
        contact: contacts[1],
        isMissed: true,
        startTime: now.subtract(const Duration(hours: 2)),
        duration: Duration.zero,
      ),
      Call(
        contact: contacts[2],
        isMissed: false,
        startTime: now.subtract(const Duration(days: 1, hours: 3)),
        duration: const Duration(minutes: 5),
      ),
      Call(
        contact: contacts[3],
        isMissed: true,
        startTime: now.subtract(const Duration(days: 2)),
        duration: Duration.zero,
      ),
      Call(
        contact: contacts[4],
        isMissed: false,
        startTime: now.subtract(const Duration(days: 3, hours: 4)),
        duration: const Duration(minutes: 20),
      ),
      Call(
        contact: contacts[5],
        isMissed: true,
        startTime: now.subtract(const Duration(days: 5)),
        duration: Duration.zero,
      ),
      Call(
        contact: contacts[6],
        isMissed: false,
        startTime: now.subtract(const Duration(minutes: 90)),
        duration: const Duration(minutes: 7),
      ),
      Call(
        contact: contacts[7],
        isMissed: false,
        startTime: now.subtract(const Duration(days: 10, hours: 2)),
        duration: const Duration(minutes: 15),
      ),
      Call(
        contact: contacts[8],
        isMissed: true,
        startTime: now.subtract(const Duration(hours: 5, minutes: 30)),
        duration: Duration.zero,
      ),
      Call(
        contact: contacts[9],
        isMissed: false,
        startTime: now.subtract(const Duration(days: 20, hours: 1)),
        duration: const Duration(minutes: 30),
      ),
    ];
  }

  Future<List<Call>> fetchCalls({int limit = 50}) async {
    await Future.delayed(const Duration(milliseconds: 300));

    calls.sort((a, b) => b.startTime.compareTo(a.startTime));

    return calls.take(limit).toList();
  }
}
