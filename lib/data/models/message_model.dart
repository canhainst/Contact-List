import 'package:contact_list/data/models/contact_model.dart';

class Message {
  final String content;
  final DateTime time;
  final Contact? contact;

  Message({required this.content, required this.time, required this.contact});
}
