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
    ),
    Contact(
      name: "Bob",
      phone: "444-555-666",
      lastSeen: DateTime.now(),
      avatarUrl:
          'https://img.tripi.vn/cdn-cgi/image/width=700,height=700/https://gcs.tripi.vn/public-tripi/tripi-feed/img/482812Fuv/anh-mo-ta.png',
    ),
    Contact(
      name: "Charlie",
      phone: "777-888-999",
      lastSeen: DateTime.now().subtract(const Duration(days: 40)),
    ),
    Contact(
      name: "David",
      phone: "123-456-789",
      lastSeen: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    Contact(
      name: "Eve",
      phone: "987-654-321",
      lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Contact(
      name: "Frank",
      phone: "555-666-777",
      lastSeen: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
    ),
    Contact(
      name: "Grace",
      phone: "111-999-888",
      lastSeen: DateTime.now().subtract(const Duration(minutes: 90)),
    ),
    Contact(
      name: "Hannah",
      phone: "222-333-444",
      lastSeen: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Contact(
      name: "Ian",
      phone: "333-444-555",
      lastSeen: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Contact(
      name: "Jack",
      phone: "444-555-666",
      lastSeen: DateTime.now().subtract(const Duration(days: 20)),
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
}
