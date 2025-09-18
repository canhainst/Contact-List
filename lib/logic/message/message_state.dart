import 'package:contact_list/data/models/contact_model.dart';
import 'package:contact_list/data/models/message_model.dart';

abstract class MessageState {}

class MessageInitial extends MessageState {}

class MessageLoading extends MessageState {}

class ConversationsLoaded extends MessageState {
  final Map<Contact, List<Message>> conversations;
  final Map<Contact, List<Message>> filtered;

  ConversationsLoaded(
    this.conversations, {
    Map<Contact, List<Message>>? filtered,
  }) : filtered = filtered ?? conversations;
}

class MessagesLoaded extends MessageState {
  final List<Message> messages;
  MessagesLoaded(this.messages);
}

class MessageError extends MessageState {
  final String message;
  MessageError(this.message);
}
