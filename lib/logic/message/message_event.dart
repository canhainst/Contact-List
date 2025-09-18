import 'package:contact_list/data/models/contact_model.dart';

abstract class MessageEvent {}

class LoadConversations extends MessageEvent {}

class LoadMessagesWithContact extends MessageEvent {
  final Contact contact;
  LoadMessagesWithContact(this.contact);
}

class SearchConversations extends MessageEvent {
  final String query;
  SearchConversations(this.query);
}

class SendMessage extends MessageEvent {
  final Contact? contact; // nếu null nghĩa là mình gửi (outgoing)
  final String content;

  SendMessage({required this.contact, required this.content});
}

class DeleteConversation extends MessageEvent {
  final Contact contact;
  DeleteConversation(this.contact);
}
