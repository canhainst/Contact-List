import 'package:contact_list/data/models/contact_model.dart';

class Call {
  final Contact contact;
  final bool isMissed;
  final DateTime startTime;
  final Duration duration;

  Call({
    required this.contact,
    required this.isMissed,
    required this.startTime,
    required this.duration,
  });
}
